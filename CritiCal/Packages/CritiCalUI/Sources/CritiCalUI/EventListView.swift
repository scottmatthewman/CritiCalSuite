//
//  EventListView.swift
//  CritiCalUI
//
//  Created by Scott Matthewman on 29/09/2025.
//

import SwiftUI
import CritiCalModels

public struct EventListView: View {
    @State private var timeframe: EventTimeframe = .future
    @State private var selectedDate: Date = .now
    @State private var interval: DateInterval = .init()
    private var onEventSelected: (UUID) -> Void

    public init(
        onEventSelected: @escaping (UUID) -> Void
    ) {
        self.onEventSelected = onEventSelected
    }

    public var body: some View {
        EventList(
            timeframe: timeframe,
            within: interval,
            onEventSelected: onEventSelected
        )
        .listStyle(.grouped)
        .safeAreaBar(edge: .top) {
            CalendarView(selectedDate: $selectedDate) {
                interval = $0
            }
        }
        .scrollEdgeEffectStyle(.hard, for: .top)
        .navigationTitle("Events")
        .toolbarTitleDisplayMode(.inlineLarge)
        .onChange(of: interval) { print(interval) }
    }
}

#Preview(traits: .sampleData) {
    NavigationStack {
        EventListView(onEventSelected: { print($0) })
    }
}
