//
//  ListEventsIntent.swift
//  CritiCalIntents
//
//  Created by Scott Matthewman on 18/09/2025.
//

import AppIntents
import Foundation
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
        case .next7Days:
            dtos = try await repo.eventsNext7Days(in: .current, now: .now)
        case .thisMonth:
            dtos = try await repo.eventsThisMonth(in: .current, now: .now)
        }

        let entities = dtos.map {
            EventEntity(from: $0)
        }
        return .result(value: entities)
    }
}
