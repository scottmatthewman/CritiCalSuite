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
                        if !event.festivalName.isEmpty {
                            Text(event.festivalName)
                                .font(.headline)
                                .foregroundStyle(.secondary)
                        }
                        Divider()
                        Label {
                            Text(
                                event.date ..< event.endDate,
                                format: .interval.weekday().month().day().year().hour().minute()
                            )
                        } icon: {
                            Image(systemName: "calendar")
                                .foregroundStyle(.tint)
                        }
                        .font(.callout)

                        if !event.venueName.isEmpty {
                            Label {
                                Text(event.venueName)
                            } icon: {
                                Image(systemName: "location")
                                    .foregroundStyle(.tint)
                            }
                            .font(.callout)
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
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
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
        durationMinutes: 135,
        venueName: "Bridge Theatre"
    )
    let reader = FakeReader(events: [dto])
    EventDetailView(id: dto.id)
        .environment(\.eventReader, reader)
}
