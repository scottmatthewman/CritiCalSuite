//
//  MockRepositoryProvider.swift
//  CritiCalIntentsTests
//
//  Created by Claude on 20/09/2025.
//

import Foundation
import CritiCalModels
import CritiCalStore
@testable import CritiCalIntents

/// Mock repository for testing that implements EventReading & EventWriting protocols
actor MockEventRepository: EventReading & EventWriting {
    private var mockEvents: [DetachedEvent] = []
    private(set) var recentCalled = false
    private(set) var searchCalled = false
    private(set) var eventByIdCalled = false
    private(set) var lastSearchQuery: String?
    private(set) var lastRecentLimit: Int?

    /// Add mock event data for testing
    func addMockEvent(_ event: DetachedEvent) {
        mockEvents.append(event)
    }

    /// Add multiple mock events for testing
    func addMockEvents(_ events: [DetachedEvent]) {
        mockEvents.append(contentsOf: events)
    }

    /// Clear all mock data and reset call tracking
    func reset() {
        mockEvents.removeAll()
        recentCalled = false
        searchCalled = false
        eventByIdCalled = false
        lastSearchQuery = nil
        lastRecentLimit = nil
    }

    // MARK: - EventReading Implementation

    func recent(limit: Int) async throws -> [DetachedEvent] {
        recentCalled = true
        lastRecentLimit = limit
        return Array(mockEvents.prefix(limit))
    }

    func event(byIdentifier id: UUID) async throws -> DetachedEvent? {
        eventByIdCalled = true
        return mockEvents.first { $0.id == id }
    }

    func search(text: String, limit: Int) async throws -> [DetachedEvent] {
        searchCalled = true
        lastSearchQuery = text
        return mockEvents.filter {
            $0.title.localizedCaseInsensitiveContains(text) ||
            $0.venueName.localizedCaseInsensitiveContains(text)
        }.prefix(limit).map { $0 }
    }

    // MARK: - Timeframe-based queries

    func eventsToday(in calendar: Calendar = .current, now: Date = .now) async throws -> [DetachedEvent] {
        let startOfDay = calendar.startOfDay(for: now)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!

        return mockEvents.filter { event in
            event.date >= startOfDay && event.date < endOfDay
        }
    }

    func eventsBefore(_ cutOff: Date = .now) async throws -> [DetachedEvent] {
        return mockEvents.filter { event in
            event.date <= cutOff
        }
    }

    func eventsAfter(_ cutOff: Date = .now) async throws -> [DetachedEvent] {
        return mockEvents.filter { event in
            event.date >= cutOff
        }
    }

    func eventsNext7Days(in calendar: Calendar = .current, now: Date = .now) async throws -> [DetachedEvent] {
        let startOfToday = calendar.startOfDay(for: now)
        guard let endOf7Days = calendar.date(byAdding: .day, value: 7, to: startOfToday) else {
            return []
        }

        return mockEvents.filter { event in
            event.date >= startOfToday && event.date < endOf7Days
        }
    }

    func eventsThisMonth(in calendar: Calendar = .current, now: Date = .now) async throws -> [DetachedEvent] {
        guard let range = calendar.dateInterval(of: .month, for: now) else {
            return []
        }

        return mockEvents.filter { event in
            event.date >= range.start && event.date <= range.end
        }
    }

    // MARK: - EventWriting Implementation

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
    ) async throws -> UUID {
        let id = UUID()
        let newEvent = DetachedEvent(
            id: id,
            title: title,
            festivalName: festivalName,
            date: date,
            durationMinutes: durationMinutes,
            venueName: venueName,
            confirmationStatus: confirmationStatus,
            url: url,
            details: details,
            genre: nil
        )
        mockEvents.append(newEvent)
        return id
    }

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
    ) async throws {
        guard let index = mockEvents.firstIndex(where: { $0.id == eventID }) else {
            throw EventStoreError.notFound
        }

        let existingEvent = mockEvents[index]
        let updatedEvent = DetachedEvent(
            id: eventID,
            title: title ?? existingEvent.title,
            festivalName: festivalName ?? existingEvent.festivalName,
            date: date ?? existingEvent.date,
            durationMinutes: durationMinutes ?? existingEvent.durationMinutes,
            venueName: venueName ?? existingEvent.venueName,
            confirmationStatus: confirmationStatus ?? existingEvent.confirmationStatus,
            url: url ?? existingEvent.url,
            details: details ?? existingEvent.details,
            genre: existingEvent.genre
        )
        mockEvents[index] = updatedEvent
    }

    func delete(eventID: UUID) async throws {
        guard let index = mockEvents.firstIndex(where: { $0.id == eventID }) else {
            throw EventStoreError.notFound
        }
        mockEvents.remove(at: index)
    }
}

/// Actor to safely manage mock repository instances for testing
actor MockRepositoryStorage {
    static let shared = MockRepositoryStorage()

    private var repositories: [UUID: MockEventRepository] = [:]

    private init() {}

    func createRepository(id: UUID) -> MockEventRepository {
        let repository = MockEventRepository()
        repositories[id] = repository
        return repository
    }

    func getRepository(id: UUID) -> MockEventRepository? {
        return repositories[id]
    }

    func removeRepository(id: UUID) {
        repositories.removeValue(forKey: id)
    }

    func removeAllRepositories() {
        repositories.removeAll()
    }
}

/// Thread-safe mock repository provider using actor-based storage
public struct MockRepositoryProvider: EventRepositoryProviding, Sendable {
    private let repositoryID: UUID

    public init() {
        self.repositoryID = UUID()
    }

    nonisolated public func eventRepo() async throws -> any EventReading & EventWriting {
        // Always ensure repository exists when accessed
        if let repository = await MockRepositoryStorage.shared.getRepository(id: repositoryID) {
            return repository
        } else {
            // Create repository if it doesn't exist
            return await MockRepositoryStorage.shared.createRepository(id: repositoryID)
        }
    }

    /// Helper to add mock data
    public func addMockEvent(_ event: DetachedEvent) async {
        let repository = await getOrCreateRepository()
        await repository.addMockEvent(event)
    }

    /// Helper to add multiple mock events
    public func addMockEvents(_ events: [DetachedEvent]) async {
        let repository = await getOrCreateRepository()
        await repository.addMockEvents(events)
    }

    /// Helper to get or create repository
    private func getOrCreateRepository() async -> MockEventRepository {
        if let repository = await MockRepositoryStorage.shared.getRepository(id: repositoryID) {
            return repository
        } else {
            return await MockRepositoryStorage.shared.createRepository(id: repositoryID)
        }
    }

    /// Helper to reset mock state
    public func reset() async {
        let repository = await getOrCreateRepository()
        await repository.reset()
    }

    /// Helper to check if recent was called
    public func wasRecentCalled() async -> Bool {
        let repository = await getOrCreateRepository()
        return await repository.recentCalled
    }

    /// Helper to check if search was called
    public func wasSearchCalled() async -> Bool {
        let repository = await getOrCreateRepository()
        return await repository.searchCalled
    }

    /// Helper to check search query
    public func getLastSearchQuery() async -> String? {
        let repository = await getOrCreateRepository()
        return await repository.lastSearchQuery
    }

    /// Helper to check recent limit
    public func getLastRecentLimit() async -> Int? {
        let repository = await getOrCreateRepository()
        return await repository.lastRecentLimit
    }
}
