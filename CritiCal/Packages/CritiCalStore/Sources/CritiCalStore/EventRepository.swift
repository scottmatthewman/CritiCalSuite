//
//  EventStore.swift
//  CritiCalStore
//
//  Created by Scott Matthewman on 18/09/2025.
//

import SwiftData
import Foundation
import CritiCalDomain
import CritiCalModels

@ModelActor
public actor EventRepository: EventReading & EventWriting {

    // MARK: - EventReading

    public func recent(limit: Int) async throws -> [EventDTO] {
        var fd = FetchDescriptor<Event>(sortBy: [SortDescriptor(\.date, order: .reverse)])
        fd.fetchLimit = limit

        let entries = try modelContext.fetch(fd)
        return entries.map { $0.dto }
    }

    public func event(byIdentifier id: UUID) async throws -> EventDTO? {
        let fd = FetchDescriptor<Event>(predicate: #Predicate { $0.identifier == id })
        if let event = try modelContext.fetch(fd).first {
            return event.dto
        } else {
            return nil
        }
    }

    public func search(text: String, limit: Int) async throws -> [EventDTO] {
        var fd = FetchDescriptor(predicate: #Predicate<Event> {
            $0.title.localizedStandardContains(text) ||
            $0.venueName.localizedStandardContains(text)
        })
        fd.fetchLimit = limit

        let entries = try modelContext.fetch(fd)
        return entries.map { $0.dto }
    }

    // MARK: Time-based querying
    public func eventsToday(
        in calendar: Calendar = .current,
        now: Date = .now
    ) async throws -> [EventDTO] {
        guard
            let range = calendar.dateInterval(of: .day, for: now)
        else { return [] }

        return try await eventsIn(interval: range)
    }

    public func eventsBefore(_ cutOff: Date = .now) async throws -> [EventDTO] {
        let predicate = #Predicate<Event> { $0.date <= cutOff }
        let fetchDescriptor = FetchDescriptor<Event>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        return try modelContext.fetch(fetchDescriptor).map { $0.dto }
    }

    public func eventsAfter(_ cutOff: Date = .now) async throws -> [EventDTO] {
        let predicate = #Predicate<Event> { $0.date >= cutOff }
        let fetchDescriptor = FetchDescriptor<Event>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.date, order: .forward)]
        )
        return try modelContext.fetch(fetchDescriptor).map { $0.dto }
    }

    public func eventsIn(interval: DateInterval, order: SortOrder = .forward) async throws -> [EventDTO] {
        let predicate = #Predicate<Event> {
            $0.date >= interval.start && $0.date <= interval.end
        }
        let fetchDescriptor = FetchDescriptor<Event>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.date, order: order)]
        )
        return try modelContext.fetch(fetchDescriptor).map { $0.dto }
    }

    // MARK: - EventWriting

    public func create(title: String, venueName: String, date: Date) async throws -> UUID {
        let newEvent = Event(title: title, venueName: venueName, date: date)
        modelContext.insert(newEvent)
        do {
            try modelContext.save()
            return newEvent.identifier
        } catch {
            throw EventStoreError.saveFailed(error)
        }
    }

    public func update(eventID: UUID, title: String?, date: Date?, venueName: String?) async throws {
        let fd = FetchDescriptor<Event>(predicate: #Predicate { $0.identifier == eventID })
        guard let event = try modelContext.fetch(fd).first else {
            throw EventStoreError.notFound
        }

        if let title { event.title = title }
        if let date { event.date = date }
        if let venueName { event.venueName = venueName }

        do {
            try modelContext.save()
        } catch {
            throw EventStoreError.saveFailed(error)
        }
    }

    public func delete(eventID: UUID) async throws {
        let fd = FetchDescriptor<Event>(predicate: #Predicate { $0.identifier == eventID })
        guard let event = try modelContext.fetch(fd).first else {
            throw EventStoreError.notFound
        }

        modelContext.delete(event)
        do {
            try modelContext.save()
        } catch {
            throw EventStoreError.deleteFailed(error)
        }
    }
}

private extension Event {
    var dto: EventDTO {
        .init(
            id: identifier,
            title: title,
            date: date,
            venueName: venueName
        )
    }
}
