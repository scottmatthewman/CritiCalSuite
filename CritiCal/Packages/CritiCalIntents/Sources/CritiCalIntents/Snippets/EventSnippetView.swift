//
//  EventSnippetView.swift
//  CritiCalIntents
//
//  Created by Claude on 21/09/2025.
//

import AppIntents
import CritiCalModels
import CritiCalUI
import SwiftUI

public struct EventSnippetView: View {
    let event: EventEntity

    public init(event: EventEntity) {
        self.event = event
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .bottom) {
                let tintColor = event.genre?.color
                
                // image
                RoundedRectangle(cornerRadius: 16)
                    .fill(.tint.secondary)
                    .frame(width: 60, height: 60)
                    .overlay {
                        Image(systemName: "theatermasks.fill")
                            .font(.title)
                            .foregroundStyle(.tint)
                    }
                    .tint((event.genre?.color) ?? .accentColor)
                // Title and Festival
                VStack(alignment: .leading, spacing: 4) {
                    if !event.festivalName.isEmpty {
                        Text(event.festivalName)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    Text(event.title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                }
                Spacer()
                Button(intent: OpenEventIntent(event: event)) {
                    Image(systemName: "arrow.up.right.square")
                        .imageScale(.large)
                }
                .buttonStyle(.plain)
                .foregroundStyle(.tint)
                .tint(tintColor)
            }

            Divider()

            if !event.venueName.isEmpty {
                Label(event.venueName, systemImage: "location")
                    .labelStyle(.tintedIcon)
            }

            // Date and Venue
            Label {
                Text(event.date ..< event.endDate, format: .interval.weekday().month().day().year().hour().minute()
                )
            } icon: {
                Image(systemName: "calendar")
            }
            .labelStyle(.tintedIcon)

            if event.confirmationStatus != .confirmed {
                let displayRep = ConfirmationStatusAppEnum.caseDisplayRepresentations[event.confirmationStatus]!
                Label(
                    displayRep.title,
                    systemImage: "questionmark.circle" // Default system image
                )
                .foregroundStyle(.secondary)
            }

            HStack(alignment: .firstTextBaseline) {
                if let genre = event.genre {
                    Label(genre.name, systemImage: "tag")
                        .labelStyle(.tag)
                        .tint(genre.color)
                }

                if let url = event.url {
                    Link(destination: url) {
                        Label(
                            url.trimmedHost ?? url.absoluteString,
                            systemImage: "globe"
                        )
                    }
                    .font(.caption)
                }
            }

            if event.details.isEmpty == false {
                Text(event.details)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.secondary.tertiary)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview("Event Snippet", traits: .sizeThatFitsLayout) {
    let event = DetachedEvent(
        id: UUID(),
        title: "SwiftUI Workshop",
        festivalName: "WWDC 2025",
        date: Date.now,
        durationMinutes: 60,
        venueName: "Moscone Center",
        confirmationStatus: .awaitingConfirmation,
        url: URL(string: "https://stratfordeast.com/"),
        details: "This example event is intended to demonstrate what the Shortcuts snippet will look like for an event that has all its attributes defined.",
        needsReview: true,
        wordCount: 550,
        fee: 85,
        reviewCompleted: true,
        reviewUrl: URL(string: "https://theguardian.com/stage/foo"),
        rating: 4.5,
        genre: DetachedGenre(
            id: UUID(),
            name: "Workshop",
            details: "Educational session",
            colorName: "Workshop",
            hexColor: "#FF5733",
            symbolName: "wand.and.stars",
            isDeactivated: false
        )
    )
    EventSnippetView(
        event: EventEntity(from: event)
    )
    .padding()
}
