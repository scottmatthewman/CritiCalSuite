//
//  EventSnippetView.swift
//  CritiCalIntents
//
//  Created by Claude on 21/09/2025.
//

import CritiCalDomain
import CritiCalUI
import SwiftUI
import AppIntents

public struct EventSnippetView: View {
    let dto: EventDTO
    let entity: EventEntity

    public init(event: EventEntity, dto: EventDTO) {
        self.entity = event
        self.dto = dto
    }

    public init(event: EventEntity) {
        self.entity = event
        let genreDTO = event.genre.map { genre in
            GenreDTO(
                id: genre.id,
                name: genre.name,
                details: genre.details,
                hexColor: genre.hexColor,
                isDeactivated: !genre.isActive
            )
        }
        // Create DTO from entity for display
        self.dto = EventDTO(
            id: event.id,
            title: event.title,
            festivalName: event.festivalName,
            date: event.date,
            durationMinutes: Int(event.endDate.timeIntervalSince(event.date) / 60),
            venueName: event.venueName,
            confirmationStatus: event.confirmationStatus.confirmationStatus,
            genre: genreDTO
        )
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .bottom) {
                // image
                RoundedRectangle(cornerRadius: 16)
                    .fill(.tint.secondary)
                    .frame(width: 60, height: 60)
                    .overlay {
                        Image(systemName: "theatermasks.fill")
                            .font(.title)
                            .foregroundStyle(.tint)
                    }
                    .tint(dto.genre?.color ?? .accentColor)
                // Title and Festival
                VStack(alignment: .leading, spacing: 4) {
                    if !dto.festivalName.isEmpty {
                        Text(dto.festivalName)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    Text(dto.title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                }
                Spacer()
                Button(intent: OpenEventIntent(event: entity)) {
                    Image(systemName: "arrow.up.right.square")
                        .imageScale(.large)
                }
                .buttonStyle(.plain)
                .foregroundStyle(.tint)
            }

            Divider()

            if !dto.venueName.isEmpty {
                Label(dto.venueName, systemImage: "location")
                    .labelStyle(.tintedIcon)
            }

            // Date and Venue
            Label {
                Text(dto.date ..< dto.endDate, format: .interval.weekday().month().day().year().hour().minute()
                )
            } icon: {
                Image(systemName: "calendar")
            }
            .labelStyle(.tintedIcon)

            if dto.confirmationStatus != .confirmed {
                Label(
                    dto.confirmationStatus.displayName,
                    systemImage: dto.confirmationStatus.systemImage
                )
                .foregroundStyle(.secondary)
            }

            if let genre = dto.genre {
                Label(genre.name, systemImage: "tag")
                    .labelStyle(.tag)
                    .tint(genre.color)
            }

            if let url = dto.url {
                Link(destination: url) {
                    Label(url.absoluteString, systemImage: "globe")
                }
            }

            if dto.details.isEmpty == false {
                Text(dto.details)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.secondary.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview("Event Snippet", traits: .sizeThatFitsLayout) {
    let dto = EventDTO(
        title: "SwiftUI Workshop",
        festivalName: "WWDC 2025",
        date: Date.now,
        durationMinutes: 60,
        venueName: "Moscone Center",
        confirmationStatus: .awaitingConfirmation,
        url: URL(string: "https://bbc.co.uk/"),
        details: "This example event is intended to demonstrate what the Shortcuts snippet will look like for an event that has all its attributes defined.",
        genre: GenreDTO(
            id: UUID(),
            name: "Workshop",
            details: "Educational session",
            hexColor: "#FF5733",
            isDeactivated: false
        )
    )
    EventSnippetView(
        event: EventEntity(from: dto)
    )
    .padding()
}
