//
//  SwiftUIView.swift
//  CritiCalUI
//
//  Created by Scott Matthewman on 20/09/2025.
//

import SwiftUI
import CritiCalDomain

public struct EventDetailView: View {
    @Environment(\.eventReader) private var reader
    public let id: UUID

    @State private var event: EventDTO?

    public init(id: UUID) {
        self.id = id
    }

    public var body: some View {
        Group {
            if let event {
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(event.title)
                            .font(.title.bold())
                        Text(
                            event.date.formatted(date: .long, time: .shortened)
                        )
                        .foregroundStyle(.secondary)
                        Divider()
                        if event.venueName.isEmpty == false {
                            Text(event.venueName)
                        }
                    }
                }
                .padding()
            } else {
                ProgressView("Loading…")
            }
        }
        .task { await load() }
        .navigationTitle("Event")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func load() async {
        guard let reader else { return }
        event = try? await reader.event(byIdentifier: id)
    }
}

#Preview {
    let dto = EventDTO(
        title: "A Midsummer Night’s Dream",
        festivalName: "London Theatre Festival",
        date: .iso8601("2025-09-21T19:30:00Z"),
        venueName: "Bridge Theatre"
    )
    let reader = FakeReader(events: [dto])
    EventDetailView(id: dto.id)
        .environment(\.eventReader, reader)
}
