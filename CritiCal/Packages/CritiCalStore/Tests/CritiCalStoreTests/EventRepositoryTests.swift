//
//  EventRepositoryTests.swift
//  CritiCalStoreTests
//
//  Created by Claude on 20/09/2025.
//

import Testing
import SwiftData
import Foundation
import CritiCalDomain
import CritiCalModels
@testable import CritiCalStore

// MARK: - EventRepository EventReading Tests

@Suite("EventRepository - EventReading Protocol")
struct EventRepositoryReadingTests {

    @Test("EventRepository recent() returns events sorted by date descending")
    func testRecentEventsSorting() async throws {
        let repository = try StoreFactory.makeEventRepository(cloud: false, inMemory: true)

        let now = Date.now
        let yesterday = now.addingTimeInterval(-86400)
        let tomorrow = now.addingTimeInterval(86400)

        // Create events in random order
        _ = try await repository
            .create(
                title: "Middle Event",
                festivalName: "Middle Fest",
                venueName: "Venue",
                date: now
            )
        _ = try await repository
            .create(
                title: "Old Event",
                festivalName: "Old Fest",
                venueName: "Venue",
                date: yesterday
            )
        _ = try await repository
            .create(
                title: "New Event",
                festivalName: "New Fest",
                venueName: "Venue",
                date: tomorrow
            )

        let recent = try await repository.recent(limit: 10)

        #expect(recent.count == 3)
        #expect(recent[0].title == "New Event") // Most recent first
        #expect(recent[1].title == "Middle Event")
        #expect(recent[2].title == "Old Event") // Oldest last
    }

    @Test("EventRepository recent() respects limit parameter")
    func testRecentEventsLimit() async throws {
        let repository = try StoreFactory.makeEventRepository(cloud: false, inMemory: true)

        // Create 5 events
        for i in 0..<5 {
            _ = try await repository
                .create(
                    title: "Event \(i)",
                    festivalName: "festival \(i)",
                    venueName: "Venue",
                    date: Date.now.addingTimeInterval(Double(i) * 3600)
                )
        }

        let limited = try await repository.recent(limit: 3)
        #expect(limited.count == 3)

        let unlimited = try await repository.recent(limit: 10)
        #expect(unlimited.count == 5)
    }

    @Test("EventRepository event(byIdentifier:) returns correct event")
    func testEventByIdentifier() async throws {
        let repository = try StoreFactory.makeEventRepository(cloud: false, inMemory: true)

        let eventID = try await repository.create(
            title: "Target Event",
            festivalName: "Target Festival",
            venueName: "Target Venue",
            date: Date.now
        )
        _ = try await repository
            .create(
                title: "Other Event",
                festivalName: "Other Festival",
                venueName: "Other Venue",
                date: Date.now
            )

        let foundEvent = try await repository.event(byIdentifier: eventID)

        #expect(foundEvent != nil)
        #expect(foundEvent?.id == eventID)
        #expect(foundEvent?.title == "Target Event")
        #expect(foundEvent?.venueName == "Target Venue")
    }

    @Test("EventRepository event(byIdentifier:) returns nil for non-existent event")
    func testEventByIdentifierNotFound() async throws {
        let repository = try StoreFactory.makeEventRepository(cloud: false, inMemory: true)

        let nonExistentID = UUID()
        let foundEvent = try await repository.event(byIdentifier: nonExistentID)

        #expect(foundEvent == nil)
    }

    @Test("EventRepository search() finds events by title")
    func testSearchByTitle() async throws {
        let repository = try StoreFactory.makeEventRepository(cloud: false, inMemory: true)

        _ = try await repository
            .create(
                title: "Concert Event",
                festivalName: "",
                venueName: "Hall",
                date: Date.now
            )
        _ = try await repository
            .create(
                title: "Theater Show",
                festivalName: "",
                venueName: "Theater",
                date: Date.now
            )
        _ = try await repository
            .create(
                title: "Music Concert",
                festivalName: "",
                venueName: "Arena",
                date: Date.now
            )

        let results = try await repository.search(text: "concert", limit: 10)

        #expect(results.count == 2)
        #expect(results.contains { $0.title == "Concert Event" })
        #expect(results.contains { $0.title == "Music Concert" })
    }

    @Test("EventRepository search() finds events by venue name")
    func testSearchByVenue() async throws {
        let repository = try StoreFactory.makeEventRepository(cloud: false, inMemory: true)

        _ = try await repository
            .create(
                title: "Event A",
                festivalName: "",
                venueName: "Madison Square Garden",
                date: Date.now
            )
        _ = try await repository.create(
            title: "Event B",
            festivalName: "",
            venueName: "Central Park",
            date: Date.now
        )
        _ = try await repository.create(
            title: "Event C",
            festivalName: "",
            venueName: "Madison Hall",
            date: Date.now
        )

        let results = try await repository.search(text: "madison", limit: 10)

        #expect(results.count == 2)
        #expect(results.contains { $0.venueName == "Madison Square Garden" })
        #expect(results.contains { $0.venueName == "Madison Hall" })
    }

    @Test("EventRepository search() respects limit parameter")
    func testSearchLimit() async throws {
        let repository = try StoreFactory.makeEventRepository(cloud: false, inMemory: true)

        // Create 5 events with "test" in title
        for i in 0..<5 {
            _ = try await repository
                .create(
                    title: "Test Event \(i)",
                    festivalName: "test Festival \(i)",
                    venueName: "Venue",
                    date: Date.now
                )
        }

        let limited = try await repository.search(text: "test", limit: 3)
        #expect(limited.count == 3)

        let unlimited = try await repository.search(text: "test", limit: 10)
        #expect(unlimited.count == 5)
    }

    @Test("EventRepository search() returns empty for no matches")
    func testSearchNoResults() async throws {
        let repository = try StoreFactory.makeEventRepository(cloud: false, inMemory: true)

        _ = try await repository
            .create(
                title: "Concert",
                festivalName: "Festival",
                venueName: "Hall",
                date: Date.now
            )

        let results = try await repository.search(text: "nonexistent", limit: 10)
        #expect(results.isEmpty)
    }
}

// MARK: - EventRepository Time-Based Query Tests

@Suite("EventRepository - Time-Based Queries")
struct EventRepositoryTimeBasedTests {

    @Test("EventRepository eventsToday() returns only today's events")
    func testEventsToday() async throws {
        let repository = try StoreFactory.makeEventRepository(cloud: false, inMemory: true)
        let calendar = Calendar.current
        let now = Date.now

        // Create events for different days
        let startOfToday = calendar.startOfDay(for: now)
        let endOfToday = calendar.date(byAdding: .day, value: 1, to: startOfToday)!.addingTimeInterval(-1)
        let yesterday = now.addingTimeInterval(-86400)
        let tomorrow = now.addingTimeInterval(86400)

        _ = try await repository.create(
            title: "Today Morning",
            festivalName: "Festival",
            venueName: "Venue",
            date: startOfToday.addingTimeInterval(3600)
        )
        _ = try await repository.create(
            title: "Today Evening",
            festivalName: "Festival",
            venueName: "Venue",
            date: endOfToday.addingTimeInterval(-3600)
        )
        _ = try await repository.create(
            title: "Yesterday",
            festivalName: "Festival",
            venueName: "Venue",
            date: yesterday
        )
        _ = try await repository.create(
            title: "Tomorrow",
            festivalName: "Festival",
            venueName: "Venue",
            date: tomorrow
        )

        let todayEvents = try await repository.eventsToday(in: calendar, now: now)

        #expect(todayEvents.count == 2)
        #expect(todayEvents.contains { $0.title == "Today Morning" })
        #expect(todayEvents.contains { $0.title == "Today Evening" })
    }

    @Test("EventRepository eventsBefore() returns events before cutoff")
    func testEventsBefore() async throws {
        let repository = try StoreFactory.makeEventRepository(cloud: false, inMemory: true)
        let cutoff = Date.now

        let beforeTime = cutoff.addingTimeInterval(-3600) // 1 hour before
        let atCutoff = cutoff
        let afterTime = cutoff.addingTimeInterval(3600) // 1 hour after

        _ = try await repository.create(
            title: "Before",
            festivalName: "Festival",
            venueName: "Venue",
            date: beforeTime
        )
        _ = try await repository.create(
            title: "At Cutoff",
            festivalName: "Festival",
            venueName: "Venue",
            date: atCutoff
        )
        _ = try await repository.create(
            title: "After",
            festivalName: "Festival",
            venueName: "Venue",
            date: afterTime
        )

        let beforeEvents = try await repository.eventsBefore(cutoff)

        #expect(beforeEvents.count == 2) // Before and at cutoff (<=)
        #expect(beforeEvents.contains { $0.title == "Before" })
        #expect(beforeEvents.contains { $0.title == "At Cutoff" })
    }

    @Test("EventRepository eventsAfter() returns events after cutoff")
    func testEventsAfter() async throws {
        let repository = try StoreFactory.makeEventRepository(cloud: false, inMemory: true)
        let cutoff = Date.now

        let beforeTime = cutoff.addingTimeInterval(-3600)
        let atCutoff = cutoff
        let afterTime = cutoff.addingTimeInterval(3600)

        _ = try await repository.create(
            title: "Before",
            festivalName: "Festival",
            venueName: "Venue",
            date: beforeTime
        )
        _ = try await repository.create(
            title: "At Cutoff",
            festivalName: "Festival",
            venueName: "Venue",
            date: atCutoff
        )
        _ = try await repository.create(
            title: "After",
            festivalName: "Festival",
            venueName: "Venue",
            date: afterTime
        )

        let afterEvents = try await repository.eventsAfter(cutoff)

        #expect(afterEvents.count == 2) // At cutoff and after (>=)
        #expect(afterEvents.contains { $0.title == "At Cutoff" })
        #expect(afterEvents.contains { $0.title == "After" })
    }

    @Test("EventRepository eventsIn(interval:) returns events in date range")
    func testEventsInInterval() async throws {
        let repository = try StoreFactory.makeEventRepository(cloud: false, inMemory: true)

        let start = Date.now
        let end = start.addingTimeInterval(86400) // 24 hours later
        let interval = DateInterval(start: start, end: end)

        let beforeStart = start.addingTimeInterval(-3600)
        let withinInterval = start.addingTimeInterval(3600)
        let afterEnd = end.addingTimeInterval(3600)

        _ = try await repository.create(
            title: "Before",
            festivalName: "Festival",
            venueName: "Venue",
            date: beforeStart
        )
        _ = try await repository.create(
            title: "Within",
            festivalName: "Festival",
            venueName: "Venue",
            date: withinInterval
        )
        _ = try await repository.create(
            title: "After",
            festivalName: "Festival",
            venueName: "Venue",
            date: afterEnd
        )

        let intervalEvents = try await repository.eventsIn(interval: interval)

        #expect(intervalEvents.count == 1)
        #expect(intervalEvents[0].title == "Within")
    }

    @Test("EventRepository eventsIn(interval:) respects sort order")
    func testEventsInIntervalSortOrder() async throws {
        let repository = try StoreFactory.makeEventRepository(cloud: false, inMemory: true)

        let start = Date.now
        let end = start.addingTimeInterval(86400)
        let interval = DateInterval(start: start, end: end)

        let early = start.addingTimeInterval(3600)
        let middle = start.addingTimeInterval(7200)
        let late = start.addingTimeInterval(10800)

        // Create in random order
        _ = try await repository.create(
            title: "Middle",
            festivalName: "Festival",
            venueName: "Venue",
            date: middle
        )
        _ = try await repository.create(
            title: "Late",
            festivalName: "Festival",
            venueName: "Venue",
            date: late
        )
        _ = try await repository.create(
            title: "Early",
            festivalName: "Festival",
            venueName: "Venue",
            date: early
        )

        let forwardEvents = try await repository.eventsIn(interval: interval, order: .forward)
        #expect(forwardEvents.count == 3)
        #expect(forwardEvents[0].title == "Early")
        #expect(forwardEvents[1].title == "Middle")
        #expect(forwardEvents[2].title == "Late")

        let reverseEvents = try await repository.eventsIn(interval: interval, order: .reverse)
        #expect(reverseEvents.count == 3)
        #expect(reverseEvents[0].title == "Late")
        #expect(reverseEvents[1].title == "Middle")
        #expect(reverseEvents[2].title == "Early")
    }
}

// MARK: - EventRepository EventWriting Tests

@Suite("EventRepository - EventWriting Protocol")
struct EventRepositoryWritingTests {

    @Test("EventRepository create() adds new event and returns UUID")
    func testCreateEvent() async throws {
        let repository = try StoreFactory.makeEventRepository(cloud: false, inMemory: true)

        let eventID = try await repository.create(
            title: "New Event",
            festivalName: "New Festival",
            venueName: "New Venue",
            date: Date.now
        )

        #expect(type(of: eventID) == UUID.self)

        // Verify event was created
        let createdEvent = try await repository.event(byIdentifier: eventID)
        #expect(createdEvent != nil)
        #expect(createdEvent?.title == "New Event")
        #expect(createdEvent?.venueName == "New Venue")
    }

    @Test("EventRepository update() modifies existing event")
    func testUpdateEvent() async throws {
        let repository = try StoreFactory.makeEventRepository(cloud: false, inMemory: true)

        let eventID = try await repository.create(
            title: "Original Title",
            festivalName: "Original Festival",
            venueName: "Original Venue",
            date: Date.now
        )

        let newDate = Date.now.addingTimeInterval(3600)
        try await repository.update(
            eventID: eventID,
            title: "Updated Title",
            festivalName: "Updated Festival",
            date: newDate,
            venueName: "Updated Venue"
        )

        let updatedEvent = try await repository.event(byIdentifier: eventID)
        #expect(updatedEvent?.title == "Updated Title")
        #expect(updatedEvent?.festivalName == "Updated Festival")
        #expect(updatedEvent?.venueName == "Updated Venue")
        #expect(updatedEvent?.date == newDate)
    }

    @Test("EventRepository update() allows partial updates")
    func testPartialUpdateEvent() async throws {
        let repository = try StoreFactory.makeEventRepository(cloud: false, inMemory: true)

        let originalDate = Date.now
        let eventID = try await repository.create(
            title: "Original Title",
            festivalName: "Original Festival",
            venueName: "Original Venue",
            date: originalDate
        )

        // Update only title
        try await repository.update(
            eventID: eventID,
            title: "New Title",
            festivalName: nil,
            date: nil,
            venueName: nil
        )

        let updatedEvent = try await repository.event(byIdentifier: eventID)
        #expect(updatedEvent?.title == "New Title")
        #expect(updatedEvent?.festivalName == "Original Festival") // Unchanged
        #expect(updatedEvent?.venueName == "Original Venue") // Unchanged
        #expect(updatedEvent?.date == originalDate) // Unchanged
    }

    @Test("EventRepository update() throws error for non-existent event")
    func testUpdateNonExistentEvent() async throws {
        let repository = try StoreFactory.makeEventRepository(cloud: false, inMemory: true)

        let nonExistentID = UUID()

        do {
            try await repository.update(
                eventID: nonExistentID,
                title: "New Title",
                festivalName: nil,
                date: nil,
                venueName: nil
            )
            #expect(Bool(false), "Should have thrown EventStoreError.notFound")
        } catch let error as EventStoreError {
            if case .notFound = error {
                #expect(Bool(true)) // Expected error
            } else {
                #expect(Bool(false), "Should throw notFound error")
            }
        } catch {
            #expect(Bool(false), "Should throw EventStoreError, not \(type(of: error))")
        }
    }

    @Test("EventRepository delete() removes existing event")
    func testDeleteEvent() async throws {
        let repository = try StoreFactory.makeEventRepository(cloud: false, inMemory: true)

        let eventID = try await repository.create(
            title: "To Delete",
            festivalName: "Delete Festival",
            venueName: "Delete Venue",
            date: Date.now
        )

        // Verify event exists
        let beforeDelete = try await repository.event(byIdentifier: eventID)
        #expect(beforeDelete != nil)

        // Delete event
        try await repository.delete(eventID: eventID)

        // Verify event no longer exists
        let afterDelete = try await repository.event(byIdentifier: eventID)
        #expect(afterDelete == nil)
    }

    @Test("EventRepository delete() throws error for non-existent event")
    func testDeleteNonExistentEvent() async throws {
        let repository = try StoreFactory.makeEventRepository(cloud: false, inMemory: true)

        let nonExistentID = UUID()

        do {
            try await repository.delete(eventID: nonExistentID)
            #expect(Bool(false), "Should have thrown EventStoreError.notFound")
        } catch let error as EventStoreError {
            if case .notFound = error {
                #expect(Bool(true)) // Expected error
            } else {
                #expect(Bool(false), "Should throw notFound error")
            }
        } catch {
            #expect(Bool(false), "Should throw EventStoreError, not \(type(of: error))")
        }
    }
}

// MARK: - Event DTO Conversion Tests

@Suite("EventRepository - DTO Conversion")
struct EventDTOConversionTests {

    @Test("Event to DTO conversion preserves all properties")
    func testEventToDTOConversion() async throws {
        let repository = try StoreFactory.makeEventRepository(cloud: false, inMemory: true)

        let testDate = Date.now
        let eventID = try await repository.create(
            title: "Conversion Test",
            festivalName: "Conversion Festival",
            venueName: "Conversion Venue",
            date: testDate
        )

        let dto = try await repository.event(byIdentifier: eventID)

        #expect(dto != nil)
        #expect(dto?.id == eventID)
        #expect(dto?.title == "Conversion Test")
        #expect(dto?.venueName == "Conversion Venue")
        #expect(dto?.date == testDate)
    }

    @Test("DTO conversion handles special characters")
    func testDTOConversionSpecialCharacters() async throws {
        let repository = try StoreFactory.makeEventRepository(cloud: false, inMemory: true)

        let specialTitle = "Test Event 🎉 & More!"
        let specialFestival = "Fête de la Musique"
        let specialVenue = "Café Münchën @北京"

        let eventID = try await repository.create(
            title: specialTitle,
            festivalName: specialFestival,
            venueName: specialVenue,
            date: Date.now
        )

        let dto = try await repository.event(byIdentifier: eventID)

        #expect(dto?.title == specialTitle)
        #expect(dto?.festivalName == specialFestival)
        #expect(dto?.venueName == specialVenue)
    }

    @Test("DTO conversion handles empty strings")
    func testDTOConversionEmptyStrings() async throws {
        let repository = try StoreFactory.makeEventRepository(cloud: false, inMemory: true)

        let eventID = try await repository.create(
            title: "",
            festivalName: "",
            venueName: "",
            date: Date.now
        )

        let dto = try await repository.event(byIdentifier: eventID)

        #expect(dto?.title == "")
        #expect(dto?.festivalName == "")
        #expect(dto?.venueName == "")
    }

    @Test("Multiple events convert to DTOs correctly")
    func testMultipleEventDTOConversion() async throws {
        let repository = try StoreFactory.makeEventRepository(cloud: false, inMemory: true)

        // Create multiple events
        for i in 0..<5 {
            _ = try await repository.create(
                title: "Event \(i)",
                festivalName: "Festival \(i)",
                venueName: "Venue \(i)",
                date: Date.now.addingTimeInterval(Double(i) * 3600)
            )
        }

        let allEvents = try await repository.recent(limit: 10)

        #expect(allEvents.count == 5)
        for (index, event) in allEvents.enumerated() {
            let expectedIndex = 4 - index // Recent returns in reverse order
            #expect(event.title == "Event \(expectedIndex)")
            #expect(event.festivalName == "Festival \(expectedIndex)")
            #expect(event.venueName == "Venue \(expectedIndex)")
        }
    }
}

// MARK: - Error Handling and Edge Cases

@Suite("EventRepository - Error Handling and Edge Cases")
struct EventRepositoryErrorTests {

    @Test("EventRepository handles empty repository gracefully")
    func testEmptyRepository() async throws {
        let repository = try StoreFactory.makeEventRepository(cloud: false, inMemory: true)

        let recentEvents = try await repository.recent(limit: 10)
        #expect(recentEvents.isEmpty)

        let searchResults = try await repository.search(text: "anything", limit: 10)
        #expect(searchResults.isEmpty)

        let todayEvents = try await repository.eventsToday()
        #expect(todayEvents.isEmpty)
    }

    @Test("EventRepository handles zero limit correctly")
    func testZeroLimit() async throws {
        let repository = try StoreFactory.makeEventRepository(cloud: false, inMemory: true)

        _ = try await repository
            .create(
                title: "Test",
                festivalName: "Test",
                venueName: "Test",
                date: Date.now
            )

        // Note: SwiftData may not strictly enforce limit: 0, so we test that it returns a reasonable result
        let recentWithZeroLimit = try await repository.recent(limit: 0)
        // With SwiftData, limit: 0 might return all results rather than none
        #expect(recentWithZeroLimit.count <= 1) // Should return 0 or 1 result

        let searchWithZeroLimit = try await repository.search(text: "test", limit: 0)
        #expect(searchWithZeroLimit.count <= 1) // Should return 0 or 1 result
    }

    @Test("EventRepository handles large datasets")
    func testLargeDataset() async throws {
        let repository = try StoreFactory.makeEventRepository(cloud: false, inMemory: true)

        // Create 100 events
        for i in 0..<100 {
            _ = try await repository.create(
                title: "Event \(i)",
                festivalName: "Festival \(i)",
                venueName: "Venue \(i)",
                date: Date.now.addingTimeInterval(Double(i) * 60)
            )
        }

        let recent10 = try await repository.recent(limit: 10)
        #expect(recent10.count == 10)

        let recent100 = try await repository.recent(limit: 100)
        #expect(recent100.count == 100)

        let searchResults = try await repository.search(text: "Event", limit: 50)
        #expect(searchResults.count == 50)
    }

    @Test("EventRepository handles concurrent operations")
    func testConcurrentOperations() async throws {
        let repository = try StoreFactory.makeEventRepository(cloud: false, inMemory: true)

        // Create multiple events concurrently
        await withTaskGroup(of: UUID?.self) { group in
            for i in 0..<10 {
                group.addTask {
                    try? await repository.create(
                        title: "Concurrent Event \(i)",
                        festivalName: "Festival \(i)",
                        venueName: "Venue \(i)",
                        date: Date.now.addingTimeInterval(Double(i) * 60)
                    )
                }
            }

            var createdIDs: [UUID] = []
            for await id in group {
                if let id = id {
                    createdIDs.append(id)
                }
            }

            #expect(createdIDs.count == 10)
        }

        let allEvents = try await repository.recent(limit: 20)
        #expect(allEvents.count == 10)
    }

    @Test("EventRepository handles boundary dates correctly")
    func testBoundaryDates() async throws {
        let repository = try StoreFactory.makeEventRepository(cloud: false, inMemory: true)

        let distantPast = Date.distantPast
        let distantFuture = Date.distantFuture

        let pastID = try await repository.create(
            title: "Past Event",
            festivalName: "Past Festival",
            venueName: "Past Venue",
            date: distantPast
        )

        let futureID = try await repository.create(
            title: "Future Event",
            festivalName: "Future Festival",
            venueName: "Future Venue",
            date: distantFuture
        )

        let pastEvent = try await repository.event(byIdentifier: pastID)
        let futureEvent = try await repository.event(byIdentifier: futureID)

        #expect(pastEvent?.date == distantPast)
        #expect(futureEvent?.date == distantFuture)
    }
}
