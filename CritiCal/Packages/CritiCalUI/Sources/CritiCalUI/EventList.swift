//
//  EventList.swift
//  CritiCalUI
//
//  Created by Scott Matthewman on 20/09/2025.
//

import CritiCalModels
import CritiCalNavigation
import SwiftData
import SwiftUI

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

    static func fromTagValue(_ tag: String) -> Date? {
        tagFormatter.date(from: tag)
    }
}

public struct EventList: View {
    @Environment(\.calendar) private var calendar
    @Environment(NavigationRouter.self) private var router

    @State private var scrollPosition = ScrollPosition(idType: String.self)
    @Binding private var selectedDate: Date
    @State private var changingDateProgrammatically = false

    // Accept events as parameter instead of querying directly
    private let events: [Event]
    private var interval: DateInterval

    public init(
        events: [Event],
        within interval: DateInterval,
        selectedDate: Binding<Date>,
    ) {
        self.events = events
        self.interval = interval
        self._selectedDate = selectedDate
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(eventsGroupedByDate) { section in
                    Section {
                        ForEach(section.events) { event in
                            NavigationLink(
                                value: NavigationRouter.EventTabRoute
                                    .event(event)
                            ) {
                                EventListDetail(event: event.detached())
                            }
                            .buttonStyle(.plain)
                            .listRowSeparator(.hidden)
                        }
                    } header: {
                        sectionHeader(for: section.day, in: Date.now)
                    }
                    .id(section.day.tagValue)
                    .listSectionMargins(.all, 0)
                    .listSectionSpacing(.compact)
                    .listSectionSeparator(.hidden)
                    .headerProminence(.increased)
                }
            }
            .scenePadding([.horizontal, .top])
        }
        .scrollTargetLayout()
        .scrollPosition($scrollPosition, anchor: .top)
        .onScrollTargetVisibilityChange(
            idType: String.self,
            threshold: 0.9
        ) { visibleIDs in
            if !changingDateProgrammatically,
               let visibleID = visibleIDs.first,
               let newDate = Date.fromTagValue(visibleID) {
                changingDateProgrammatically = true

                selectedDate = newDate

                DispatchQueue.main
                    .asyncAfter(
                        deadline: .now() + 0.2
                    ) {
                        changingDateProgrammatically = false
                    }
            }
        }
        .onChange(of: selectedDate) {
            changingDateProgrammatically = true

            scrollPosition = .init(id: selectedDate.tagValue)
            DispatchQueue.main
                .asyncAfter(
                    deadline: .now() + 0.2
                ) {
                    changingDateProgrammatically = false
                }
        }
    }

    struct EventSection: Identifiable {
        var day: Date
        var events: [Event]

        var id: Date { day }
    }

    var eventsGroupedByDate: [EventSection] {
        let grouped = Dictionary(grouping: events) { event in
            calendar.startOfDay(for: event.date)
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
                .bold()
            Text(day, format: .dateTime.day())
                .foregroundStyle(.secondary)
            if isOutsideInterval {
                Text(day, format: .dateTime.month())
                    .foregroundStyle(.secondary)
            }
            Spacer()
            if isToday {
                Text("Today")
                    .bold()
                    .textCase(.uppercase)
            } else if isTomorrow {
                Text("Tomorrow")
                    .bold()
                    .textCase(.uppercase)
            }
        }
        .font(.headline)
        .padding(.vertical, 8)
        .background(
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(.separator),
            alignment: .bottom
        )
    }
}


#Preview(traits: .sampleData) {
    @Previewable @State var selectedDate: Date = .now
    @Previewable @Query var events: [Event]

    let range = Calendar.current.dateInterval(of: .year, for: .now)!
    NavigationStack {
        EventList(events: events, within: range, selectedDate: $selectedDate)
    }
}

