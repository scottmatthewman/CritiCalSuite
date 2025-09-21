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
        festivalName: String,
        date: Date,
        venueName: String
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
    func recent(limit: Int) async throws -> [EventDTO]
    func event(byIdentifier id: UUID) async throws -> EventDTO?
    func search(text: String, limit: Int) async throws -> [EventDTO]

    // Timeframe-based queries
    func eventsToday(in calendar: Calendar, now: Date) async throws -> [EventDTO]
    func eventsBefore(_ cutOff: Date) async throws -> [EventDTO]
    func eventsAfter(_ cutOff: Date) async throws -> [EventDTO]
}

public protocol EventWriting: Sendable {
    @discardableResult func create(title: String, festivalName: String, venueName: String, date: Date) async throws -> UUID
    func update(eventID: UUID, title: String?, festivalName: String?, date: Date?, venueName: String?) async throws
    func delete(eventID: UUID) async throws
}

