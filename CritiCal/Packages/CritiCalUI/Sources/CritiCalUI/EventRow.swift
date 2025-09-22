//
//  SwiftRow.swift
//  
//
//  Created by Scott Matthewman on 20/09/2025.
//

import SwiftUI
import CritiCalDomain

struct EventRow: View {
    let event: EventDTO

    public init(event: EventDTO) {
        self.event = event
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(event.title)
                    .font(.headline)
                if event.festivalName.isEmpty == false {
                    Text(event.festivalName)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Label {
                    if event.confirmationStatus.isConfirmed() {
                        Text(
                            event.date ..< event.endDate,
                            format: .interval.weekday().month().day().year().hour().minute()
                        )
                    } else {
                        HStack(alignment: .firstTextBaseline) {
                            Text(
                                event.date,
                                format: .dateTime
                                    .weekday().month().day().year()
                                    .hour().minute()
                            )
                            .fixedSize()
                            Text(event.confirmationStatus.displayName)
                                .foregroundStyle(.secondary)
                        }
                        .lineLimit(1)
                    }
                } icon: {
                    Image(systemName: event.confirmationStatus.systemImage)
                        .foregroundStyle(.tint)
                }
                .font(.footnote)
                .padding(.top, 2)

                if !event.venueName.isEmpty {
                    Label {
                        Text(event.venueName)
                    } icon: {
                        Image(systemName: "location")
                            .foregroundStyle(.tint)
                    }
                    .font(.footnote)
                }
            }
            Spacer()
        }
        .contentShape(.rect)
        .labelIconToTitleSpacing(8)
    }
}

#Preview {
    let dto = EventDTO(
        title: "A Midsummer Night’s Dream",
        festivalName: "Lambeth Fringe",
        date: .iso8601("2025-09-21T19:30:00Z"),
        durationMinutes: 90,
        venueName: "Bridge Theatre",
        confirmationStatus: .awaitingConfirmation
    )
    let reader = FakeReader(events: [dto])
    List {
        EventRow(event: dto)
    }
    .environment(\.eventReader, reader)
}
