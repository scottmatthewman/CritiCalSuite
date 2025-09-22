//
//  EventSnippetView.swift
//  CritiCalIntents
//
//  Created by Claude on 21/09/2025.
//

import CritiCalDomain
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
        // Create DTO from entity for display
        self.dto = EventDTO(
            id: event.id,
            title: event.title,
            festivalName: event.festivalName,
            date: event.date,
            durationMinutes: Int(event.endDate.timeIntervalSince(event.date) / 60),
            venueName: event.venueName,
            confirmationStatus: event.confirmationStatus.confirmationStatus
        )
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Title and Festival
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(dto.title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Spacer()
                    Button(intent: OpenEventIntent(event: entity)) {
                        Image(systemName: "arrow.up.right.square")
                            .imageScale(.large)
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(.tint)
                }
                if !dto.festivalName.isEmpty {
                    Text(dto.festivalName)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }

            Divider()

            // Date and Venue
            VStack(alignment: .leading, spacing: 8) {
                Label {
                    VStack(alignment: .leading) {
                        Text(
                            dto.date ..< dto.endDate,
                            format: .interval.weekday().month().day().year().hour().minute()
                        )
                        if dto.confirmationStatus != .confirmed {
                            Label(dto.confirmationStatus.displayName, systemImage: "exclamationmark.triangle")
                                .font(.footnote.bold())
                                .textCase(.uppercase)
                                .foregroundStyle(.orange)
                        }
                    }
                } icon: {
                    Image(systemName: "calendar")
                        .foregroundStyle(.tint)
                }
                .font(.callout)

                if !dto.venueName.isEmpty {
                    Label {
                        Text(dto.venueName)
                    } icon: {
                        Image(systemName: "location")
                            .foregroundStyle(.tint)
                    }
                    .font(.callout)
                }
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
        confirmationStatus: .awaitingConfirmation
    )
    EventSnippetView(
        event: EventEntity(from: dto)
    )
    .padding()
}
