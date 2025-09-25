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

    public func recent(limit: Int) async throws -> [DetachedEvent] {
        var fd = FetchDescriptor<Event>(sortBy: [SortDescriptor(\.date, order: .reverse)])
        fd.fetchLimit = limit

        let entries = try modelContext.fetch(fd)
        return entries.map { $0.detached() }
    }

    public func event(byIdentifier id: UUID) async throws -> DetachedEvent? {
        let fd = FetchDescriptor<Event>(predicate: #Predicate { $0.identifier == id })
        if let event = try modelContext.fetch(fd).first {
            return event.detached()
        } else {
            return nil
        }
    }

    public func search(text: String, limit: Int) async throws -> [DetachedEvent] {
        var fd = FetchDescriptor(predicate: #Predicate<Event> {
            $0.title.localizedStandardContains(text) ||
            $0.venueName.localizedStandardContains(text)
        })
        fd.fetchLimit = limit

        let entries = try modelContext.fetch(fd)
        return entries.map { $0.detached() }
    }

    // MARK: Time-based querying
    public func eventsToday(
        in calendar: Calendar = .current,
        now: Date = .now
    ) async throws -> [DetachedEvent] {
        guard
            let range = calendar.dateInterval(of: .day, for: now)
        else { return [] }

        return try await eventsIn(interval: range)
    }

    public func eventsBefore(_ cutOff: Date = .now) async throws -> [DetachedEvent] {
        let predicate = #Predicate<Event> { $0.date <= cutOff }
        let fetchDescriptor = FetchDescriptor<Event>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        return try modelContext.fetch(fetchDescriptor).map { $0.detached() }
    }

    public func eventsAfter(_ cutOff: Date = .now) async throws -> [DetachedEvent] {
        let predicate = #Predicate<Event> { $0.date >= cutOff }
        let fetchDescriptor = FetchDescriptor<Event>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.date, order: .forward)]
        )
        return try modelContext.fetch(fetchDescriptor).map { $0.detached() }
    }

    public func eventsIn(interval: DateInterval, order: SortOrder = .forward) async throws -> [DetachedEvent] {
        let predicate = #Predicate<Event> {
            $0.date >= interval.start && $0.date <= interval.end
        }
        let fetchDescriptor = FetchDescriptor<Event>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.date, order: order)]
        )

        let events = try modelContext.fetch(fetchDescriptor)
        let dtos = events.map { $0.detached() }
        return dtos
    }

    public func eventsNext7Days(
        in calendar: Calendar = .current,
        now: Date = .now
    ) async throws -> [DetachedEvent] {
        guard
            let startOfToday = calendar.dateInterval(of: .day, for: now)?.start,
            let endOf7Days = calendar.date(byAdding: .day, value: 7, to: startOfToday)
        else { return [] }

        let interval = DateInterval(start: startOfToday, end: endOf7Days)
        return try await eventsIn(interval: interval)
    }

    public func eventsThisMonth(
        in calendar: Calendar = .current,
        now: Date = .now
    ) async throws -> [DetachedEvent] {
        guard
            let range = calendar.dateInterval(of: .month, for: now)
        else { return [] }

        return try await eventsIn(interval: range)
    }

    // MARK: - EventWriting

    public func create(
        title: String,
        festivalName: String,
        venueName: String,
        date: Date,
        durationMinutes: Int? = nil,
        confirmationStatus: ConfirmationStatus = .draft,
        url: URL? = nil,
        details: String
    ) async throws -> UUID {
        let newEvent = Event(
            title: title,
            festivalName: festivalName,
            venueName: venueName,
            date: date,
            durationMinutes: durationMinutes,
            url: url,
            details: details
        )
        newEvent.confirmationStatus = confirmationStatus
        modelContext.insert(newEvent)
        do {
            try modelContext.save()
            return newEvent.identifier
        } catch {
            throw EventStoreError.saveFailed(error)
        }
    }

    public func update(
        eventID: UUID,
        title: String?,
        festivalName: String?,
        venueName: String?,
        date: Date?,
        durationMinutes: Int?,
        confirmationStatus: ConfirmationStatus?,
        url: URL?,
        details: String?
    ) async throws {
        let fd = FetchDescriptor<Event>(predicate: #Predicate { $0.identifier == eventID })
        guard let event = try modelContext.fetch(fd).first else {
            throw EventStoreError.notFound
        }

        if let title { event.title = title }
        if let festivalName { event.festivalName = festivalName }
        if let date { event.date = date }
        if let venueName { event.venueName = venueName }
        if let durationMinutes { event.durationMinutes = durationMinutes }
        if let confirmationStatus { event.confirmationStatus = confirmationStatus }
        if let url { event.url = url }
        if let details { event.details = details }
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

