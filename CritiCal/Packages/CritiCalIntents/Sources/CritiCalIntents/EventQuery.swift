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

    public init() {}

    // Offer suggestions when Shortcuts needs a list.
    public func suggestedEntities() async throws -> [EventEntity] {
        let repo = try await SharedStores.eventRepo()
        let recent = try await repo.recent(limit: 10)
        return recent
            .map {
                EventEntity(
                    id: $0.id,
                    title: $0.title,
                    date: $0.date,
                    venueName: $0.venueName
                )
            }
    }

    // Resolve a specific ID saved in a Shortcut.
    public func entities(for identifiers: [UUID]) async throws -> [EventEntity] {
        let repo = try await SharedStores.eventRepo()
        var results: [EventEntity] = []
        results.reserveCapacity(identifiers.count)
        for id in identifiers {
            if let dto = try await repo.event(byIdentifier: id) {
                results.append(
                    EventEntity(
                        id: dto.id,
                        title: dto.title,
                        date: dto.date,
                        venueName: dto.venueName
                    )
                )
            }
        }
        return results
    }

    // Free-text search in Shortcuts’ picker.
    public func suggestedEntities(for query: String) async throws -> [EventEntity] {
        let repo = try await SharedStores.eventRepo()
        let results = try await repo.search(text: query, limit: 10)
        return results
            .map {
                EventEntity(
                    id: $0.id,
                    title: $0.title,
                    date: $0.date,
                    venueName: $0.venueName
                )
            }
    }
}

