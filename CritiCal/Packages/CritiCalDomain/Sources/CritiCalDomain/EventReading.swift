//
//  EventReading.swift
//  CritiCalDomain
//
//  Created by Scott Matthewman on 21/09/2025.
//

import Foundation

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
    /// Fetch events occurring in the next 7 days starting from today
    func eventsNext7Days(in calendar: Calendar, now: Date) async throws -> [EventDTO]
    /// Fetch events occurring in the current calendar month
    func eventsThisMonth(in calendar: Calendar, now: Date) async throws -> [EventDTO]
}
