//
//  SwiftUIView.swift
//  CritiCalUI
//
//  Created by Scott Matthewman on 05/10/2025.
//

import CritiCalModels
import SwiftUI

struct EventListDetail: View {
    var event: DetachedEvent

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(event.date, format: .dateTime.hour().minute())
                .font(.caption)
                .bold()
                .monospacedDigit()
                .strikethrough(event.confirmationStatus.isCancelled())
                .foregroundStyle(
                    event.confirmationStatus
                        .isConfirmed() ? .primary : .secondary
                )
            VStack(alignment: .leading) {
                HStack(alignment: .firstTextBaseline) {
                    if let genre = event.genre {
                        Label(genre.name, systemImage: genre.symbolName)
                            .labelStyle(.titleOnly)
                            .tint(genre.color)
                            .font(.caption)
                            .fixedSize()
                    }
                    if !event.festivalName.isEmpty {
                        Text(event.festivalName)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .textCase(.uppercase)
                    }
                }
                Text(event.title)
                    .font(.headline)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
                Text(event.venueName)
                    .font(.subheadline)
                HStack(alignment: .firstTextBaseline) {
                    Label("The Reviews Hub", systemImage: "newspaper")
                        .labelStyle(.tag)
                        .tint(.purple)
                    if false {
                        HStack(spacing: -2) {
                            ForEach(0..<5, id: \.self) { _ in
                                Image(systemName: "star.fill")
                            }
                        }
                        .foregroundStyle(.purple)
                    } else {
                        WarningLabel(text: "Overdue")
                    }
                }
                .font(.caption2)
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Label("E-ticket", systemImage: "ticket")
                    Label("Claire" ,systemImage: "person.2")
                    Label("13", systemImage: "photo.on.rectangle.angled")
                }
                .symbolRenderingMode(.hierarchical)
                .font(.caption2)
                .labelIconToTitleSpacing(2)
                .foregroundStyle(.secondary)
                .padding(.top, 4)
            }
        }
        .background(alignment: .leading) {
            Rectangle()
                .fill(event.genre?.color ?? .gray)
                .frame(width: 2)
                .offset(x: -6)
        }
    }
}

struct WarningLabel: View {
    var text: String

    init(text: String) {
        self.text = text
    }

    var body: some View {
        Label {
            Text(text)
                .bold()
                .textCase(.uppercase)
                .foregroundStyle(.tint)
        } icon: {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(.black, .yellow)
        }
        .labelIconToTitleSpacing(0)
        .padding(.vertical, 4)
        .padding(.horizontal, 8)
        .background(.tint.quaternary, in: .capsule)
        .tint(.orange)
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
        genre: DetachedGenre(
            id: UUID(),
            name: "Musical Theatre",
            details: "",
            colorName: "Musical Theatre",
            hexColor: "c02673",
            symbolName: "music.note",
            isDeactivated: false
        )
    )

    NavigationStack {
        List {
            Section {
                EventListDetail(event: event)
            } header: {
                Text(event.date, format: .dateTime.weekday(.wide).day().month())
            }
        }
        .listStyle(.grouped)
    }
}
