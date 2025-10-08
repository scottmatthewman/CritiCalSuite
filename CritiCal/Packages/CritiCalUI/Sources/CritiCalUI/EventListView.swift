//
//  EventListView.swift
//  CritiCalUI
//
//  Created by Scott Matthewman on 29/09/2025.
//

import SwiftUI
import SwiftData
import CritiCalModels

public struct EventListView: View {
    @Environment(\.calendar) private var calendar

    // Hoisted SwiftData query
    @Query private var events: [Event]

    @State private var timeframe: EventTimeframe = .future
    @State private var selectedDate: Date = .now
    @State private var interval: DateInterval = .init()
    @State private var scrollPosition: String? = nil

    private var onEventSelected: (UUID) -> Void

    public init(
        onEventSelected: @escaping (UUID) -> Void
    ) {
        self.onEventSelected = onEventSelected
        
        // Initialize the query with a default predicate (will be updated dynamically)
        let defaultPredicate: Predicate<Event> = #Predicate { _ in true }
        _events = Query(
            filter: defaultPredicate,
            sort: \.date,
            order: .forward
        )
    }

    public var body: some View {
        VStack(spacing: 0) {
            CalendarView(selectedDate: $selectedDate, events: filteredEvents) {
                interval = $0
            }
            EventList(
                events: filteredEvents,
                within: interval,
                scrollPosition: $scrollPosition,
                onEventSelected: onEventSelected
            )
        }
        .scrollEdgeEffectStyle(.hard, for: .top)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                MonthTitleButton(date: $selectedDate, onTap: returnToToday)
                    .font(.title.bold())
            }
        }
        .onChange(of: selectedDate, initial: true) {
            scrollPosition = selectedDate.tagValue
        }
    }
    
    private func returnToToday() {
        selectedDate = Date.now
    }
    
    // Filter events based on the current interval
    private var filteredEvents: [Event] {
        events.filter { event in
            event.date >= interval.start && event.date < interval.end
        }
    }
}

#Preview(traits: .sampleData) {
    NavigationStack {
        EventListView(onEventSelected: { print($0) })
    }
}
