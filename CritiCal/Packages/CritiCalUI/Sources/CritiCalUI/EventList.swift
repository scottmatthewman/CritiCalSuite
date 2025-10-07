//
//  EventList.swift
//  CritiCalUI
//
//  Created by Scott Matthewman on 20/09/2025.
//

import SwiftUI
import SwiftData
import CritiCalModels

public struct EventList: View {
    // Use @Query to efficiently load events directly from SwiftData
    @Query private var events: [Event]
    private var onEventSelected: (UUID) -> Void

    public init(
        timeframe: EventTimeframe = .future,
        within interval: DateInterval,
        onEventSelected: @escaping (UUID) -> Void
    ) {
        self.onEventSelected = onEventSelected
        let predicate: Predicate<Event> = #Predicate {
            $0.date >= interval.start && $0.date < interval.end
        }
        _events = Query(
            filter: predicate,
            sort: \.date,
            order: .forward
        )
    }

    public var body: some View {
        Group {
            if events.isEmpty {
                ScrollView {
                    ContentUnavailableView {
                        Label("No Events", systemImage: "calendar")
                    } description: {
                        Text("No events")
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .defaultScrollAnchor(.center)
            } else {
                List {
                    ForEach(eventsGroupedByDate) { section in
                        Section {
                            ForEach(section.events) { event in
                                Button {
                                    onEventSelected(event.id)
                                } label: {
                                    EventListDetail(event: event)
                                }
                                .buttonStyle(.plain)
                            }
                        } header: {
                            Text(section.day,
                                 format: .dateTime.weekday(.wide).day().month())
                        }
                    }
                }
            }
        }
    }

    struct EventSection: Identifiable {
        var day: Date
        var events: [DetachedEvent]

        var id: Date { day }
    }

    var eventsGroupedByDate: [EventSection] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: events.map { $0.detached() }) { detached in
            calendar.startOfDay(for: detached.date)
        }
        return grouped.map { (day, events) in
            EventSection(day: day, events: events.sorted { $0.date < $1.date })
        }
        .sorted { $0.day < $1.day }
    }
}

#Preview(traits: .sampleData) {
    let range = Calendar.current.dateInterval(of: .year, for: .now)!
    NavigationStack {
        EventList(within: range) {
            print("ID selected: \($0)")
        }
    }
}
