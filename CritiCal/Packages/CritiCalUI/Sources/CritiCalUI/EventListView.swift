//
//  EventListView.swift
//  CritiCalUI
//
//  Created by Scott Matthewman on 20/09/2025.
//

import SwiftUI
import SwiftData
import CritiCalDomain
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
                        EventRow(event: EventDTO(event: event))
                    }
                }
                .buttonStyle(.plain)
            }
        }
    }
}

#Preview {
    let e1 = EventDTO(
        title: "Tech Rehearsal",
        festivalName: "",
        date: .iso8601("2025-09-21T19:30:00Z"),
        venueName: "Donmar Warehouse",
        confirmationStatus: .confirmed
    )
    let e2 = EventDTO(
        title: "Press Night",
        festivalName: "Camden Fringe 2025",
        date: .iso8601("2025-09-22T19:30:00Z"),
        venueName: "National Theatre",
        confirmationStatus: .awaitingConfirmation
    )

    let reader = FakeEventsReader(events: [e1, e2])

    NavigationStack {
        EventListView {
            print("ID selected: \($0)")
        }
        .environment(\.eventReader, reader)
    }
}
