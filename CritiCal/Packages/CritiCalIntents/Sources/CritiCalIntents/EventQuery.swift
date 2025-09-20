//
//  EventQuery.swift
//  CritiCalIntents
//
//  Created by Scott Matthewman on 18/09/2025.
//

import AppIntents
import Foundation
import CritiCalDomain
import CritiCalStore

public struct EventQuery: EntityQuery, Sendable {
    public typealias Entity = EventEntity

    private let repositoryProvider: EventRepositoryProviding

    public init() {
        // Use the default provider factory method
        self.repositoryProvider = SharedStores.defaultProvider()
    }

    public init(repositoryProvider: EventRepositoryProviding) {
        self.repositoryProvider = repositoryProvider
    }

    // Offer suggestions when Shortcuts needs a list.
    public func suggestedEntities() async throws -> [EventEntity] {
        let repo = try await repositoryProvider.eventRepo()
        let recent = try await repo.recent(limit: 10)
        return recent.map { entity(from: $0) }
    }

    // Resolve a specific ID saved in a Shortcut.
    public func entities(for identifiers: [UUID]) async throws -> [EventEntity] {
        let repo = try await repositoryProvider.eventRepo()
        var results: [EventEntity] = []
        results.reserveCapacity(identifiers.count)
        for id in identifiers {
            if let dto = try await repo.event(byIdentifier: id) {
                results.append(entity(from: dto))
            }
        }
        return results
    }

    // Free-text search in Shortcuts' picker.
    public func suggestedEntities(for query: String) async throws -> [EventEntity] {
        let repo = try await repositoryProvider.eventRepo()
        let results = try await repo.search(text: query, limit: 10)
        return results.map { entity(from: $0) }
    }

    private func entity(from dto: EventDTO) -> EventEntity {
        EventEntity(
            id: dto.id,
            title: dto.title,
            date: dto.date,
            venueName: dto.venueName
        )
    }
}

