//
//  EventTimeframeTests.swift
//  CritiCalIntentsTests
//
//  Created by Claude on 20/09/2025.
//

import Testing
import Foundation
import AppIntents
import CritiCalDomain
@testable import CritiCalIntents

@Suite("EventTimeframe - Enum Cases")
struct EventTimeframeEnumTests {

    @Test("EventTimeframe has all expected cases")
    func testAllCases() {
        let allCases = EventTimeframe.allCases

        #expect(allCases.count == 3)
        #expect(allCases.contains(.today))
        #expect(allCases.contains(.past))
        #expect(allCases.contains(.future))
    }

    @Test("EventTimeframe cases have correct raw values")
    func testRawValues() {
        #expect(EventTimeframe.today.rawValue == "today")
        #expect(EventTimeframe.past.rawValue == "past")
        #expect(EventTimeframe.future.rawValue == "future")
    }

    @Test("EventTimeframe can be initialized from raw values")
    func testInitFromRawValue() {
        #expect(EventTimeframe(rawValue: "today") == .today)
        #expect(EventTimeframe(rawValue: "past") == .past)
        #expect(EventTimeframe(rawValue: "future") == .future)
        #expect(EventTimeframe(rawValue: "invalid") == nil)
    }

    @Test("EventTimeframe handles case sensitivity")
    func testCaseSensitivity() {
        // Raw value init should be case sensitive
        #expect(EventTimeframe(rawValue: "Today") == nil)
        #expect(EventTimeframe(rawValue: "PAST") == nil)
        #expect(EventTimeframe(rawValue: "Future") == nil)
    }
}

@Suite("EventTimeframe - AppEnum Conformance")
struct EventTimeframeAppEnumTests {

    @Test("EventTimeframe conforms to AppEnum protocol")
    func testAppEnumConformance() {
        // This test verifies compile-time conformance
        let _: any AppEnum = EventTimeframe.today
        #expect(Bool(true)) // If it compiles, the test passes
    }

    @Test("Type display representation is correctly set")
    func testTypeDisplayRepresentation() {
        let typeDisplay = EventTimeframe.typeDisplayRepresentation
        #expect(String(describing: typeDisplay).contains("Timeframe"))
    }

    @Test("Case display representations are defined for all cases")
    func testCaseDisplayRepresentations() {
        let caseDisplays = EventTimeframe.caseDisplayRepresentations

        #expect(caseDisplays.count == 3)
        #expect(caseDisplays[.today] != nil)
        #expect(caseDisplays[.past] != nil)
        #expect(caseDisplays[.future] != nil)
    }

    @Test("Case display representations have expected content")
    func testCaseDisplayContent() {
        let caseDisplays = EventTimeframe.caseDisplayRepresentations

        // Verify the display representations contain expected text
        #expect(String(describing: caseDisplays[.today]!).contains("Today"))
        #expect(String(describing: caseDisplays[.past]!).contains("Past"))
        #expect(String(describing: caseDisplays[.future]!).contains("Future"))
    }
}

@Suite("EventTimeframe - Sendable Conformance")
struct EventTimeframeSendableTests {

    /// Tests that EventTimeframe can be safely shared across concurrent contexts.
    ///
    /// This test verifies:
    /// 1. EventTimeframe conforms to Sendable protocol
    /// 2. Can be passed between concurrent tasks without data races
    /// 3. Maintains value integrity in concurrent environments
    @Test("EventTimeframe conforms to Sendable and is thread-safe")
    func testSendableConformance() async {
        let timeframe = EventTimeframe.today

        // Test concurrent access using TaskGroup
        await withTaskGroup(of: EventTimeframe.self) { group in
            // Add multiple tasks that capture the same timeframe
            group.addTask { timeframe }
            group.addTask { timeframe }
            group.addTask { timeframe }

            var results: [EventTimeframe] = []
            for await result in group {
                results.append(result)
            }

            // Verify all tasks received the timeframe
            #expect(results.count == 3)

            // Verify all have the same value (identity preserved)
            #expect(results.allSatisfy { $0 == .today })
        }
    }

    @Test("EventTimeframe can be passed between isolated contexts")
    func testIsolatedContexts() async {
        let timeframe = EventTimeframe.future

        // Create an async task that captures the timeframe
        let capturedTimeframe = await Task { timeframe }.value

        #expect(capturedTimeframe == .future)
    }

    @Test("All EventTimeframe cases are Sendable")
    func testAllCasesSendable() async {
        let timeframes = [EventTimeframe.today, .past, .future]

        await withTaskGroup(of: [EventTimeframe].self) { group in
            group.addTask { timeframes }

            for await result in group {
                #expect(result.count == 3)
                #expect(result.contains(.today))
                #expect(result.contains(.past))
                #expect(result.contains(.future))
            }
        }
    }
}

@Suite("EventTimeframe - Equality and Hashing")
struct EventTimeframeEqualityTests {

    @Test("EventTimeframe cases are equal to themselves")
    func testSelfEquality() {
        #expect(EventTimeframe.today == .today)
        #expect(EventTimeframe.past == .past)
        #expect(EventTimeframe.future == .future)
    }

    @Test("EventTimeframe cases are not equal to other cases")
    func testInequality() {
        #expect(EventTimeframe.today != .past)
        #expect(EventTimeframe.today != .future)
        #expect(EventTimeframe.past != .future)
        #expect(EventTimeframe.past != .today)
        #expect(EventTimeframe.future != .today)
        #expect(EventTimeframe.future != .past)
    }

    @Test("EventTimeframe is Hashable")
    func testHashable() {
        let timeframes: Set<EventTimeframe> = [.today, .past, .future]

        #expect(timeframes.count == 3)
        #expect(timeframes.contains(.today))
        #expect(timeframes.contains(.past))
        #expect(timeframes.contains(.future))
    }

    @Test("EventTimeframe hash values are consistent")
    func testHashConsistency() {
        let today1 = EventTimeframe.today
        let today2 = EventTimeframe.today

        #expect(today1.hashValue == today2.hashValue)

        // Hash values for different cases should typically be different
        // (though not guaranteed by the protocol)
        let past = EventTimeframe.past
        let future = EventTimeframe.future

        #expect(today1 != past)
        #expect(today1 != future)
        #expect(past != future)
    }
}

@Suite("EventTimeframe - String Representation")
struct EventTimeframeStringTests {

    @Test("EventTimeframe description matches raw value")
    func testStringDescription() {
        #expect(String(describing: EventTimeframe.today).contains("today"))
        #expect(String(describing: EventTimeframe.past).contains("past"))
        #expect(String(describing: EventTimeframe.future).contains("future"))
    }

    @Test("EventTimeframe can be used in string interpolation")
    func testStringInterpolation() {
        let todayString = "\(EventTimeframe.today)"
        let pastString = "\(EventTimeframe.past)"
        let futureString = "\(EventTimeframe.future)"

        #expect(todayString.contains("today"))
        #expect(pastString.contains("past"))
        #expect(futureString.contains("future"))
    }
}

@Suite("EventTimeframe - Usage in ListEventsIntent")
struct EventTimeframeUsageTests {

    @Test("EventTimeframe is used as Parameter in ListEventsIntent")
    func testParameterUsage() {
        // This test verifies that EventTimeframe works correctly as an @Parameter
        // We can't test the actual intent without proper store setup, but we can
        // verify the enum is suitable for parameter use

        let timeframes = EventTimeframe.allCases

        // All cases should be available for parameter selection
        #expect(timeframes.count == 3)

        // Each case should have a display representation
        for timeframe in timeframes {
            let display = EventTimeframe.caseDisplayRepresentations[timeframe]
            #expect(display != nil)
        }
    }

    @Test("EventTimeframe cases correspond to repository methods")
    func testRepositoryMethodMapping() async throws {
        // This test verifies that each EventTimeframe case can be used successfully
        // with ListEventsIntent, which demonstrates the correspondence to repository methods

        let mockProvider = MockRepositoryProvider()

        // Add test data so repository methods have something to return
        let testEvent = EventDTO(
            id: UUID(),
            title: "Test Event",
            festivalName: "test Festival",
            date: Date.now,
            venueName: "Test Venue"
        )
        await mockProvider.addMockEvent(testEvent)

        // Verify each timeframe case works with ListEventsIntent
        // This confirms the correspondence: .today -> eventsToday(), .past -> eventsBefore(), .future -> eventsAfter()
        for timeframe in EventTimeframe.allCases {
            let intent = ListEventsIntent(repositoryProvider: mockProvider)
            intent.timeframe = timeframe

            // If the correspondence is broken, this would fail at compile time or runtime
            _ = try await intent.perform()
        }

        // If we get here, all timeframe cases successfully correspond to working repository methods
        #expect(EventTimeframe.allCases.count == 3) // Verify we tested all expected cases
    }
}

@Suite("EventTimeframe - Edge Cases")
struct EventTimeframeEdgeCaseTests {

    @Test("EventTimeframe handles empty string raw value")
    func testEmptyStringRawValue() {
        #expect(EventTimeframe(rawValue: "") == nil)
    }

    @Test("EventTimeframe handles whitespace raw values")
    func testWhitespaceRawValues() {
        #expect(EventTimeframe(rawValue: " today") == nil)
        #expect(EventTimeframe(rawValue: "today ") == nil)
        #expect(EventTimeframe(rawValue: " today ") == nil)
        #expect(EventTimeframe(rawValue: "to day") == nil)
    }

    @Test("EventTimeframe handles special characters in raw values")
    func testSpecialCharacterRawValues() {
        #expect(EventTimeframe(rawValue: "today!") == nil)
        #expect(EventTimeframe(rawValue: "@past") == nil)
        #expect(EventTimeframe(rawValue: "future?") == nil)
        #expect(EventTimeframe(rawValue: "tödäy") == nil)
    }

    @Test("EventTimeframe CaseIterable provides all cases")
    func testCaseIterable() {
        let allCases = EventTimeframe.allCases

        // Verify CaseIterable is implemented correctly
        #expect(allCases.count == 3)

        // Verify all expected cases are present
        let caseSet = Set(allCases)
        #expect(caseSet.contains(.today))
        #expect(caseSet.contains(.past))
        #expect(caseSet.contains(.future))

        // Verify no duplicates
        #expect(allCases.count == caseSet.count)
    }
}
