//  SwiftRow.swift
//
//
//  Created by Scott Matthewman on 20/09/2025.
//

import SwiftUI
import CritiCalDomain

public struct EventRow: View {
    private let event: EventDTO

    @Environment(\.calendar) private var calendar
    @State private var showConfirmationStatus = false

    public init(event: EventDTO) {
        self.event = event
    }

    public var body: some View {
        HStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 18)
                .fill(.tint.tertiary)
                .frame(width: 80, height:80)
                .overlay(
                    Image(systemName: "theatermasks.fill")
                        .font(.title)
                        .foregroundStyle(.tint)
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
                    Label(genre.name, systemImage: "tag")
                        .labelStyle(.tag)
                        .tint(genre.color)
                        .padding(.top, 8)
                }
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
        genre: GenreDTO(name: "Musical Theatre", hexColor: "277726")
    )
    let reader = FakeReader(events: [dto])
    List {
        EventRow(event: dto)
    }
    .environment(\.eventReader, reader)
}

