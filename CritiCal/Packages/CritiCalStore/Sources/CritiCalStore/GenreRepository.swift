//
//  GenreRepository.swift
//  CritiCalStore
//
//  Created by Scott Matthewman on 22/09/2025.
//

import SwiftData
import Foundation
import CritiCalDomain
import CritiCalModels

@ModelActor
public actor GenreRepository: GenreReading & GenreWriting {

    // MARK: - GenreReading

    public func allGenres() async throws -> [GenreDTO] {
        let fd = FetchDescriptor<Genre>(sortBy: [SortDescriptor(\.name)])
        let genres = try modelContext.fetch(fd)
        return genres.map { $0.dto }
    }

    public func activeGenres() async throws -> [GenreDTO] {
        let fd = FetchDescriptor<Genre>(
            predicate: #Predicate { !$0.isDeactivated },
            sortBy: [SortDescriptor(\.name)]
        )
        let genres = try modelContext.fetch(fd)
        return genres.map { $0.dto }
    }

    public func genre(byIdentifier id: UUID) async throws -> GenreDTO? {
        let fd = FetchDescriptor<Genre>(predicate: #Predicate { $0.identifier == id })
        if let genre = try modelContext.fetch(fd).first {
            return genre.dto
        } else {
            return nil
        }
    }

    // MARK: - GenreWriting

    public func create(
        name: String,
        details: String,
        hexColor: String
    ) async throws -> UUID {
        let newGenre = Genre(
            name: name,
            details: details,
            hexColor: hexColor
        )
        modelContext.insert(newGenre)
        do {
            try modelContext.save()
            return newGenre.identifier ?? UUID()
        } catch {
            throw EventStoreError.saveFailed(error)
        }
    }

    public func update(
        genreID: UUID,
        name: String?,
        details: String?,
        hexColor: String?,
        isDeactivated: Bool?
    ) async throws {
        let fd = FetchDescriptor<Genre>(predicate: #Predicate { $0.identifier == genreID })
        guard let genre = try modelContext.fetch(fd).first else {
            throw EventStoreError.notFound
        }

        if let name { genre.name = name }
        if let details { genre.details = details }
        if let hexColor { genre.hexColor = hexColor }
        if let isDeactivated { genre.isDeactivated = isDeactivated }

        do {
            try modelContext.save()
        } catch {
            throw EventStoreError.saveFailed(error)
        }
    }

    public func delete(genreID: UUID) async throws {
        let fd = FetchDescriptor<Genre>(predicate: #Predicate { $0.identifier == genreID })
        guard let genre = try modelContext.fetch(fd).first else {
            throw EventStoreError.notFound
        }

        modelContext.delete(genre)
        do {
            try modelContext.save()
        } catch {
            throw EventStoreError.deleteFailed(error)
        }
    }
}

private extension Genre {
    var dto: GenreDTO {
        GenreDTO(
            id: identifier ?? UUID(),
            name: name,
            details: details,
            hexColor: hexColor,
            isDeactivated: isDeactivated
        )
    }
}