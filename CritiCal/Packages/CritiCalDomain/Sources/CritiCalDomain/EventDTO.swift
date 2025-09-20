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
    public let date: Date
    public let venueName: String

    public init(
        id: UUID = UUID(),
        title: String,
        date: Date,
        venueName: String
    ) {
        self.id = id
        self.title = title
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
}

public protocol EventWriting: Sendable {
    @discardableResult func create(title: String, venueName: String, date: Date) async throws -> UUID
    func update(eventID: UUID, title: String?, date: Date?, venueName: String?) async throws
    func delete(eventID: UUID) async throws
}

