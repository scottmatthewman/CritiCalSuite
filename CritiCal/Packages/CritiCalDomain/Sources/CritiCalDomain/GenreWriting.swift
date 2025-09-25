//
//  GenreWriting.swift
//  CritiCalDomain
//
//  Created by Scott Matthewman on 22/09/2025.
//

import Foundation
import CritiCalModels

public protocol GenreWriting: Sendable {
    func create(
        name: String,
        details: String,
        hexColor: String
    ) async throws -> UUID

    func update(
        genreID: UUID,
        name: String?,
        details: String?,
        hexColor: String?,
        isDeactivated: Bool?
    ) async throws

    func delete(genreID: UUID) async throws
}