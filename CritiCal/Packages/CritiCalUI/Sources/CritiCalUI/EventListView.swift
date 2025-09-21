//
//  EventListView.swift
//  CritiCalUI
//
//  Created by Scott Matthewman on 20/09/2025.
//

import SwiftUI
import CritiCalDomain

public struct EventListView: View {
    @Environment(\.eventReader) private var reader
    public var onSelect: (UUID) -> Void

    @State private var events: [EventDTO] = []
    @State private var isLoading: Bool = false
    @State private var error: Error?

    public init(
        onSelect: @escaping (UUID) -> Void = { _ in }
    ) {
        self.onSelect = onSelect
    }

    public var body: some View {
        Group {
            if isLoading {
                ProgressView("Loading…")
            } else if let error {
                ContentUnavailableView {
                    Label("Couldn't load events", systemImage: "exclamationmark.triangle")
                } description: {
                    Text(error.localizedDescription)
                }
            } else {
                List(events) { event in
                    Button {
                        onSelect(event.id)
                    } label: {
                        EventRow(event: event)
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .navigationTitle("Events")
        .task { await loadEvents() }
    }

    private func loadEvents() async {
        guard let reader else { return }
        isLoading = true
        defer { isLoading = false }

        do {
            events = try await reader.recent(limit: 200)
        } catch {
            self.error = error
        }
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
