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
            VStack(alignment: .leading) {
                if event.festivalName.isEmpty == false {
                    Text(event.festivalName)
                        .textCase(.uppercase)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                Text(event.title)
                    .font(.headline)
                Text(event.venueName)
                    .font(.subheadline)
                Text(event.date, style: .date)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .contentShape(.rect)
    }
}

#Preview {
    let dto = EventDTO(
        title: "A Midsummer Night’s Dream",
        festivalName: "Lambeth Fringe",
        date: .iso8601("2025-09-21T19:30:00Z"),
        venueName: "Bridge Theatre"
    )
    let reader = FakeReader(events: [dto])
    List {
        EventRow(event: dto)
    }
    .environment(\.eventReader, reader)
}
