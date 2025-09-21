//
//  EventDTO.swift
//  CritiCalDomain
//
//  Created by Scott Matthewman on 18/09/2025.
//

import Foundation

public struct EventDTO: Identifiable, Equatable, Sendable {
    public let id: UUID
    public let title: String
    public let festivalName: String
    public let date: Date
    public let venueName: String

    public init(
        id: UUID = UUID(),
        title: String,
        festivalName: String = "",
        date: Date,
        venueName: String = ""
    ) {
        self.id = id
        self.title = title
        self.festivalName = festivalName
        self.date = date
        self.venueName = venueName
    }
}

public enum EventStoreError: Error {
    case notFound
    case saveFailed(Error)
    case deleteFailed(Error)
}


public protocol EventReading: Sendable {
    /// Fetch all events, ordered by date ascending up to the specified limit.
    func recent(limit: Int) async throws -> [EventDTO]
    /// Fetch a specific event by its unique identifier.
    func event(byIdentifier id: UUID) async throws -> EventDTO?
    /// Search for events matching the provided text in title, festival name, or venue name.
    func search(text: String, limit: Int) async throws -> [EventDTO]

    // Timeframe-based queries

    /// Fetch events occurring today in the specified calendar and current date.
    func eventsToday(in calendar: Calendar, now: Date) async throws -> [EventDTO]
    /// Fetch events occurring before the current date/time
    func eventsBefore(_ cutOff: Date) async throws -> [EventDTO]
    /// Fetch events occurring after the current date/time
    func eventsAfter(_ cutOff: Date) async throws -> [EventDTO]
}

public protocol EventWriting: Sendable {
    /// Create a new event with the specified details, returning its unique identifier.
    @discardableResult
    func create(
        title: String,
        festivalName: String,
        venueName: String,
        date: Date
    ) async throws -> UUID

    /// Update an existing event identified by its unique identifier with the provided details.
    func update(
        eventID: UUID,
        title: String?,
        festivalName: String?,
        date: Date?,
        venueName: String?
    ) async throws

    /// Delete the event identified by its unique identifier.
    func delete(
        eventID: UUID
    ) async throws
}

