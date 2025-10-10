//
//  SwiftUIView.swift
//  CritiCalUI
//
//  Created by Scott Matthewman on 20/09/2025.
//

import SwiftUI
import CritiCalModels

public struct EventDetailView: View {
    @Environment(\.eventReader) private var reader
    public let id: UUID

    @State private var event: DetachedEvent?

    public init(id: UUID) {
        self.id = id
    }

    public var body: some View {
        Group {
            if let event {
                List {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(event.title)
                            .font(.title.bold())
                        if !event.festivalName.isEmpty {
                            Text(event.festivalName)
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        }
                        if let genre = event.genre {
                            Label(genre.name, systemImage: genre.symbolName)
                        }
                    }
                    .tint(event.genre?.color)

                    DisclosureGroup {
                        LabeledContent {
                            Text(event.confirmationStatus.displayName)
                        } label: {
                            Label("Status", systemImage: event.confirmationStatus.systemImage)
                        }
                        LabeledContent {
                            Text(event.date, format: .dateTime.weekday().month().day().year())
                        } label: {
                            Label("Date", systemImage: "calendar")
                        }
                        LabeledContent {
                            Text(event.date, format: .dateTime.hour().minute())
                        } label: {
                            Label("Time", systemImage: "clock")
                        }
                        LabeledContent {
                            Text(Duration.seconds(event.date.distance(to: event.endDate)), format: .units(allowed: [.hours, .minutes], width: .abbreviated))
                        } label: {
                            Label("Duration", systemImage: "hourglass")
                        }
                        LabeledContent {
                            Text(event.endDate, format: .dateTime.hour().minute())
                        } label: {
                            Label("End Time", systemImage: "clock.badge.xmark")
                        }
                        .foregroundStyle(.secondary)

                    } label: {
                        Label {
                            Text(
                                event.date ..< event.endDate,
                                format: .interval
                                    .weekday()
                                    .month()
                                    .day()
                                    .year()
                                    .hour()
                                    .minute()
                            )
                        } icon: {
                            Image(
                                systemName: event.confirmationStatus == .confirmed ? "calendar" : event.confirmationStatus
                                    .systemImage
                            )
                        }
                    }

                    if !event.venueName.isEmpty {
                        DisclosureGroup {
                            Text(
                                "Venue information appears here"
                            )
                        } label: {
                            Label(event.venueName, systemImage: "location")
                        }
                    }

                    if let url = event.url {
                        Link(destination: url) {
                            LabeledContent {
                                Text(url.trimmedHost ?? url.absoluteString)
                            } label: {
                                Label("Website", systemImage: "globe")
                            }
                        }
                    }

                    if event.details.isEmpty == false {
                        Text(event.details)
                            .lineSpacing(4.0)
                    }
                }
                .listStyle(.plain)
            } else {
                ProgressView("Loading…")
            }
        }
        .task {
            await load()
        }
        .navigationTitle("Event")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func load() async {
        guard let reader else {
            return
        }
        event = try? await reader.event(byIdentifier: id)
    }
}

#Preview(traits: .sampleData) {
    let eventId = UUID()
    let event = DetachedEvent(
        id: eventId,
        title: "A Midsummer Night's Dream",
        festivalName: "London Theatre Festival",
        date: .iso8601("2025-09-21T19:30:00Z"),
        durationMinutes: 135,
        venueName: "Bridge Theatre",
        confirmationStatus: .confirmed,
        url: URL(string: "https://bridgetheatre.co.uk/"),
        details: "An immersive version of Shakespeare's classic. Join Titania, Oberon and the citizens of Athens as they walk around the enchanted forest.",
        needsReview: true,
        wordCount: 550,
        fee: 85,
        reviewCompleted: true,
        reviewUrl: URL(string: "https://theguardian.com/stage/foo"),
        rating: 4.5,
        genre: DetachedGenre(
            id: UUID(),
            name: "Musical Theatre",
            details: "",
            colorToken: .coral,
            symbolName: "theatermasks",
            isDeactivated: false
        ),
        publication: DetachedPublication(
            id: UUID(),
            name: "Telegraph",
            details: "",
            colorToken: .blue,
            typicalWordCount: 725,
            typicalFee: 200,
            awardsStars: true,
            isDeactivated: false
        )
    )
    let reader = FakeEventsReader(events: [event])
    EventDetailView(id: eventId)
    .environment(\.eventReader, reader)
}
