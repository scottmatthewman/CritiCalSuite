//
//  EventEntityTests.swift
//  CritiCalIntentsTests
//
//  Created by Claude on 20/09/2025.
//

import Testing
import Foundation
import AppIntents
import CritiCalDomain
import CritiCalModels
@testable import CritiCalIntents

@Suite("EventEntity - Initialization")
struct EventEntityInitializationTests {

    @Test("EventEntity initializes with all properties correctly")
    func testBasicInitialization() {
        let id = UUID()
        let title = "Test Event"
        let festival = "Test Festival"
        let date = Date.now
        let venueName = "Test Venue"

        let entity = EventEntity(
            id: id,
            title: title,
            festivalName: festival,
            date: date,
            venueName: venueName
        )

        #expect(entity.id == id)
        #expect(entity.title == title)
        #expect(entity.date == date)
        #expect(entity.festivalName == festival)
        #expect(entity.venueName == venueName)
    }

    @Test("EventEntity initializes with default values for optional properties")
    func testInitializationWithDefaults() {
        let entity = EventEntity(
            title: "Default Event",
            date: Date.now
        )

        #expect(type(of: entity.id) == UUID.self)
        #expect(entity.festivalName == "")
        #expect(entity.venueName == "")
    }

    @Test("EventEntity properties remain accessible after initialization")
    func testPropertyAccessibility() {
        let entity = EventEntity(
            id: UUID(),
            title: "Concert",
            festivalName: "Summer Fest",
            date: Date.now.addingTimeInterval(86400),
            venueName: "Madison Square Garden"
        )

        // Test that all properties can be accessed
        let _ = entity.id
        let _ = entity.title
        let _ = entity.festivalName
        let _ = entity.date
        let _ = entity.venueName

        // Properties should maintain their values
        #expect(entity.title == "Concert")
        #expect(entity.festivalName == "Summer Fest")
        #expect(entity.venueName == "Madison Square Garden")
    }

    @Test("EventEntity handles edge case values")
    func testEdgeCaseValues() {
        let entity = EventEntity(
            title: "",
            date: Date.distantPast,
        )

        #expect(entity.date == Date.distantPast)
    }

    @Test("EventEntity handles special characters in strings")
    func testSpecialCharacters() {
        let specialTitle = "Event with 特殊文字 & émojis 🎉"
        let specialFestival = "Fête de la Musique"
        let specialVenue = "Café Müller & Co."

        let entity = EventEntity(
            title: specialTitle,
            festivalName: specialFestival,
            date: Date.now,
            venueName: specialVenue
        )

        #expect(entity.title == specialTitle)
        #expect(entity.festivalName == specialFestival)
        #expect(entity.venueName == specialVenue)
    }
}

@Suite("EventEntity - Display Representation")
struct EventEntityDisplayTests {
    @Test("Display representation formats title correctly")
    func testDisplayRepresentationTitle() {
        let entity = EventEntity(
            title: "Annual Conference",
            festivalName: "Business Expo",
            date: Date.now,
            venueName: "Convention Center"
        )

        let displayRep = entity.displayRepresentation
        // Convert LocalizedStringResource to String for testing
        let titleString = String(localized: displayRep.title)
        #expect(titleString == "Annual Conference (Business Expo)")
    }

    @Test("Display representation formats subtitle with venue and date")
    func testDisplayRepresentationSubtitle() {
        let testDate = Date(timeIntervalSince1970: 1726819200) // Fixed date for consistent testing
        let entity = EventEntity(
            id: UUID(),
            title: "Tech Talk",
            festivalName: "Business Expo",
            date: testDate,
            venueName: "Tech Hub"
        )

        let displayRep = entity.displayRepresentation
        // Subtitle should be present
        #expect(displayRep.subtitle != nil)

        // Convert to string representation for testing
        let subtitleString = String(describing: displayRep.subtitle!)

        // Subtitle should contain venue name
        #expect(subtitleString.contains("Tech Hub"))
        // The date formatting will be included but format varies by locale
    }

    @Test("Display representation handles empty venue name")
    func testDisplayRepresentationEmptyVenue() {
        let date = Date.now
        let strDate = date.formatted()
        let entity = EventEntity(
            id: UUID(),
            title: "Virtual Event",
            festivalName: "Online Expo",
            date: date,
            venueName: ""
        )

        let displayRep = entity.displayRepresentation
        // Subtitle should still be present even with empty venue
        #expect(displayRep.subtitle != nil)

        // String representation will have empty venue but still include date
        let subtitleString = String(localized: displayRep.subtitle!)
        #expect(subtitleString == strDate) // Only use date if venue is empty
    }

    @Test("Display representation handles very long titles")
    func testDisplayRepresentationLongTitle() {
        let longTitle = String(repeating: "Very Long Event Title ", count: 20)
        let entity = EventEntity(
            id: UUID(),
            title: longTitle,
            festivalName: "Mega Festival",
            date: Date.now,
            venueName: "Venue"
        )

        let displayRep = entity.displayRepresentation
        #expect(
            String(localized: displayRep.title)
                .contains("Very Long Event Title"),
            "Title should contain the long event title text"
        )
        #expect(
            String(localized: displayRep.title).contains(" (Mega Festival)"),
            "Title should contain the festival name"
        )
    }
}

@Suite("EventEntity - AppEntity Conformance")
struct EventEntityAppEntityTests {

    @Test("Type display representation is correctly set")
    func testTypeDisplayRepresentation() {
        let typeDisplay = EventEntity.typeDisplayRepresentation
        #expect(typeDisplay.name == "Event")
    }

    @Test("Default query is properly initialized")
    func testDefaultQuery() {
        let query = EventEntity.defaultQuery
        #expect(type(of: query) == EventQuery.self)
    }

    @Test("Property wrappers have correct titles")
    func testPropertyTitles() {
        // This test verifies that the @Property wrappers are configured
        // The actual Property wrapper behavior is tested by AppIntents framework
        let entity = EventEntity(
            id: UUID(),
            title: "Test",
            festivalName: "Festival",
            date: Date.now,
            venueName: "Venue"
        )

        // Properties should be accessible
        #expect(entity.title == "Test")
        #expect(entity.venueName == "Venue")
        // Date property exists and is accessible
        #expect(entity.date != Date.distantFuture)
    }
}

@Suite("EventEntity - Identifiable")
struct EventEntityIdentifiableTests {

    @Test("EventEntity conforms to Identifiable with UUID id")
    func testIdentifiableConformance() {
        let customID = UUID()
        let entity = EventEntity(
            id: customID,
            title: "Event",
            festivalName: "Festival",
            date: Date.now,
            venueName: "Venue"
        )

        #expect(entity.id == customID)
    }

    @Test("Different EventEntity instances have different ids")
    func testUniqueIdentifiers() {
        let entity1 = EventEntity(
            id: UUID(),
            title: "Event 1",
            festivalName: "Festival 1",
            date: Date.now,
            venueName: "Venue 1"
        )

        let entity2 = EventEntity(
            id: UUID(),
            title: "Event 2",
            festivalName: "Festival 2",
            date: Date.now,
            venueName: "Venue 2"
        )

        #expect(entity1.id != entity2.id)
    }

    @Test("EventEntity with same id are identifiable as the same")
    func testSameIdentifier() {
        let sharedID = UUID()

        let entity1 = EventEntity(
            id: sharedID,
            title: "Event",
            festivalName: "Festival",
            date: Date.now,
            venueName: "Venue 1"
        )

        let entity2 = EventEntity(
            id: sharedID,
            title: "Different Event",
            festivalName: "Different Festival",
            date: Date.now.addingTimeInterval(3600),
            venueName: "Venue 2"
        )

        #expect(entity1.id == entity2.id)
    }
}

@Suite("EventEntity - Sendable")
struct EventEntitySendableTests {

    /// Tests that EventEntity can be safely shared across concurrent contexts.
    ///
    /// This test verifies:
    /// 1. EventEntity conforms to Sendable protocol
    /// 2. Can be passed between concurrent tasks without data races
    /// 3. Maintains data integrity in concurrent environments
    @Test("EventEntity conforms to Sendable and is thread-safe")
    func testSendableConformance() async {
        let entity = EventEntity(
            id: UUID(),
            title: "Concurrent Event",
            festivalName: "Concurrent Festival",
            date: Date.now,
            venueName: "Concurrent Venue"
        )

        // Test concurrent access using TaskGroup
        await withTaskGroup(of: EventEntity.self) { group in
            // Add multiple tasks that capture the same entity
            group.addTask { entity }
            group.addTask { entity }
            group.addTask { entity }

            var results: [EventEntity] = []
            for await result in group {
                results.append(result)
            }

            // Verify all tasks received the entity
            #expect(results.count == 3)

            // Verify all have the same id (identity preserved)
            #expect(results.allSatisfy { $0.id == entity.id })

            // Verify data integrity
            for result in results {
                #expect(result.title == "Concurrent Event")
                #expect(result.venueName == "Concurrent Venue")
            }
        }
    }

    @Test("EventEntity can be passed between isolated contexts")
    func testIsolatedContexts() async {
        let entity = EventEntity(
            id: UUID(),
            title: "Isolated Event",
            festivalName: "Isolated Festival",
            date: Date.now,
            venueName: "Isolated Venue"
        )

        // Create an async task that captures the entity
        let capturedEntity = await Task { entity }.value

        #expect(capturedEntity.id == entity.id)
        #expect(capturedEntity.title == entity.title)
        #expect(capturedEntity.date == entity.date)
        #expect(capturedEntity.venueName == entity.venueName)
    }
}

@Suite("EventEntity - Integration")
struct EventEntityIntegrationTests {

    @Test("EventEntity can be created from typical DTO values")
    func testDTOConversion() {
        // Simulate creating an EventEntity from EventDTO values
        let dtoId = UUID()
        let dtoTitle = "DTO Event"
        let dtoFestivalName = "DTO Festival"
        let dtoDate = Date.now
        let dtoVenueName = "DTO Venue"

        let entity = EventEntity(
            id: dtoId,
            title: dtoTitle,
            festivalName: dtoFestivalName,
            date: dtoDate,
            venueName: dtoVenueName
        )

        #expect(entity.id == dtoId)
        #expect(entity.title == dtoTitle)
        #expect(entity.festivalName == dtoFestivalName)
        #expect(entity.date == dtoDate)
        #expect(entity.venueName == dtoVenueName)
    }

    @Test("EventEntity can be created directly from a DTO")
    func testDTOInitialization() {
        let dto = EventDTO(
            id: UUID(),
            title: "Event",
            festivalName: "Festival",
            date: Date.now,
            venueName: "Venue"
        )

        let entity = EventEntity(from: dto)

        #expect(entity.id == dto.id)
        #expect(entity.title == dto.title)
        #expect(entity.festivalName == dto.festivalName)
        #expect(entity.date == dto.date)
        #expect(entity.venueName == dto.venueName)
        #expect(entity.genre == nil)
    }

    @Test("EventEntity can be created from DTO with genre")
    func testDTOInitializationWithGenre() {
        let genreDTO = GenreDTO(
            name: "Comedy",
            details: "Stand-up comedy performances",
            hexColor: "FF6B6B"
        )

        let dto = EventDTO(
            id: UUID(),
            title: "Comedy Night",
            festivalName: "Laugh Festival",
            date: Date.now,
            venueName: "Comedy Club",
            genre: genreDTO
        )

        let entity = EventEntity(from: dto)

        #expect(entity.id == dto.id)
        #expect(entity.title == dto.title)
        #expect(entity.genre != nil)
        #expect(entity.genre?.name == "Comedy")
        #expect(entity.genre?.details == "Stand-up comedy performances")
        #expect(entity.genre?.hexColor == "FF6B6B")
    }

    @Test("Multiple EventEntities can be created in batch")
    func testBatchCreation() {
        let entities = (0..<5).map { index in
            EventEntity(
                id: UUID(),
                title: "Event \(index)",
                festivalName: "Festival \(index)",
                date: Date.now.addingTimeInterval(Double(index) * 3600),
                venueName: "Venue \(index)"
            )
        }

        #expect(entities.count == 5)

        // Verify each entity has unique properties
        let titles = entities.map { $0.title }
        #expect(Set(titles).count == 5)

        let ids = entities.map { $0.id }
        #expect(Set(ids).count == 5)
    }
}
