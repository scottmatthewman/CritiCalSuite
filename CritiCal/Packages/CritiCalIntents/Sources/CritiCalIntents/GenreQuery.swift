//
//  GenreQuery.swift
//  CritiCalIntents
//
//  Created by Scott Matthewman on 22/09/2025.
//

import AppIntents
import CritiCalStore
import Foundation

public struct GenreQuery: EntityQuery {
    public init() {}

    public func entities(for identifiers: [UUID]) async throws -> [GenreEntity] {
        let container = try await SharedStoresActor.shared.getContainer()
        let repository = GenreRepository(modelContainer: container)
        var results: [GenreEntity] = []

        for identifier in identifiers {
            if let dto = try await repository.genre(byIdentifier: identifier) {
                results.append(GenreEntity(from: dto))
            }
        }

        return results
    }

    public func suggestedEntities() async throws -> [GenreEntity] {
        let container = try await SharedStoresActor.shared.getContainer()
        let repository = GenreRepository(modelContainer: container)
        let dtos = try await repository.activeGenres()
        return dtos.map { GenreEntity(from: $0) }
    }
}
