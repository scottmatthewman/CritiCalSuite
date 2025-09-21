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
            venueName: "Venue"
        )

        let dto2 = EventDTO(
            id: id,
            title: "Event",
            festivalName: "Festival",
            date: date,
            venueName: "Venue"
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
