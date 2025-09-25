//
//  File.swift
//  CritiCalUI
//
//  Created by Scott Matthewman on 24/09/2025.
//

import CritiCalDomain
import Foundation

public actor FakeGenresReader: GenreReading & GenreWriting {
    private var genres: [GenreDTO]

    public init(genres: [GenreDTO]) {
        self.genres = genres
    }

    public func genre(byIdentifier id: UUID) async throws -> GenreDTO? {
        genres.first { $0.id == id }
    }

    public func allGenres() async throws -> [GenreDTO] {
        genres
    }

    public func activeGenres() async throws -> [GenreDTO] {
        genres.filter { $0.isDeactivated == false }
    }

    public func create(name: String, details: String, hexColor: String) async throws -> UUID {
        let gto = GenreDTO(name: name, details: details, hexColor: hexColor)
        genres.append(gto)
        return gto.id
    }

    public func update(genreID: UUID, name: String?, details: String?, hexColor: String?, isDeactivated: Bool?) async throws {
    }

    public func delete(genreID: UUID) async throws {
        self.genres = genres.filter { $0.id != genreID }
    }
}
