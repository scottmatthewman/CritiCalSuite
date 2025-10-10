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
            VStack(alignment: .leading) {
                HStack(alignment: .firstTextBaseline) {
                    if let genre = event.genre {
                        Label(genre.name, systemImage: genre.symbolName)
                            .labelStyle(.titleOnly)
                            .font(.caption)
                            .bold()
                            .fixedSize()
                    }
                    if !event.festivalName.isEmpty {
                        Text(event.festivalName)
                            .font(.caption)
                            .foregroundStyle(.tint)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                    }
                }
                Text(event.title)
                    .font(.headline)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
                    .statusFormat(event.confirmationStatus)
                Text(event.venueName)
                    .font(.subheadline)
                    .statusFormat(event.confirmationStatus)
                HStack(alignment: .firstTextBaseline) {
                    if let publication = event.publication {
                        Label(publication.name, systemImage: "newspaper")
                            .labelStyle(.tag)
                            .tint(publication.color)
                    }
                    if !event.confirmationStatus.isConfirmed() {
                        Label(
                            event.confirmationStatus.displayName,
                            systemImage: event.confirmationStatus.systemImage
                        )
                        .labelStyle(.tag)
                        .tint(.secondary)
                    }
                }
                .font(.caption2)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 4) {
                Text(event.date, format: .dateTime.hour().minute())
                    .bold()
                    .monospacedDigit()
                    .foregroundStyle(.primary)
                    .statusFormat(event.confirmationStatus)
                Text(event.endDate, format: .dateTime.hour().minute())
                    .monospacedDigit()
                    .foregroundStyle(.secondary)
                    .statusFormat(event.confirmationStatus)
                if let genre = event.genre {
                    Image(systemName: genre.symbolName)
                        .resizable()
                        .scaledToFit()
                        .padding(8)
                        .frame(width: 40, height: 40)
                        .foregroundStyle(.tint)
                        .background(.tint.quaternary, in: .circle)
                        .tint(genre.color.gradient)
                } else if !event.confirmationStatus.isConfirmed() {
                    Label(
                        event.confirmationStatus.displayName,
                        systemImage: event.confirmationStatus
                            .systemImage)
                    .labelStyle(.iconOnly)
                    .font(.title)
                    .symbolRenderingMode(.hierarchical)
                    .symbolVariant(.fill)
                    .foregroundStyle(.tertiary)
                }
            }
            .font(.caption)
            .fixedSize()
            .padding(.trailing, 8)
        }
    }
}

struct StatusFormatModifier: ViewModifier {
    var status: ConfirmationStatus

    var opacity: CGFloat {
        if status.isConfirmed() {
            1.0
        } else if status.isCancelled() {
            0.4
        } else {
            0.6
        }
    }

    func body(content: Content) -> some View {
        content
            .opacity(opacity)
            .strikethrough(status.isCancelled())
    }
}

extension View {
    func statusFormat(_ status: ConfirmationStatus) -> some View {
        self.modifier(StatusFormatModifier(status: status))
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
        festivalName: "Lambeth Fringe 2025",
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
            hexColor: "3ab241",
            symbolName: "music.note",
            isDeactivated: false
        ),
        publication: DetachedPublication(
            id: UUID(),
            name: "The Reviews Hub",
            details: "",
            colorName: "purple",
            typicalWordCount: 550,
            typicalFee: nil,
            awardsStars: true,
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
        .listStyle(.plain)
    }
}
