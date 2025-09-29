//
//  FakeReader.swift
//  CritiCalUI
//
//  Created by Scott Matthewman on 20/09/2025.
//

import CritiCalStore
import CritiCalModels
import Foundation

extension Date {
    static func iso8601(_ string: String) -> Date {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter.date(from: string) ?? .now
    }
}

struct FakeEventsReader: EventReading {
    let events: [DetachedEvent]

    func event(byIdentifier id: UUID) async throws -> DetachedEvent? {
        events.first { $0.id == id }
    }

    func search(text: String, limit: Int) async throws -> [DetachedEvent] {
        Array(events.prefix(limit))
    }

    func eventsToday(in calendar: Calendar, now: Date) async throws -> [DetachedEvent] {
        []
    }

    func eventsBefore(_ cutOff: Date) async throws -> [DetachedEvent] {
        []
    }

    func eventsAfter(_ cutOff: Date) async throws -> [DetachedEvent] {
        []
    }

    func eventsNext7Days(in calendar: Calendar, now: Date) async throws -> [DetachedEvent] {
        []
    }

    func eventsThisMonth(in calendar: Calendar, now: Date) async throws -> [DetachedEvent] {
        []
    }

    func recent(limit: Int) async throws -> [DetachedEvent] {
        Array(events.prefix(limit))
    }
}
