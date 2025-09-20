//
//  File.swift
//  CritiCalIntents
//
//  Created by Scott Matthewman on 18/09/2025.
//

import AppIntents
import CritiCalDomain
import CritiCalStore

public struct GetEventIntent: AppIntent {
    static public let title: LocalizedStringResource = "Get Event"
    static public let description = IntentDescription("Fetch an event by choosing it from your events")

    @Parameter(title: "Event") var event: EventEntity

    private let repositoryProvider: EventRepositoryProviding

    public init() {
        self.repositoryProvider = SharedStores.defaultProvider()
    }

    public init(repositoryProvider: EventRepositoryProviding) {
        self.repositoryProvider = repositoryProvider
    }

    public func perform() async throws -> some IntentResult & ReturnsValue<EventEntity> & ProvidesDialog {
        let repo = try await repositoryProvider.eventRepo()

        // Fetch the actual event from repository to validate it exists
        guard let repositoryEvent = try await repo.event(byIdentifier: event.id) else {
            throw EventIntentError.eventNotFound(id: event.id)
        }

        // Return the validated event data from repository, not the input parameter
        let validatedEntity = EventEntity(
            id: repositoryEvent.id,
            title: repositoryEvent.title,
            date: repositoryEvent.date,
            venueName: repositoryEvent.venueName
        )

        return .result(value: validatedEntity, dialog: "Fetched \(validatedEntity.title).")
    }
}


