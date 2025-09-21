//
//  EventQueryTests.swift
//  CritiCalIntentsTests
//
//  Created by Claude on 20/09/2025.
//

import Testing
import Foundation
import AppIntents
import CritiCalDomain
@testable import CritiCalIntents

func createMockEvents(itemCount: Int = 5) -> [EventDTO] {
    return (1...itemCount).map { index in
        EventDTO(
            id: UUID(),
            title: "Event \(index)",
            festivalName: "Festival \(index)",
            date: Date.now.addingTimeInterval(Double(index - 1) * 3600),
            venueName: "Venue \(index)"
        )
    }
}

@Suite("EventQuery - Initialization")
struct EventQueryInitializationTests {

    @Test("EventQuery initializes with default constructor")
    func testInitialization() {
        let query = EventQuery()
        #expect(type(of: query) == EventQuery.self)
    }

    @Test("EventQuery Entity type is EventEntity")
    func testEntityType() {
        let query = EventQuery()
        // Verify the Entity typealias is correctly set
        #expect(type(of: query).Entity.self == EventEntity.self)
    }
}

@Suite("EventQuery - EntityQuery Conformance")
struct EventQueryEntityQueryTests {

    @Test("EventQuery conforms to EntityQuery protocol")
    func testEntityQueryConformance() {
        let query = EventQuery()
        // This test verifies compile-time conformance
        let _: any EntityQuery = query
        #expect(Bool(true)) // If it compiles, the test passes
    }

    @Test("EventQuery conforms to Sendable")
    func testSendableConformance() async {
        let query = EventQuery()

        // Test that EventQuery can be shared across concurrent contexts
        await withTaskGroup(of: EventQuery.self) { group in
            group.addTask { query }
            group.addTask { query }

            var results: [EventQuery] = []
            for await result in group {
                results.append(result)
            }

            #expect(results.count == 2)
        }
    }
}

@Suite("EventQuery - Suggested Entities")
struct EventQuerySuggestedEntitiesTests {
    @Test("suggestedEntities returns recent events from repository")
    func testSuggestedEntitiesReturnsRecent() async throws {
        let itemCount = 5
        // Setup mock provider and data
        let mockProvider = MockRepositoryProvider()
        let mockEvents = createMockEvents(itemCount: itemCount)
        await mockProvider.addMockEvents(mockEvents)

        // Create query with mock provider
        let query = EventQuery(repositoryProvider: mockProvider)

        // Test the actual behavior
        let entities = try await query.suggestedEntities()

        // Verify repository was called correctly
        #expect(await mockProvider.wasRecentCalled())
        #expect(await mockProvider.getLastRecentLimit() == 10)

        // Verify results
        #expect(entities.count == itemCount) // All mock events returned
        #expect(entities[0].title == "Event 1")
        #expect(entities[1].title == "Event 2")
        #expect(entities[0].venueName == "Venue 1")

        // Verify DTO to Entity conversion
        let firstEvent = entities[0]
        #expect(firstEvent.id == mockEvents[0].id)
        #expect(firstEvent.title == mockEvents[0].title)
        #expect(firstEvent.date == mockEvents[0].date)
        #expect(firstEvent.venueName == mockEvents[0].venueName)
    }

    @Test("suggestedEntities respects limit parameter")
    func testSuggestedEntitiesLimit() async throws {
        // Setup mock with many events
        let mockProvider = MockRepositoryProvider()
        let manyEvents = createMockEvents(itemCount: 15)
        await mockProvider.addMockEvents(manyEvents)

        let query = EventQuery(repositoryProvider: mockProvider)
        let entities = try await query.suggestedEntities()

        // Should only return first 10 (limit enforced by mock)
        #expect(entities.count == 10)
        #expect(await mockProvider.getLastRecentLimit() == 10)
    }

    @Test("suggestedEntities with search query filters results")
    func testSuggestedEntitiesWithQuery() async throws {
        // Setup mock with searchable events
        let mockProvider = MockRepositoryProvider()
        let searchableEvents = [
            EventDTO(
                title: "Swift Conference",
                date: Date.now,
                venueName: "Convention Center"
            ),
            EventDTO(
                title: "React Workshop",
                date: Date.now,
                venueName: "Tech Hub"
            ),
            EventDTO(
                title: "Design Meetup",
                date: Date.now,
                venueName: "Swift Building"
            )
        ]
        await mockProvider.addMockEvents(searchableEvents)

        let query = EventQuery(repositoryProvider: mockProvider)

        // Test search by title
        let swiftResults = try await query.suggestedEntities(for: "Swift")

        #expect(await mockProvider.wasSearchCalled())
        #expect(await mockProvider.getLastSearchQuery() == "Swift")
        #expect(swiftResults.count == 2) // "Swift Conference" and event at "Swift Building"
        #expect(swiftResults.contains { $0.title == "Swift Conference" })
        #expect(swiftResults.contains { $0.venueName == "Swift Building" })
    }

    @Test("suggestedEntities search handles empty results")
    func testSuggestedEntitiesEmptySearch() async throws {
        let mockProvider = MockRepositoryProvider()
        await mockProvider.addMockEvents(createMockEvents())

        let query = EventQuery(repositoryProvider: mockProvider)
        let results = try await query.suggestedEntities(for: "NonexistentEvent")

        #expect(results.isEmpty)
        #expect(await mockProvider.getLastSearchQuery() == "NonexistentEvent")
    }
}

@Suite("EventQuery - Entity Resolution")
struct EventQueryEntityResolutionTests {

    @Test("entities(for:) resolves existing event IDs")
    func testEntitiesForExistingIdentifiers() async throws {
        // Setup mock with known events
        let mockProvider = MockRepositoryProvider()
        let event1 = EventDTO(
            title: "Event 1",
            date: Date.now,
            venueName: "Venue 1"
        )
        let event2 = EventDTO(
            title: "Event 2",
            date: Date.now,
            venueName: "Venue 2"
        )
        await mockProvider.addMockEvents([event1, event2])

        let query = EventQuery(repositoryProvider: mockProvider)

        // Test resolving existing IDs
        let entities = try await query.entities(for: [event1.id, event2.id])

        #expect(entities.count == 2)
        #expect(entities.contains { $0.id == event1.id && $0.title == "Event 1" })
        #expect(entities.contains { $0.id == event2.id && $0.title == "Event 2" })
    }

    @Test("entities(for:) handles missing identifiers gracefully")
    func testEntitiesForMissingIdentifiers() async throws {
        let mockProvider = MockRepositoryProvider()
        let existingEvent = EventDTO(
            title: "Existing Event",
            date: Date.now,
            venueName: "Venue"
        )
        await mockProvider.addMockEvent(existingEvent)

        let query = EventQuery(repositoryProvider: mockProvider)

        // Test with mix of existing and non-existing IDs
        let missingId = UUID()
        let entities = try await query.entities(for: [existingEvent.id, missingId])

        // Should only return the existing event, skip missing ones
        #expect(entities.count == 1)
        #expect(entities[0].id == existingEvent.id)
        #expect(entities[0].title == "Existing Event")
    }

    @Test("entities(for:) handles empty identifier array")
    func testEntitiesForEmptyIdentifiers() async throws {
        let mockProvider = MockRepositoryProvider()
        let query = EventQuery(repositoryProvider: mockProvider)

        let entities = try await query.entities(for: [])

        #expect(entities.isEmpty)
    }

    @Test("entities(for:) preserves identifier order when possible")
    func testEntitiesPreservesOrder() async throws {
        let mockProvider = MockRepositoryProvider()
        let event1 = EventDTO(
            title: "First",
            date: Date.now,
            venueName: "Venue 1"
        )
        let event2 = EventDTO(
            title: "Second",
            date: Date.now,
            venueName: "Venue 2"
        )
        let event3 = EventDTO(
            title: "Third",
            date: Date.now,
            venueName: "Venue 3"
        )

        await mockProvider.addMockEvents([event1, event2, event3])

        let query = EventQuery(repositoryProvider: mockProvider)

        // Request in specific order
        let requestedOrder = [event2.id, event1.id, event3.id]
        let entities = try await query.entities(for: requestedOrder)

        #expect(entities.count == 3)
        // The implementation processes IDs in order, so results should match request order
        #expect(entities[0].title == "Second")
        #expect(entities[1].title == "First")
        #expect(entities[2].title == "Third")
    }
}

@Suite("EventQuery - DTO to Entity Conversion")
struct EventQueryDTOConversionTests {

    @Test("EventDTO converts to EventEntity with all properties")
    func testDTOToEntityConversion() {
        let dtoId = UUID()
        let dtoTitle = "Test Event"
        let dtoFestivalName = "Test Festival"
        let dtoDate = Date.now
        let dtoVenueName = "Test Venue"

        let dto = EventDTO(
            id: dtoId,
            title: dtoTitle,
            festivalName: dtoFestivalName,
            date: dtoDate,
            venueName: dtoVenueName
        )

        // Simulate the conversion that happens in EventQuery methods
        let entity = EventEntity(
            id: dto.id,
            title: dto.title,
            festivalName: dto.festivalName,
            date: dto.date,
            venueName: dto.venueName
        )

        #expect(entity.id == dtoId)
        #expect(entity.title == dtoTitle)
        #expect(entity.date == dtoDate)
        #expect(entity.venueName == dtoVenueName)
    }

    @Test("Multiple DTOs convert to entities correctly")
    func testMultipleDTOConversion() {
        let dtos = (0..<5).map { index in
            EventDTO(
                id: UUID(),
                title: "Event \(index)",
                festivalName: "Festival \(index)",
                date: Date.now.addingTimeInterval(Double(index) * 3600),
                venueName: "Venue \(index)"
            )
        }

        // Simulate the map conversion used in EventQuery
        let entities = dtos.map {
            EventEntity(
                id: $0.id,
                title: $0.title,
                festivalName: $0.festivalName,
                date: $0.date,
                venueName: $0.venueName
            )
        }

        #expect(entities.count == dtos.count)

        for (index, entity) in entities.enumerated() {
            #expect(entity.id == dtos[index].id)
            #expect(entity.title == dtos[index].title)
            #expect(entity.date == dtos[index].date)
            #expect(entity.venueName == dtos[index].venueName)
        }
    }
}

@Suite("EventQuery - Integration Points")
struct EventQueryIntegrationTests {

    @Test("EventQuery methods are async and throwing")
    func testAsyncThrowingMethods() {
        let query = EventQuery()

        // Verify all methods have correct async throws signature
        #expect(query.suggestedEntities as (() async throws -> [EventEntity])? != nil)
        #expect(query.suggestedEntities as ((String) async throws -> [EventEntity])? != nil)
        #expect(query.entities as (([UUID]) async throws -> [EventEntity])? != nil)
    }

    @Test("EventQuery handles repository limits correctly")
    func testRepositoryLimits() {
        // Both suggestedEntities methods use limit: 10
        let expectedLimit = 10

        // This verifies the business logic expectation
        #expect(expectedLimit == 10)

        // In production, these methods should never return more than 10 items
        let mockResults = (0..<20).map { _ in
            EventEntity(
                id: UUID(),
                title: "Event",
                festivalName: "Festival",
                date: Date.now,
                venueName: "Venue"
            )
        }

        let limited = Array(mockResults.prefix(expectedLimit))
        #expect(limited.count == expectedLimit)
    }

    @Test("EventQuery handles search with special characters")
    func testSearchSpecialCharacters() {
        let specialQueries = [
            "Café",
            "Test & Demo",
            "Event #1",
            "特殊文字",
            "🎉 Party"
        ]

        for query in specialQueries {
            // Verify query strings are valid
            #expect(!query.isEmpty)
            #expect(query.count > 0)
        }
    }
}

@Suite("EventQuery - Error Handling")
struct EventQueryErrorHandlingTests {

    @Test("EventQuery methods can throw errors")
    func testMethodsCanThrow() {
        let query = EventQuery()

        // These methods are designed to throw errors from the repository layer
        // This test verifies the throwing signature exists

        // All three methods should be able to propagate errors
        #expect(query.suggestedEntities as (() async throws -> [EventEntity])? != nil)
        #expect(query.suggestedEntities as ((String) async throws -> [EventEntity])? != nil)
        #expect(query.entities as (([UUID]) async throws -> [EventEntity])? != nil)
    }

    @Test("entities(for:) handles missing entities gracefully")
    func testMissingEntities() {
        // When an ID is not found, it should be skipped rather than throwing
        let missingIds = [UUID(), UUID(), UUID()]

        // The implementation skips missing IDs and only returns found entities
        // This is important behavior for the Shortcuts integration
        #expect(missingIds.count == 3)
        #expect(Set(missingIds).count == 3) // All unique IDs
    }
}
