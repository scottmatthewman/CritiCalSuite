//
//  GenreReading.swift
//  CritiCalDomain
//
//  Created by Scott Matthewman on 22/09/2025.
//

import Foundation
import CritiCalModels

public protocol GenreReading: Sendable {
    func allGenres() async throws -> [DetachedGenre]
    func activeGenres() async throws -> [DetachedGenre]
    func genre(byIdentifier id: UUID) async throws -> DetachedGenre?
}