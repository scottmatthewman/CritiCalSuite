//
//  GenreWriting.swift
//  CritiCalStore
//
//  Created by Scott Matthewman on 22/09/2025.
//

import CritiCalCore
import CritiCalModels
import Foundation

public protocol GenreWriting: Sendable {
    func create(
        name: String,
        details: String,
        colorToken: ColorToken
    ) async throws -> UUID

    func update(
        genreID: UUID,
        name: String?,
        details: String?,
        colorToken: ColorToken?,
        isDeactivated: Bool?
    ) async throws

    func delete(genreID: UUID) async throws
}
