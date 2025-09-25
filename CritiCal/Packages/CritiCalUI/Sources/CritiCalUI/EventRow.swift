//  SwiftRow.swift
//
//
//  Created by Scott Matthewman on 20/09/2025.
//

import SwiftUI
import CritiCalDomain
import CritiCalModels

public struct EventRow: View {
    private let event: DetachedEvent

    @Environment(\.calendar) private var calendar
    @State private var showConfirmationStatus = false

    public init(event: DetachedEvent) {
        self.event = event
    }

    public var body: some View {
        HStack(alignment: .top, spacing: 20) {
            RoundedRectangle(cornerRadius: 18)
                .fill(.tint.tertiary)
                .frame(width: 80, height:80)
                .overlay(
                    Image(systemName: event.genre?.symbolName ?? "theatermasks")
                        .font(.title)
                        .foregroundStyle(.tint)
                        .symbolVariant(.fill)
                )
                .tint(event.genre?.color ?? .accentColor)
            VStack(alignment: .leading, spacing: 4) {
                if event.festivalName.isEmpty == false {
                    Text(event.festivalName)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                Text(event.title)
                    .font(.headline)
                    .lineLimit(2)
                    .minimumScaleFactor(0.75)
                Label(event.venueName, systemImage: "location")
                    .font(.caption)

                if showConfirmationStatus {
                    Label(
                        event.confirmationStatus.displayName,
                        systemImage: event.confirmationStatus.systemImage
                    )
                    .foregroundStyle(.secondary)
                    .font(.caption)
                } else {
                    Label(dateText, systemImage: "calendar")
                        .font(.caption)
                }

                if let genre = event.genre {
                    Label(genre.name, systemImage: genre.symbolName)
                        .labelStyle(.tag)
                        .tint(genre.color)
                        .padding(.top, 8)
                }

                // icons for more information {
                HStack(spacing: 12) {
                    if event.url != nil {
                        Image(systemName: "globe")
                            .accessibilityLabel(Text("This event has a website"))
                    }
                    if event.details.isEmpty == false {
                        Image(systemName: "text.page")
                            .accessibilityLabel(Text("There are text details for this event"))
                    }
                }
                .foregroundStyle(.secondary)
                .padding(.top, 8)
            }
            Spacer()
        }
        .contentShape(.rect)
        .labelIconToTitleSpacing(8)
        .task {
            // Only animate toggling when not confirmed
            guard event.confirmationStatus.isConfirmed() == false else { return }
            // Start with showing the date first
            showConfirmationStatus = false
            // Repeating loop every 2 seconds
            while true {
                try? await Task.sleep(nanoseconds: 4_000_000_000)
                // If the view has been cancelled, break
                if Task.isCancelled { break }
                // If status became confirmed somehow, stop toggling
                if event.confirmationStatus.isConfirmed() { break }
                await MainActor.run {
                    withAnimation(.easeInOut) {
                        showConfirmationStatus.toggle()
                    }
                }
            }
        }
    }

    private var dateText: String {
        let interval = event.date ..< event.endDate
        return interval.formatted(intervalStyle(for: interval))
    }

    private func intervalStyle(for range: Range<Date>) -> Date.IntervalFormatStyle {
        let currentYear = calendar.component(.year, from: .now)
        let startYear = calendar.component(.year, from: range.lowerBound)
        let endYear = calendar.component(.year, from: range.upperBound)

        let baseFormat: Date.IntervalFormatStyle = .interval.weekday().month().day().hour().minute()

        if currentYear != startYear || currentYear != endYear {
            return baseFormat.year()
        } else {
            return baseFormat
        }
    }
}

#Preview {
    let dto = EventDTO(
        title: "A Midsummer Night’s Dream",
        festivalName: "Lambeth Fringe",
        date: .iso8601("2025-09-21T19:30:00Z"),
        durationMinutes: 90,
        venueName: "Bridge Theatre",
        confirmationStatus: .bidForReview,
        url: URL(string: "https://bridgetheatre.co.uk/"),
        details: "I have some details here for you",
        genre: GenreDTO(name: "Musical Theatre", hexColor: "277726", symbolName: "music.note")
    )
    let reader = FakeEventsReader(events: [DetachedEvent(eventDTO: dto)])
    List {
        EventRow(event: DetachedEvent(eventDTO: dto))
    }
    .environment(\.eventReader, reader)
}

