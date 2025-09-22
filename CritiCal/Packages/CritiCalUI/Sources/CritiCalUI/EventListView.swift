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
    @Environment(NavigationRouter.self) private var router

    // Use @Query to efficiently load events directly from SwiftData
    @Query(sort: \Event.date, order: .reverse) private var events: [Event]

    public init() {}

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
                        router.navigate(toEvent: event.identifier)
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

    let reader = FakeReader(events: [e1, e2])

    NavigationStack {
        EventListView()
            .environment(\.eventReader, reader)
            .environment(NavigationRouter())
    }
}
