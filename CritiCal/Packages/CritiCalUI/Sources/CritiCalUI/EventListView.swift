//
//  EventListView.swift
//  CritiCalUI
//
//  Created by Scott Matthewman on 20/09/2025.
//

import SwiftUI
import SwiftData
import CritiCalModels

public struct EventListView: View {
    // Use @Query to efficiently load events directly from SwiftData
    @Query(sort: \Event.date, order: .reverse) private var events: [Event]

    private var onEventSelected: (UUID) -> Void

    public init(
        onEventSelected: @escaping (UUID) -> Void
    ) {
        self.onEventSelected = onEventSelected
    }

    public var body: some View {
        Group {
            if events.isEmpty {
                ContentUnavailableView {
                    Label("No Events", systemImage: "calendar")
                } description: {
                    Text("No events have been added yet")
                }
            } else {
                List(events) { event in
                    Button {
                        onEventSelected(event.identifier)
                    } label: {
                        EventRow(event: event.detached())
                    }
                }
                .buttonStyle(.plain)
            }
        }
    }
}

#Preview {
    let e1 = DetachedEvent(
        id: UUID(),
        title: "Tech Rehearsal",
        festivalName: "",
        date: .iso8601("2025-09-21T19:30:00Z"),
        durationMinutes: nil,
        venueName: "Donmar Warehouse",
        confirmationStatus: .confirmed,
        url: nil,
        details: "",
        needsReview: true,
        wordCount: 550,
        fee: 85,
        reviewCompleted: true,
        reviewUrl: URL(string: "https://theguardian.com/stage/foo"),
        rating: 4.5,
        genre: nil
    )
    let e2 = DetachedEvent(
        id: UUID(),
        title: "Press Night",
        festivalName: "Camden Fringe 2025",
        date: .iso8601("2025-09-22T19:30:00Z"),
        durationMinutes: nil,
        venueName: "National Theatre",
        confirmationStatus: .awaitingConfirmation,
        url: nil,
        details: "",
        needsReview: false,
        wordCount: 550,
        fee: nil,
        reviewCompleted: false,
        reviewUrl: nil,
        rating: nil,
        genre: nil
    )

    let reader = FakeEventsReader(events: [e1, e2])

    NavigationStack {
        EventListView {
            print("ID selected: \($0)")
        }
        .environment(\.eventReader, reader)
    }
}
