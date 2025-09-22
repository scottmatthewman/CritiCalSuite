//
//  EventDTOTests.swift
//  CritiCalDomainTests
//
//  Created by Claude on 20/09/2025.
//

import Testing
import Foundation
@testable import CritiCalDomain

@Suite("EventDTO - Initialization")
struct EventDTOInitializationTests {

    @Test("EventDTO initializes with a default ID")
    func testInitializationWithDefaultID() {
        let date = Date.now
        let dto = EventDTO(
            title: "Test Event",
            festivalName: "Test Festival",
            date: date,
            venueName: "Test Venue"
        )

        #expect(dto.title == "Test Event")
        #expect(dto.festivalName == "Test Festival")
        #expect(dto.date == date)
        #expect(dto.venueName == "Test Venue")
        #expect(dto.id != UUID())
    }

    @Test("EventDTO initializes with a custom ID")
    func testInitializationWithCustomID() {
        let customID = UUID()
        let date = Date.now
        let dto = EventDTO(
            id: customID,
            title: "Custom Event",
            festivalName: "Custom Festival",
            date: date,
            venueName: "Custom Venue"
        )

        #expect(dto.id == customID)
    }
}

@Suite("EventDTO - Equatable")
struct EventDTOEquatableTests {
    @Test("Objects are equal when all atributes including ID match")
    func testEquatable_Equal() {
        let id = UUID()
        let date = Date.now

        let dto1 = EventDTO(
            id: id,
            title: "Event",
            festivalName: "Festival",
            date: date,
            venueName: "Venue",
            confirmationStatus: .cancelled
        )

        let dto2 = EventDTO(
            id: id,
            title: "Event",
            festivalName: "Festival",
            date: date,
            venueName: "Venue",
            confirmationStatus: .cancelled
        )

        #expect(dto1 == dto2)
    }

    @Test("Objects are not equal when attributes are the same but IDs differ")
    func testEquatable_DifferentIDs() {
        let date = Date.now

        let dto1 = EventDTO(
            id: UUID(),
            title: "Event",
            festivalName: "Festival",
            date: date,
            venueName: "Venue"
        )

        let dto2 = EventDTO(
            id: UUID(),
            title: "Event",
            festivalName: "Festival",
            date: date,
            venueName: "Venue"
        )

        #expect(dto1 != dto2)
    }

    @Test("Objects are not the same when a single attribute is different")
    func testEquatable_DifferentTitles() {
        let id = UUID()
        let date = Date.now

        let dto1 = EventDTO(
            id: id,
            title: "Event 1",
            festivalName: "Festival 1",
            date: date,
            venueName: "Venue"
        )

        let dto2 = EventDTO(
            id: id,
            title: "Event 2",
            festivalName: "Festival 1",
            date: date,
            venueName: "Venue"
        )

        #expect(dto1 != dto2)
    }
}

@Suite("EventDTO - Identifiable")
struct EventDTOIdentifiableTests {
    @Test("#id uses the object's UUID")
    func testIdentifiable() {
        let customID = UUID()
        let dto = EventDTO(
            id: customID,
            title: "Event",
            date: Date.now,
            venueName: "Venue"
        )

        #expect(dto.id == customID)
    }
}

@Suite("EventDTO - Sendable")
struct EventDTOSendableTests {
    /// Tests that EventDTO conforms to Sendable protocol for safe concurrent access.
    ///
    /// ## Purpose
    /// This test verifies that EventDTO can be safely shared across concurrent contexts
    /// without data races, which is essential for use in async/await and actor-based code.
    ///
    /// ## What It Tests
    /// 1. **Compile-time safety**: Confirms EventDTO is recognized as Sendable by the compiler
    /// 2. **Value semantics**: Verifies that each concurrent task gets its own copy of the data
    /// 3. **No data races**: Ensures multiple tasks can access the same DTO instance safely
    ///
    /// ## Why This Test Matters
    /// - **Documentation**: Explicitly shows EventDTO is designed for concurrent use
    /// - **Regression prevention**: Ensures future changes don't break Sendable conformance
    /// - **API contract**: Guarantees the type can be used in async/await and actor contexts
    ///
    /// ## Implementation Details
    /// The test creates a single EventDTO instance and shares it across two concurrent tasks
    /// using TaskGroup. Both tasks capture and return the same DTO. Since EventDTO is an
    /// immutable struct, Swift automatically infers Sendable conformance, and each task
    /// receives its own copy due to value semantics.
    @Test("EventDTO conforms to sendable and can be safely shared across concurrent contexts")
    func testSendableConformance() async {
        // Create a single EventDTO instance to share across concurrent tasks
        let dto = EventDTO(
            title: "Concurrent Event",
            festivalName: "Concurrent Festival",
            date: Date.now,
            venueName: "Concurrent Venue"
        )

        // Use TaskGroup to create multiple concurrent tasks
        await withTaskGroup(of: EventDTO.self) { group in
            // Add two tasks that both capture the same dto
            // This wouldn't compile if EventDTO wasn't Sendable
            group.addTask { dto }  // Task 1: captures and returns the dto
            group.addTask { dto }  // Task 2: captures and returns the same dto

            // Collect results from both concurrent tasks
            var results: [EventDTO] = []
            for await result in group {
                results.append(result)
            }

            // Verify both tasks successfully returned their copies
            #expect(results.count == 2)
            // Verify the copies are equal (value semantics preserved)
            #expect(results[0] == results[1])
        }
    }
}

@Suite("EventDTO - EndDate Calculation")
struct EventDTOEndDateTests {

    @Test("endDate returns same date when durationMinutes is nil")
    func testEndDateWithNilDuration() {
        let startDate = Date(timeIntervalSince1970: 1000000) // Fixed date for consistency
        let dto = EventDTO(
            title: "Event Without Duration",
            date: startDate,
            durationMinutes: nil
        )

        #expect(dto.endDate == startDate)
    }

    @Test("endDate calculates correctly with positive duration")
    func testEndDateWithPositiveDuration() {
        let startDate = Date(timeIntervalSince1970: 1000000)
        let durationMinutes = 120 // 2 hours
        let dto = EventDTO(
            title: "Two Hour Event",
            date: startDate,
            durationMinutes: durationMinutes
        )

        let expectedEndDate = Calendar.current.date(byAdding: .minute, value: durationMinutes, to: startDate)!
        #expect(dto.endDate == expectedEndDate)

        // Verify the time difference is correct (120 minutes = 7200 seconds)
        let timeDifference = dto.endDate.timeIntervalSince(startDate)
        #expect(timeDifference == 7200.0)
    }

    @Test("endDate handles various duration values")
    func testEndDateWithVariousDurations() {
        let startDate = Date(timeIntervalSince1970: 1000000)

        // Test 30 minutes
        let dto30 = EventDTO(title: "30 min", date: startDate, durationMinutes: 30)
        #expect(dto30.endDate.timeIntervalSince(startDate) == 1800.0)

        // Test 90 minutes
        let dto90 = EventDTO(title: "90 min", date: startDate, durationMinutes: 90)
        #expect(dto90.endDate.timeIntervalSince(startDate) == 5400.0)

        // Test 1 minute
        let dto1 = EventDTO(title: "1 min", date: startDate, durationMinutes: 1)
        #expect(dto1.endDate.timeIntervalSince(startDate) == 60.0)

        // Test 24 hours (1440 minutes)
        let dto1440 = EventDTO(title: "24 hours", date: startDate, durationMinutes: 1440)
        #expect(dto1440.endDate.timeIntervalSince(startDate) == 86400.0)
    }

    @Test("endDate handles zero duration")
    func testEndDateWithZeroDuration() {
        let startDate = Date(timeIntervalSince1970: 1000000)
        let dto = EventDTO(
            title: "Zero Duration Event",
            date: startDate,
            durationMinutes: 0
        )

        // Zero duration should return the same date
        #expect(dto.endDate == startDate)
        #expect(dto.endDate.timeIntervalSince(startDate) == 0.0)
    }

    @Test("endDate handles negative duration")
    func testEndDateWithNegativeDuration() {
        let startDate = Date(timeIntervalSince1970: 1000000)
        let dto = EventDTO(
            title: "Negative Duration Event",
            date: startDate,
            durationMinutes: -60 // -1 hour
        )

        // Negative duration should calculate backwards from start date
        let expectedEndDate = Calendar.current.date(byAdding: .minute, value: -60, to: startDate)!
        #expect(dto.endDate == expectedEndDate)
        #expect(dto.endDate.timeIntervalSince(startDate) == -3600.0)
    }

    @Test("endDate preserves across daylight saving time transitions")
    func testEndDateAcrossDST() {
        // Use a calendar and timezone that observes DST
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "America/New_York")!

        // Create a date just before DST change (example: March 10, 2024, 1:30 AM)
        let components = DateComponents(year: 2024, month: 3, day: 10, hour: 1, minute: 30)
        guard let startDate = calendar.date(from: components) else {
            #expect(Bool(false), "Failed to create test date")
            return
        }

        // Event spans DST change (90 minutes, crossing 2 AM DST transition)
        let dto = EventDTO(
            title: "DST Crossing Event",
            date: startDate,
            durationMinutes: 90
        )

        // The calculation should handle DST correctly
        let expectedEndDate = calendar.date(byAdding: .minute, value: 90, to: startDate)!
        #expect(dto.endDate == expectedEndDate)
    }

    @Test("endDate calculation is consistent for multiple accesses")
    func testEndDateConsistency() {
        let dto = EventDTO(
            title: "Consistency Test",
            date: Date.now,
            durationMinutes: 60
        )

        // Access endDate multiple times and ensure it returns the same value
        let endDate1 = dto.endDate
        let endDate2 = dto.endDate
        let endDate3 = dto.endDate

        #expect(endDate1 == endDate2)
        #expect(endDate2 == endDate3)
    }
}
