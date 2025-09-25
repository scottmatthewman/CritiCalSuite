//
//  GenreDTOTests.swift
//  CritiCalDomainTests
//
//  Created by Scott Matthewman on 22/09/2025.
//

import Testing
import Foundation
@testable import CritiCalDomain

@Suite("GenreDTO - Initialization")
struct GenreDTOInitializationTests {

    @Test("GenreDTO initializes with default values")
    func testInitializationWithDefaults() {
        let dto = GenreDTO(name: "Comedy")

        #expect(dto.name == "Comedy")
        #expect(dto.details == "")
        #expect(dto.hexColor == "888888")
        #expect(dto.isDeactivated == false)
        #expect(dto.id != UUID())
    }

    @Test("GenreDTO initializes with all custom values")
    func testInitializationWithCustomValues() {
        let customID = UUID()
        let dto = GenreDTO(
            id: customID,
            name: "Drama",
            details: "Dramatic theatrical performances",
            hexColor: "FF5522",
            isDeactivated: true
        )

        #expect(dto.id == customID)
        #expect(dto.name == "Drama")
        #expect(dto.details == "Dramatic theatrical performances")
        #expect(dto.hexColor == "FF5522")
        #expect(dto.isDeactivated == true)
    }
}

@Suite("GenreDTO - Equatable")
struct GenreDTOEquatableTests {

    @Test("Objects are equal when all attributes match")
    func testEquatable_Equal() {
        let id = UUID()

        let dto1 = GenreDTO(
            id: id,
            name: "Music",
            details: "Live music performances",
            hexColor: "112233",
            isDeactivated: false
        )

        let dto2 = GenreDTO(
            id: id,
            name: "Music",
            details: "Live music performances",
            hexColor: "112233",
            isDeactivated: false
        )

        #expect(dto1 == dto2)
    }

    @Test("Objects are not equal when IDs differ")
    func testEquatable_DifferentIDs() {
        let dto1 = GenreDTO(
            name: "Dance",
            details: "Dance performances"
        )

        let dto2 = GenreDTO(
            name: "Dance",
            details: "Dance performances"
        )

        #expect(dto1 != dto2)
    }

    @Test("Objects are not equal when attributes differ")
    func testEquatable_DifferentAttributes() {
        let id = UUID()

        let dto1 = GenreDTO(
            id: id,
            name: "Theater",
            isDeactivated: false
        )

        let dto2 = GenreDTO(
            id: id,
            name: "Theatre",  // Different spelling
            isDeactivated: false
        )

        #expect(dto1 != dto2)
    }
}

@Suite("GenreDTO - Identifiable")
struct GenreDTOIdentifiableTests {

    @Test("#id uses the object's UUID")
    func testIdentifiable() {
        let customID = UUID()
        let dto = GenreDTO(
            id: customID,
            name: "Opera"
        )

        #expect(dto.id == customID)
    }
}

@Suite("GenreDTO - Sendable")
struct GenreDTOSendableTests {

    @Test("GenreDTO conforms to sendable for concurrent access")
    func testSendableConformance() async {
        let dto = GenreDTO(
            name: "Circus",
            details: "Circus and acrobatic shows",
            hexColor: "FF00FF"
        )

        await withTaskGroup(of: GenreDTO.self) { group in
            group.addTask { dto }
            group.addTask { dto }

            var results: [GenreDTO] = []
            for await result in group {
                results.append(result)
            }

            #expect(results.count == 2)
            #expect(results[0] == results[1])
        }
    }
}