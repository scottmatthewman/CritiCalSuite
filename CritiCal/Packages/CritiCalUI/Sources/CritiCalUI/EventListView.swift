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

    public var onSelect: (UUID) -> Void

    public init(
        onSelect: @escaping (UUID) -> Void = { _ in }
    ) {
        self.onSelect = onSelect
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
                        onSelect(event.identifier)
                    } label: {
                        // Convert Event to EventDTO for EventRow
                        EventRow(event: EventDTO(
                            id: event.identifier,
                            title: event.title,
                            festivalName: event.festivalName,
                            date: event.date,
                            venueName: event.venueName
                        ))
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .navigationTitle("Events")
    }
}

#Preview {
    let e1 = EventDTO(
        title: "Tech Rehearsal",
        festivalName: "",
        date: .iso8601("2025-09-21T19:30:00Z"),
        venueName: "Donmar Warehouse"
    )
    let e2 = EventDTO(
        title: "Press Night",
        festivalName: "Camden Fringe 2025",
        date: .iso8601("2025-09-22T19:30:00Z"),
        venueName: "National Theatre"
    )

    let reader = FakeReader(events: [e1, e2])

    NavigationStack {
        EventListView()
            .environment(\.eventReader, reader)
    }
}
