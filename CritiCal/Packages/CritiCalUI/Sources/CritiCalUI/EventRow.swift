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
            VStack(alignment: .leading, spacing: 4) {
                Text(event.title)
                    .font(.headline)
                if event.festivalName.isEmpty == false {
                    Text(event.festivalName)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Label {
                    HStack(alignment: .firstTextBaseline) {
                        Text(event.date, style: .date)
                        Text("at")
                            .foregroundStyle(.secondary)
                        Text(event.date, style: .time)
                    }
                } icon: {
                    Image(systemName: "calendar")
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
