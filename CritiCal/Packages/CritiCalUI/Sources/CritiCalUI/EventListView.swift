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
            // Month title header
            HStack {
                MonthTitleButton(date: $selectedDate, onTap: returnToToday)
                    .font(.title.bold())
                Spacer()
                Button("Add", systemImage: "plus") { }
                    .buttonStyle(.glassProminent)
                    .imageScale(.large)
                    .labelStyle(.iconOnly)
            }
            .padding(.horizontal)
            .padding(.top, 8)
            .padding(.bottom, 4)
            
            CalendarView(selectedDate: $selectedDate, events: filteredEvents) {
                interval = $0
            }
            EventList(
                events: filteredEvents,
                within: interval,
                selectedDate: $selectedDate,
                onEventSelected: onEventSelected
            )
        }
        .scrollEdgeEffectStyle(.hard, for: .top)
        .navigationBarHidden(true)
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
