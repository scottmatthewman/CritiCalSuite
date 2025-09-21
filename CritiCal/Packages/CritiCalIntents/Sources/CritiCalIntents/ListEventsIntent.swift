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
    public static let description = IntentDescription("List events within a given timeframe")

    @Parameter(title: "Timeframe", default: .today) var timeframe: EventTimeframe

    private let repositoryProvider: EventRepositoryProviding

    public init() {
        self.repositoryProvider = SharedStores.defaultProvider()
    }

    public init(repositoryProvider: EventRepositoryProviding) {
        self.repositoryProvider = repositoryProvider
    }

    public func perform() async throws -> some IntentResult & ReturnsValue<[EventEntity]> {
        let repo = try await repositoryProvider.eventRepo()

        let dtos: [EventDTO]
        switch timeframe {
        case .today:
            dtos = try await repo.eventsToday(in: .current, now: .now)
        case .past:
            dtos = try await repo.eventsBefore(.now)
        case .future:
            dtos = try await repo.eventsAfter(.now)
        }

        let entities = dtos.map {
            EventEntity(
                id: $0.id,
                title: $0.title,
                festivalName: $0.festivalName,
                date: $0.date,
                venueName: $0.venueName
            )
        }
        return .result(value: entities)
    }
}
