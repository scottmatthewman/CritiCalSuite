//
//  EventSnippetView.swift
//  CritiCalIntents
//
//  Created by Claude on 21/09/2025.
//

import SwiftUI
import AppIntents

public struct EventSnippetView: View {
    let event: EventEntity

    public init(event: EventEntity) {
        self.event = event
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Title and Festival
            VStack(alignment: .leading, spacing: 4) {
                Text(event.title)
                    .font(.headline)
                    .foregroundStyle(.primary)

                if !event.festivalName.isEmpty {
                    Text(event.festivalName)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }

            Divider()

            // Date and Venue
            VStack(alignment: .leading, spacing: 8) {
                Label {
                    Text(event.date, style: .date)
                    Text("at")
                        .foregroundStyle(.secondary)
                    Text(event.date, style: .time)
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
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.secondary.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview("Event Snippet", traits: .sizeThatFitsLayout) {
    EventSnippetView(
        event: EventEntity(
            title: "SwiftUI Workshop",
            festivalName: "WWDC 2025",
            date: Date.now,
            venueName: "Moscone Center"
        )
    )
    .padding()
}
