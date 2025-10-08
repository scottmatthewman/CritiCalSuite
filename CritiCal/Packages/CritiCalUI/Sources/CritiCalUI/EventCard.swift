//
//  EventCard.swift
//  CritiCalUI
//
//  Created by Scott Matthewman on 25/09/2025.
//

import CritiCalModels
import SwiftUI

struct EventCard: View {
    let event: DetachedEvent
    
    var body: some View {
        VStack(spacing: 0) {
            // Map section - top third
            ZStack(alignment: .bottomLeading) {
                // Static map snapshot goes here
                Rectangle()
                    .fill(.pink.gradient.opacity(0.3))
                    .frame(height: 96)
                    .clipShape(
                        UnevenRoundedRectangle(
                            topLeadingRadius: 24,
                            topTrailingRadius: 24
                        )
                    )
                // Location label
                Label(event.venueName, systemImage: "location")
                    .font(.footnote)
                    .bold()
                    .labelStyle(.tintedIcon)
                    .symbolVariant(.fill)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .background(
                        Capsule()
                            .fill(.background)
                    )
                    .padding([.bottom, .leading], 12)
            }

            // Content section with overlapping image

            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .top, spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(event.title)
                            .font(.title2.bold())
                            .foregroundStyle(.primary)
                            .lineLimit(2)
                            .padding(.top, 8)
                            .minimumScaleFactor(0.75)
                    }
                    Spacer()
                    Rectangle()
                        .fill(.tint.quaternary)
                        .frame(width: 64, height: 64)
                        .background(
                            Image(systemName: event.genre?.symbolName ?? "theatermasks")
                                .font(.title2)
                                .foregroundStyle(.tint)
                        )
                        .clipShape(.circle)
                        .background(.background, in: .circle)
                        .background(Circle().stroke(.background, lineWidth: 4))
                        .shadow(color: .black.opacity(0.1), radius: 8, y: 4)
                        .offset(y: -32)
                        .tint(event.genre?.color ?? .accentColor)
                }

                // Date, time and status
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Label(
                        event.date
                            .formatted(date: .abbreviated, time: .omitted),
                        systemImage: "calendar"
                    )
                    Label(
                        event.date.formatted(date: .omitted, time: .shortened),
                        systemImage: "clock")
                    if !event.confirmationStatus.isConfirmed() {
                        Label(
                            event.confirmationStatus.displayName,
                            systemImage: event.confirmationStatus
                                .systemImage)
                        .foregroundStyle(.secondary)
                    }
                }
                .font(.footnote)
                .labelIconToTitleSpacing(4)

                // Genre/publication

                HStack(alignment: .firstTextBaseline) {
                    HStack(alignment: .firstTextBaseline, spacing: 0) {
                        Image(systemName: "star")
                        Image(systemName: "star")
                        Image(systemName: "star")
                        Image(systemName: "star")
                        Image(systemName: "star")
                    }
                    .foregroundStyle(.tertiary)
                    Spacer()
                    Label("No publication", systemImage: "newspaper")
                        .foregroundStyle(.tint)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(.tint.quinary, in: .capsule)
                        .tint(.secondary)
                        .opacity(0.5)
                }
                .font(.caption)
            }
            .padding([.horizontal, .bottom], 16)
        }
        .background(.regularMaterial, in: .rect(cornerRadius: 24))
        .shadow(color: .black.opacity(0.1), radius: 12, x: 0, y: 6)

    }
}

#Preview {
    let event = DetachedEvent(
        id: UUID(),
        title: "A Midsummer Night's Dream",
        festivalName: "Lambeth Fringe",
        date: .iso8601("2025-09-21T19:30:00Z"),
        durationMinutes: 90,
        venueName: "Bridge Theatre",
        confirmationStatus: .bidForReview,
        url: URL(string: "https://bridgetheatre.co.uk/"),
        details: "I have some details here for you",
        needsReview: true,
        wordCount: 550,
        fee: 85,
        reviewCompleted: true,
        reviewUrl: URL(string: "https://theguardian.com/stage/foo"),
        rating: 4.5,
        genre: DetachedGenre(id: UUID(), name: "Musical Theatre", details: "", colorName: "Musical Theatre", hexColor: "277726", symbolName: "music.note", isDeactivated: false),
        publication: DetachedPublication(
            id: UUID(),
            name: "Telegraph",
            hexColor: "e4e454",
            typicalWordCount: 725,
            typicalFee: 200,
            awardsStars: true,
            isDeactivated: false
        )
    )

    EventCard(event: event)
        .padding()
}
