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
            date: date,
            venueName: "Test Venue"
        )

        #expect(dto.title == "Test Event")
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
            date: date,
            venueName: "Custom Venue"
        )

        #expect(dto.id == customID)
        #expect(dto.title == "Custom Event")
        #expect(dto.date == date)
        #expect(dto.venueName == "Custom Venue")
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
            date: date,
            venueName: "Venue"
        )

        let dto2 = EventDTO(
            id: id,
            title: "Event",
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
            date: date,
            venueName: "Venue"
        )

        let dto2 = EventDTO(
            id: UUID(),
            title: "Event",
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
            date: date,
            venueName: "Venue"
        )

        let dto2 = EventDTO(
            id: id,
            title: "Event 2",
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
    @Test("EventDTO conforms to sendable")
    func testSendableConformance() async {
        let dto = EventDTO(
            title: "Concurrent Event",
            date: Date.now,
            venueName: "Concurrent Venue"
        )

        await withTaskGroup(of: EventDTO.self) { group in
            group.addTask { dto }
            group.addTask { dto }

            var results: [EventDTO] = []
            for await result in group {
                results.append(result)
            }

            #expect(results.count == 2)
            #expect(results[0] == results[1])
        }
    }
}
