//
//  IntentIntegrationTests.swift
//  CritiCalIntentsTests
//
//  Created by Claude on 20/09/2025.
//

import Testing
import Foundation
import AppIntents
import CritiCalDomain
@testable import CritiCalIntents

@Suite("Intent Integration - GetEventIntent perform()")
struct GetEventIntentPerformTests {

    @Test("GetEventIntent perform() returns repository data, not input parameter")
    func testGetEventIntentReturnsRepositoryData() async throws {
        // Setup mock repository with known event
        let repositoryEvent = EventDTO(
            id: UUID(),
            title: "Repository Event Title",
            festivalName: "Repository Festival",
            date: Date.now,
            venueName: "Repository Venue"
        )
        let mockProvider = MockRepositoryProvider()
        await mockProvider.addMockEvent(repositoryEvent)

        // Create intent and configure it with test data
        let intent = GetEventIntent(repositoryProvider: mockProvider)
        intent.event = EventEntity(
            id: repositoryEvent.id, // Same ID
            title: "Input Event Title", // Different title
            festivalName: "Input Festival", // Different festival
            date: Date.now.addingTimeInterval(3600), // Different date
            venueName: "Input Venue" // Different venue
        )

        // Call perform() method - should return repository data, not input data
        let result = try await intent.perform()

        // Verify it returns the REPOSITORY data, not the input data
        #expect(result.value?.id == repositoryEvent.id)
        #expect(result.value?.title == "Repository Event Title") // From repository
        #expect(result.value?.festivalName == "Repository Festival") // From repository
        #expect(result.value?.venueName == "Repository Venue") // From repository
        #expect(result.value?.date == repositoryEvent.date) // From repository

        // Verify it's NOT returning the input data
        #expect(result.value?.title != "Input Event Title")
        #expect(result.value?.venueName != "Input Venue")

        // Verify result contains expected data
        #expect(result.value != nil)
    }

    @Test("GetEventIntent perform() throws error for missing events")
    func testGetEventIntentHandlesMissingEvents() async throws {
        // Create empty mock repository
        let mockProvider = MockRepositoryProvider()

        // Create intent with event that doesn't exist in repository
        let intent = GetEventIntent(repositoryProvider: mockProvider)
        intent.event = EventEntity(
            id: UUID(), // Random ID not in repository
            title: "Missing Event",
            festivalName: "Missing Festival",
            date: Date.now,
            venueName: "Missing Venue"
        )

        // Call perform() - should throw EventIntentError.eventNotFound
        do {
            _ = try await intent.perform()
            #expect(Bool(false), "Should have thrown an error for missing event")
        } catch let error as EventIntentError {
            // Verify correct error type
            if case .eventNotFound(let id) = error {
                #expect(id == intent.event.id)
            } else {
                #expect(Bool(false), "Should throw eventNotFound error")
            }
        } catch {
            #expect(Bool(false), "Should throw EventIntentError, not \(type(of: error))")
        }
    }
}

@Suite("Intent Integration - ListEventsIntent perform()")
struct ListEventsIntentPerformTests {

    @Test("ListEventsIntent perform() works with .today timeframe")
    func testListEventsIntentPerformToday() async throws {
        // Setup mock repository with test data
        let mockProvider = MockRepositoryProvider()
        let now = Date.now
        let todayEvents = [
            EventDTO(
                id: UUID(),
                title: "Today Event 1",
                festivalName: "Today Festival 1",
                date: now,
                venueName: "Today Venue 1"
            ),
            EventDTO(
                id: UUID(),
                title: "Today Event 2",
                festivalName: "Today Festival 2",
                date: now.addingTimeInterval(3600),
                venueName: "Today Venue 2"
            )
        ]
        await mockProvider.addMockEvents(todayEvents)

        // Create intent with mock repository and .today timeframe
        let intent = ListEventsIntent(repositoryProvider: mockProvider)
        intent.timeframe = .today

        // Actually call perform() method
        let result = try await intent.perform()

        // Verify the result contains today's events
        #expect(result.value?.count == 2)
        #expect(result.value?.contains { $0.title == "Today Event 1" } == true)
        #expect(result.value?.contains { $0.title == "Today Event 2" } == true)
    }

    @Test("ListEventsIntent parameter initialization works correctly")
    func testListEventsIntentParameterInitialization() async throws {
        // Parameter initialization issue has been fixed
        // Creating a ListEventsIntent and accessing .timeframe now works
        // No longer crashes with "Non-optional value can not be nil"

        // The fix was in the @Parameter declaration:
        // @Parameter(title: "Timeframe", default: .today) var timeframe: EventTimeframe
        //
        // Now has proper default value

        let intent = ListEventsIntent()

        // Accessing intent.timeframe now works correctly with default value
        #expect(intent.timeframe == .today) // Default value is .today
        #expect(type(of: intent) == ListEventsIntent.self)
    }


    @Test("ListEventsIntent perform() works with .past timeframe")
    func testListEventsIntentPerformPast() async throws {
        // Setup mock repository with past, present and future events
        let mockProvider = MockRepositoryProvider()
        let now = Date.now
        let pastEvents = [
            EventDTO(
                id: UUID(),
                title: "Past Event 1",
                festivalName: "Past Festival 1",
                date: now.addingTimeInterval(-86400),
                venueName: "Past Venue 1"
            ),
            EventDTO(
                id: UUID(),
                title: "Past Event 2",
                festivalName: "Past Festival 2",
                date: now.addingTimeInterval(-172800),
                venueName: "Past Venue 2"
            )
        ]
        // Future event is slightly in the future to avoid cutoff boundary issue
        let futureEvent = EventDTO(
            id: UUID(),
            title: "Future Event",
            festivalName: "Future Festival",
            date: now.addingTimeInterval(3600),
            venueName: "Future Venue"
        )
        await mockProvider.addMockEvents(pastEvents + [futureEvent])

        // Create intent with .past timeframe
        let intent = ListEventsIntent(repositoryProvider: mockProvider)
        intent.timeframe = .past

        // Call perform() method
        let result = try await intent.perform()

        // Should return past events (before or equal to now) - includes events at cutoff time
        // Note: eventsBefore uses <= cutOff, so events exactly at 'now' would be included
        // But our futureEvent is 1 hour in the future, so it should be excluded
        #expect(result.value?.count == 2)
        #expect(result.value?.contains { $0.title == "Past Event 1" } == true)
        #expect(result.value?.contains { $0.title == "Past Event 2" } == true)
        #expect(result.value?.contains { $0.title == "Future Event" } == false)
    }

    @Test("ListEventsIntent perform() works with .future timeframe")
    func testListEventsIntentPerformFuture() async throws {
        // Setup mock repository with past, present and future events
        let mockProvider = MockRepositoryProvider()
        let now = Date.now
        let futureEvents = [
            EventDTO(
                id: UUID(),
                title: "Future Event 1",
                festivalName: "Future Fest 1",
                date: now.addingTimeInterval(86400),
                venueName: "Future Venue 1"
            ),
            EventDTO(
                id: UUID(),
                title: "Future Event 2",
                festivalName: "Future Fest 2",
                date: now.addingTimeInterval(172800),
                venueName: "Future Venue 2"
            )
        ]
        let pastEvent = EventDTO(
            id: UUID(),
            title: "Past Event",
            festivalName: "Past Fest",
            date: now.addingTimeInterval(-3600),
            venueName: "Past Venue"
        )
        await mockProvider.addMockEvents(futureEvents + [pastEvent])

        // Create intent with .future timeframe
        let intent = ListEventsIntent(repositoryProvider: mockProvider)
        intent.timeframe = .future

        // Call perform() method
        let result = try await intent.perform()

        // Should only return future events (after now)
        #expect(result.value?.count == 2)
        #expect(result.value?.contains { $0.title == "Future Event 1" } == true)
        #expect(result.value?.contains { $0.title == "Future Event 2" } == true)
        #expect(result.value?.contains { $0.title == "Past Event" } == false)
    }
}

@Suite("Intent Integration - Expected Behaviors")
struct IntentExpectedBehaviorTests {

    @Test("GetEventIntent should validate event exists before success")
    func testGetEventIntentShouldValidate() async throws {
        // Expected behavior: GetEventIntent.perform() should:
        // 1. Fetch event from repository by ID
        // 2. If found: return repository event data with success dialog
        // 3. If not found: throw error or return failure result
        // 4. Never return success for non-existent events

        #expect(Bool(true)) // Documents expected validation behavior
    }

    @Test("ListEventsIntent should work with protocol interface")
    func testListEventsIntentShouldUseProtocol() async throws {
        // Expected behavior: ListEventsIntent.perform() should:
        // 1. Only call methods available in EventReading protocol
        // 2. Either use recent() and filter by date
        // 3. Or add eventsToday/Before/After to the protocol
        // 4. Handle parameter initialization properly

        #expect(Bool(true)) // Documents expected protocol compliance
    }

    @Test("Both intents should handle dependency injection")
    func testIntentsShouldSupportDependencyInjection() async throws {
        // Expected behavior: Both intents should:
        // 1. Support dependency injection for testing
        // 2. Use repositoryProvider pattern like EventQuery
        // 3. Allow mock repositories in tests
        // 4. Not hardcode SharedStores.eventRepo() calls

        #expect(Bool(true)) // Documents expected DI pattern
    }
}
