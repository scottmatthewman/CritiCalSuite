//
//  EventListView.swift
//  CritiCalUI
//
//  Created by Scott Matthewman on 29/09/2025.
//

import SwiftUI
import CritiCalModels

public struct EventListView: View {
    @Environment(\.calendar) private var calendar

    @State private var timeframe: EventTimeframe = .future
    @State private var selectedDate: Date = .now
    @State private var interval: DateInterval = .init()
    @State private var scrollPosition: String? = nil

    private var onEventSelected: (UUID) -> Void

    public init(
        onEventSelected: @escaping (UUID) -> Void
    ) {
        self.onEventSelected = onEventSelected
    }

    public var body: some View {
        VStack(spacing: 0) {
            CalendarView(selectedDate: $selectedDate) {
                interval = $0
            }
            EventList(
                timeframe: timeframe,
                within: interval,
                scrollPosition: $scrollPosition,
                onEventSelected: onEventSelected
            )
        }
        .ignoresSafeArea(.container, edges: .bottom)
        .scrollEdgeEffectStyle(.hard, for: .top)
        .navigationTitle("Events")
        .toolbarTitleDisplayMode(.inlineLarge)
        .onChange(of: selectedDate, initial: true) {
            scrollPosition = selectedDate.tagValue
        }
    }
}

#Preview(traits: .sampleData) {
    NavigationStack {
        EventListView(onEventSelected: { print($0) })
    }
}
