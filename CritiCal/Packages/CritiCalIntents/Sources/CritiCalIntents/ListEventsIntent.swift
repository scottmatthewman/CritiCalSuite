//
//  ListEventsIntent.swift
//  CritiCalIntents
//
//  Created by Scott Matthewman on 18/09/2025.
//

import AppIntents
import CritiCalStore
import CritiCalDomain

public struct ListEventsIntent: AppIntent {
    public static let title: LocalizedStringResource = "List Events"
    public static let description =  IntentDescription("LIst events within a given timeframe")

    @Parameter(title: "Timeframe") var timeframe: EventTimeframe

    public init() { }

    public func perform() async throws -> some IntentResult & ReturnsValue<[EventEntity]> {
        let repo = try await SharedStores.eventRepo()

        let dtos: [EventDTO]
        switch timeframe {
        case .today:
            dtos = try await repo.eventsToday()
        case .past:
            dtos = try await repo.eventsBefore()
        case .future:
            dtos = try await repo.eventsAfter()
        }

        let entities = dtos.map { EventEntity(id: $0.id, title: $0.title, date: $0.date, venueName: $0.venueName) }
        return .result(value: entities)
    }
}
