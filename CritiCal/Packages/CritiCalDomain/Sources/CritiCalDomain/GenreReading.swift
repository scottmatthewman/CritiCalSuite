//
//  GenreReading.swift
//  CritiCalDomain
//
//  Created by Scott Matthewman on 22/09/2025.
//

import Foundation

public protocol GenreReading: Sendable {
    func allGenres() async throws -> [GenreDTO]
    func activeGenres() async throws -> [GenreDTO]
    func genre(byIdentifier id: UUID) async throws -> GenreDTO?
}