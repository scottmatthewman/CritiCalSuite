//
//  EventWriting.swift
//  CritiCalDomain
//
//  Created by Scott Matthewman on 21/09/2025.
//
import Foundation

public protocol EventWriting: Sendable {
    /// Create a new event with the specified details, returning its unique identifier.
    @discardableResult
    func create(
        title: String,
        festivalName: String,
        venueName: String,
        date: Date,
        durationMinutes: Int?,
        confirmationStatus: ConfirmationStatus,
        url: URL?,
        details: String
    ) async throws -> UUID

    /// Update an existing event identified by its unique identifier with the provided details.
    func update(
        eventID: UUID,
        title: String?,
        festivalName: String?,
        venueName: String?,
        date: Date?,
        durationMinutes: Int?,
        confirmationStatus: ConfirmationStatus?,
        url: URL?,
        details: String?
    ) async throws

    /// Delete the event identified by its unique identifier.
    func delete(
        eventID: UUID
    ) async throws
}
