//
//  EventList.swift
//  CritiCalUI
//
//  Created by Scott Matthewman on 20/09/2025.
//

import SwiftUI
import SwiftData
import CritiCalModels

extension Date {
    static let tagFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        f.calendar = Calendar(identifier: .gregorian)
        return f
    }()

    var tagValue: String {
        Self.tagFormatter.string(from: self)
    }
}

public struct EventList: View {
    @Binding private var scrollPosition: String?

    @Environment(\.calendar) private var calendar

    // Accept events as parameter instead of querying directly
    private let events: [Event]
    private var onEventSelected: (UUID) -> Void
    private var interval: DateInterval

    public init(
        events: [Event],
        within interval: DateInterval,
        scrollPosition: Binding<String?>,
        onEventSelected: @escaping (UUID) -> Void
    ) {
        self.events = events
        self.onEventSelected = onEventSelected
        self.interval = interval
        self._scrollPosition = scrollPosition
    }

    public var body: some View {
        ScrollViewReader { scrollView in
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
                            .listRowSeparator(.hidden)
                        }
                    } header: {
                        sectionHeader(for: section.day, in: Date.now)
                            .padding(.bottom, -8)
                    }
                    .id(section.day.tagValue)
                    .listSectionMargins(.all, 0)
                    .listSectionSpacing(.compact)
                    .listSectionSeparator(.hidden)
                }
            }
            .listStyle(.plain)
            .onChange(of: scrollPosition) {
                guard let scrollPosition else { return }

                let availableAnchors = eventsGroupedByDate.map(\.day).map(\.tagValue)
                let requiredAnchor = availableAnchors.first { $0 >= scrollPosition }

                withAnimation {
                    scrollView.scrollTo(requiredAnchor, anchor: .top)
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
        let grouped = Dictionary(grouping: events.map { $0.detached() }) { detached in
            calendar.startOfDay(for: detached.date)
        }
        return grouped.map { (day, events) in
            EventSection(day: day, events: events.sorted { $0.date < $1.date })
        }
        .sorted { $0.day < $1.day }
    }

    @ViewBuilder
    private func sectionHeader(for day: Date, in sourceDate: Date) -> some View {
        let isToday = calendar.isDateInToday(day)
        let isTomorrow = calendar.isDateInTomorrow(day)
        let wholeDay = calendar.dateInterval(of: .day, for: day)!
        let isOutsideInterval = interval.intersection(with: wholeDay) == nil

        HStack {
            Text(day, format: .dateTime.weekday(.wide))
                .foregroundStyle(
                    calendar
                        .isDateInToday(
                            day
                        ) ? .secondary : .primary
                )
            Text(day, format: .dateTime.day())
                .foregroundStyle(.secondary)
                .fontWeight(.light)
            if isOutsideInterval {
                Text(day, format: .dateTime.month())
            }
            Spacer()
            if isToday {
                Text("Today")
                    .textCase(.uppercase)
            } else if isTomorrow {
                Text("Tomorrow")
                    .textCase(.uppercase)
            }
        }
    }
}

#Preview(traits: .sampleData) {
    @Previewable @State var scrollPosition: String?

    let range = Calendar.current.dateInterval(of: .year, for: .now)!
    NavigationStack {
        EventList(events: [], within: range, scrollPosition: $scrollPosition) {
            print("ID selected: \($0)")
        }
    }
}
