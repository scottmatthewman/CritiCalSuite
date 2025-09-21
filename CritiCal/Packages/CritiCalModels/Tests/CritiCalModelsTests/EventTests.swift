//
//  CritiCalModelsTests.swift
//  CritiCalModelsTests
//
//  Created by Claude on 20/09/2025.
//

import Testing
import Foundation
@testable import CritiCalModels

@Suite("Event Model - Initialization")
struct EventInitializationTests {

    @Test("Event initializes with all parameters provided")
    func testInitializationWithAllParameters() {
        let customID = UUID()
        let customDate = Date.now
        let event = Event(
            identifier: customID,
            title: "Test Event",
            festivalName: "Test Festival",
            venueName: "Test Venue",
            date: customDate,
            durationMinutes: 120
        )

        #expect(event.identifier == customID)
        #expect(event.title == "Test Event")
        #expect(event.festivalName == "Test Festival")
        #expect(event.venueName == "Test Venue")
        #expect(event.date == customDate)
        #expect(event.durationMinutes == 120)
    }

    @Test("Event initializes with default parameters")
    func testInitializationWithDefaults() {
        let event = Event()

        // Should have a valid UUID (not empty)
        #expect(event.identifier != UUID())
        #expect(event.title == "")
        #expect(event.festivalName == "")
        #expect(event.venueName == "")
        // Date should be reasonably close to now (within 1 second)
        #expect(abs(event.date.timeIntervalSince(Date.now)) < 1.0)
        #expect(event.durationMinutes == nil)
    }

    @Test("Event initializes with partial parameters")
    func testInitializationWithPartialParameters() {
        let event = Event(title: "Partial Event", venueName: "Partial Venue", durationMinutes: 90)

        #expect(event.title == "Partial Event")
        #expect(event.venueName == "Partial Venue")
        #expect(event.durationMinutes == 90)
        #expect(event.identifier != UUID()) // Should have generated a UUID
        #expect(abs(event.date.timeIntervalSince(Date.now)) < 1.0) // Should be close to now
    }

    @Test("Event initializes with custom date only")
    func testInitializationWithCustomDate() {
        let futureDate = Date.now.addingTimeInterval(86400) // Tomorrow
        let event = Event(date: futureDate)

        #expect(event.date == futureDate)
        #expect(event.title == "")
        #expect(event.festivalName == "")
        #expect(event.venueName == "")
        #expect(event.durationMinutes == nil)
        #expect(event.identifier != UUID())
    }

    @Test("Event generates unique identifiers by default")
    func testUniqueIdentifierGeneration() {
        let event1 = Event()
        let event2 = Event()

        #expect(event1.identifier != event2.identifier)
        #expect(event1.identifier != UUID())
        #expect(event2.identifier != UUID())
    }

    @Test("Event respects custom identifier parameter")
    func testCustomIdentifierRespected() {
        let customID = UUID()
        let event = Event(identifier: customID)

        #expect(event.identifier == customID)
    }
}

@Suite("Event Model - Property Behavior")
struct EventPropertyTests {

    @Test("Event properties can be modified after initialization")
    func testPropertyModification() {
        let event = Event()

        let newID = UUID()
        let newDate = Date.now.addingTimeInterval(3600)

        event.identifier = newID
        event.title = "Modified Title"
        event.festivalName = "Modified Festival"
        event.venueName = "Modified Venue"
        event.date = newDate

        #expect(event.identifier == newID)
        #expect(event.title == "Modified Title")
        #expect(event.festivalName == "Modified Festival")
        #expect(event.venueName == "Modified Venue")
        #expect(event.date == newDate)
    }

    @Test("Event properties retain their values")
    func testPropertyRetention() {
        let event = Event(title: "Original Title", venueName: "Original Venue")
        let originalID = event.identifier
        let originalDate = event.date

        // Access properties multiple times
        let title1 = event.title
        let title2 = event.title
        let venue1 = event.venueName
        let venue2 = event.venueName

        #expect(title1 == title2)
        #expect(venue1 == venue2)
        #expect(event.identifier == originalID)
        #expect(event.date == originalDate)
    }

    @Test("Event property types are correct")
    func testPropertyTypes() {
        let event = Event()

        #expect(type(of: event.identifier) == UUID.self)
        #expect(type(of: event.title) == String.self)
        #expect(type(of: event.festivalName) == String.self)
        #expect(type(of: event.venueName) == String.self)
        #expect(type(of: event.date) == Date.self)
        #expect(type(of: event.durationMinutes) == Optional<Int>.self)
    }

    @Test("Event can handle empty string properties")
    func testEmptyStringProperties() {
        let event = Event(
            title: "Test",
            festivalName: "Test",
            venueName: "Test"
        )

        event.title = ""
        event.festivalName = ""
        event.venueName = ""

        #expect(event.title == "")
        #expect(event.festivalName == "")
        #expect(event.venueName == "")
        #expect(event.title.isEmpty)
        #expect(event.festivalName.isEmpty)
        #expect(event.venueName.isEmpty)
    }

    @Test("Event properties are independent")
    func testPropertyIndependence() {
        let event = Event()

        let originalVenue = event.venueName
        let originalFestival = event.festivalName
        let originalID = event.identifier
        let originalDate = event.date

        event.title = "Title Change"

        // Changing title shouldn't affect other properties
        #expect(event.venueName == originalVenue)
        #expect(event.festivalName == originalFestival)
        #expect(event.identifier == originalID)
        #expect(event.date == originalDate)
    }
}

@Suite("Event Model - Data Integrity")
struct EventDataIntegrityTests {

    @Test("Event preserves date precision")
    func testDatePrecision() {
        let preciseDate = Date(timeIntervalSince1970: 1695200400.123456) // Precise to microseconds
        let event = Event(date: preciseDate)

        #expect(event.date == preciseDate)
        #expect(event.date.timeIntervalSince1970 == preciseDate.timeIntervalSince1970)
    }

    @Test("Event handles Unicode strings correctly")
    func testUnicodeStringHandling() {
        let unicodeTitle = "Test Event 🎉 Événement"
        let unicodeVenue = "Café & Restaurant 北京"
        let event = Event(title: unicodeTitle, venueName: unicodeVenue)

        #expect(event.title == unicodeTitle)
        #expect(event.venueName == unicodeVenue)
        #expect(event.title.contains("🎉"))
        #expect(event.venueName.contains("北京"))
    }

    @Test("Event maintains string integrity across property access")
    func testStringIntegrityOverTime() {
        let complexString = "Multi\nLine\tWith\r\nSpecial Characters: !@#$%^&*()"
        let event = Event()

        event.title = complexString
        event.venueName = complexString

        // Access multiple times to ensure integrity
        for _ in 0..<10 {
            #expect(event.title == complexString)
            #expect(event.venueName == complexString)
        }
    }

    @Test("Event UUID maintains integrity")
    func testUUIDIntegrity() {
        let customUUID = UUID()
        let event = Event(identifier: customUUID)

        // Access UUID multiple times
        for _ in 0..<10 {
            #expect(event.identifier == customUUID)
            #expect(event.identifier.uuidString == customUUID.uuidString)
        }
    }

    @Test("Event handles date boundary values")
    func testDateBoundaryValues() {
        let distantPast = Date.distantPast
        let distantFuture = Date.distantFuture

        let pastEvent = Event(date: distantPast)
        let futureEvent = Event(date: distantFuture)

        #expect(pastEvent.date == distantPast)
        #expect(futureEvent.date == distantFuture)
    }
}

@Suite("Event Model - Edge Cases")
struct EventEdgeCaseTests {

    @Test("Event handles very long strings")
    func testVeryLongStrings() {
        let longString = String(repeating: "Very Long String Content ", count: 1000)
        let event = Event(title: longString, venueName: longString)

        #expect(event.title == longString)
        #expect(event.venueName == longString)
        #expect(event.title.count > 20000)
        #expect(event.venueName.count > 20000)
    }

    @Test("Event handles special characters and symbols")
    func testSpecialCharacters() {
        let specialTitle = "Event with\n\t\r special chars: <>?{}[]|\\=+`~"
        let specialVenue = "Venue & More @ #1! (100%) $50 €25 £20"
        let event = Event(title: specialTitle, venueName: specialVenue)

        #expect(event.title == specialTitle)
        #expect(event.venueName == specialVenue)
    }

    @Test("Event handles null-like values safely")
    func testNullLikeValues() {
        // Test with explicit empty strings
        let event = Event(title: "", venueName: "")

        #expect(event.title == "")
        #expect(event.venueName == "")
        #expect(event.title.isEmpty)
        #expect(event.venueName.isEmpty)
    }

    @Test("Event handles extreme dates")
    func testExtremeDates() {
        let year1970 = Date(timeIntervalSince1970: 0)
        let year2001 = Date(timeIntervalSince1970: 978307200) // 2001-01-01
        let year2038 = Date(timeIntervalSince1970: 2147483647) // 2038 limit

        let event1970 = Event(date: year1970)
        let event2001 = Event(date: year2001)
        let event2038 = Event(date: year2038)

        #expect(event1970.date == year1970)
        #expect(event2001.date == year2001)
        #expect(event2038.date == year2038)
    }

    @Test("Event handles whitespace-only strings")
    func testWhitespaceStrings() {
        let whitespaceTitle = "   \t\n   "
        let whitespaceVenue = "\r\n\t    \r\n"
        let event = Event(title: whitespaceTitle, venueName: whitespaceVenue)

        #expect(event.title == whitespaceTitle)
        #expect(event.venueName == whitespaceVenue)
        #expect(!event.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false)
    }

    @Test("Event handles mixed language content")
    func testMixedLanguageContent() {
        let mixedTitle = "English 中文 Español العربية Русский"
        let mixedVenue = "हिन्दी Français Deutsch 日本語 한국어"
        let event = Event(title: mixedTitle, venueName: mixedVenue)

        #expect(event.title == mixedTitle)
        #expect(event.venueName == mixedVenue)
    }

    @Test("Event handles emoji and symbols")
    func testEmojiAndSymbols() {
        let emojiTitle = "🎉 Party Event 🎊 🎈 🎁"
        let symbolVenue = "⭐ ★ ✓ ✗ ♠ ♣ ♥ ♦ ⚡ ⚠️"
        let event = Event(title: emojiTitle, venueName: symbolVenue)

        #expect(event.title == emojiTitle)
        #expect(event.venueName == symbolVenue)
        #expect(event.title.contains("🎉"))
        #expect(event.venueName.contains("⭐"))
    }

    @Test("Event maintains consistency with rapid property changes")
    func testRapidPropertyChanges() {
        let event = Event()

        // Rapidly change properties multiple times
        for i in 0..<100 {
            event.title = "Title \(i)"
            event.venueName = "Venue \(i)"

            #expect(event.title == "Title \(i)")
            #expect(event.venueName == "Venue \(i)")
        }
    }
}

@Suite("Event Model - Object Identity")
struct EventObjectIdentityTests {

    @Test("Different Event instances have unique identifiers")
    func testUniqueIdentifiers() {
        let events = (0..<100).map { _ in Event() }
        let identifiers = Set(events.map { $0.identifier })

        #expect(identifiers.count == 100) // All identifiers should be unique
    }

    @Test("Event instances with same data are distinct objects")
    func testDistinctObjects() {
        let title = "Same Title"
        let venue = "Same Venue"
        let date = Date.now

        let event1 = Event(title: title, venueName: venue, date: date)
        let event2 = Event(title: title, venueName: venue, date: date)

        // Properties are same but identifiers are different
        #expect(event1.title == event2.title)
        #expect(event1.venueName == event2.venueName)
        #expect(event1.date == event2.date)
        #expect(event1.identifier != event2.identifier)
    }

    @Test("Event identifier uniqueness across many instances")
    func testIdentifierUniquenessAtScale() {
        var identifiers: Set<UUID> = []

        for _ in 0..<1000 {
            let event = Event()
            let wasInserted = identifiers.insert(event.identifier).inserted
            #expect(wasInserted) // Should always be a new, unique identifier
        }

        #expect(identifiers.count == 1000)
    }

    @Test("Events with same identifier are logically same")
    func testSameIdentifierLogic() {
        let sharedID = UUID()
        let event1 = Event(identifier: sharedID, title: "Event 1")
        let event2 = Event(identifier: sharedID, title: "Event 2")

        #expect(event1.identifier == event2.identifier)
        #expect(event1.title != event2.title) // Different titles
    }
}

@Suite("Event Model - Value Semantics")
struct EventValueSemanticsTests {

    @Test("Property changes don't affect other instances")
    func testPropertyIsolation() {
        let event1 = Event(title: "Original")
        let event2 = Event(title: "Original")

        event1.title = "Modified"

        #expect(event1.title == "Modified")
        #expect(event2.title == "Original") // Should be unchanged
    }

    @Test("Copying event properties works correctly")
    func testPropertyCopying() {
        let sourceEvent = Event(
            title: "Source Title",
            venueName: "Source Venue",
            date: Date.now.addingTimeInterval(3600)
        )

        let targetEvent = Event()
        targetEvent.title = sourceEvent.title
        targetEvent.venueName = sourceEvent.venueName
        targetEvent.date = sourceEvent.date

        #expect(targetEvent.title == sourceEvent.title)
        #expect(targetEvent.venueName == sourceEvent.venueName)
        #expect(targetEvent.date == sourceEvent.date)
        #expect(targetEvent.identifier != sourceEvent.identifier) // Should still be different
    }

    @Test("Event immutability of identifier after creation")
    func testIdentifierStability() {
        let event = Event()
        let originalIdentifier = event.identifier

        // Modify other properties
        let mutableEvent = event
        mutableEvent.title = "Changed"
        mutableEvent.venueName = "Changed"
        mutableEvent.date = Date.now.addingTimeInterval(3600)

        #expect(mutableEvent.identifier == originalIdentifier) // ID should remain the same
    }

    @Test("Events maintain independence in collections")
    func testCollectionIndependence() {
        let events = [
            Event(title: "Event 1"),
            Event(title: "Event 2"),
            Event(title: "Event 3")
        ]

        events[0].title = "Modified Event 1"

        #expect(events[0].title == "Modified Event 1")
        #expect(events[1].title == "Event 2") // Unchanged
        #expect(events[2].title == "Event 3") // Unchanged
    }

    @Test("Event property assignment preserves data types")
    func testDataTypePreservation() {
        let event = Event()

        let stringValue: String = "Type Test"
        let dateValue: Date = Date.now
        let uuidValue: UUID = UUID()

        event.title = stringValue
        event.date = dateValue
        event.identifier = uuidValue

        #expect(type(of: event.title) == String.self)
        #expect(type(of: event.date) == Date.self)
        #expect(type(of: event.identifier) == UUID.self)
    }
}
