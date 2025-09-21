//
//  FakeReader.swift
//  CritiCalUI
//
//  Created by Scott Matthewman on 20/09/2025.
//

import CritiCalDomain
import Foundation

extension Date {
    static func iso8601(_ string: String) -> Date {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter.date(from: string) ?? .now
    }
}

struct FakeReader: EventReading {
    let events: [EventDTO]

    func event(byIdentifier id: UUID) async throws -> CritiCalDomain.EventDTO? {
        events.first { $0.id == id }
    }

    func search(text: String, limit: Int) async throws -> [CritiCalDomain.EventDTO] {
        Array(events.prefix(limit))
    }

    func eventsToday(in calendar: Calendar, now: Date) async throws -> [CritiCalDomain.EventDTO] {
        []
    }

    func eventsBefore(_ cutOff: Date) async throws -> [CritiCalDomain.EventDTO] {
        []
    }

    func eventsAfter(_ cutOff: Date) async throws -> [CritiCalDomain.EventDTO] {
        []
    }

    func eventsNext7Days(in calendar: Calendar, now: Date) async throws -> [CritiCalDomain.EventDTO] {
        []
    }

    func eventsThisMonth(in calendar: Calendar, now: Date) async throws -> [CritiCalDomain.EventDTO] {
        []
    }

    func recent(limit: Int) async throws -> [EventDTO] {
        Array(events.prefix(limit))
    }
}
