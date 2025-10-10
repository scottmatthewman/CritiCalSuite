//
//  File.swift
//  CritiCalUI
//
//  Created by Scott Matthewman on 24/09/2025.
//

import CritiCalCore
import CritiCalModels
import CritiCalStore
import Foundation

public actor FakeGenresReader: GenreReading & GenreWriting {
    private var genres: [DetachedGenre]

    public init(genres: [DetachedGenre]) {
        self.genres = genres
    }

    public func genre(byIdentifier id: UUID) async throws -> DetachedGenre? {
        genres.first { $0.id == id }
    }

    public func allGenres() async throws -> [DetachedGenre] {
        genres
    }

    public func activeGenres() async throws -> [DetachedGenre] {
        genres.filter { $0.isDeactivated == false }
    }

    public func create(
        name: String,
        details: String,
        colorToken: ColorToken
    ) async throws -> UUID {
        let id = UUID()
        let genre = DetachedGenre(
            id: id,
            name: name,
            details: details,
            colorToken: colorToken,
            symbolName: "theatermasks",
            isDeactivated: false
        )
        genres.append(genre)
        return id
    }

    public func update(
        genreID: UUID,
        name: String?,
        details: String?,
        colorToken: ColorToken?,
        isDeactivated: Bool?
    ) async throws {
    }

    public func delete(genreID: UUID) async throws {
        self.genres = genres.filter { $0.id != genreID }
    }
}
