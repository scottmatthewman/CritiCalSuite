//
//  GenreEntityTests.swift
//  CritiCalIntentsTests
//
//  Created by Scott Matthewman on 22/09/2025.
//

import Testing
import Foundation
import AppIntents
import CritiCalDomain
import CritiCalModels
@testable import CritiCalIntents

@Suite("GenreEntity - Initialization from DTO")
struct GenreEntityInitializationTests {

    @Test("GenreEntity initializes correctly from GenreDTO")
    func testBasicInitializationFromDTO() {
        let genreDTO = GenreDTO(
            id: UUID(),
            name: "Music",
            details: "Live music performances",
            hexColor: "FF5500",
            isDeactivated: false
        )

        let entity = GenreEntity(from: genreDTO)

        #expect(entity.id == genreDTO.id)
        #expect(entity.name == "Music")
        #expect(entity.details == "Live music performances")
        #expect(entity.hexColor == "FF5500")
        #expect(entity.isActive == true)  // Note: inverted from isDeactivated
    }

    @Test("GenreEntity correctly inverts isDeactivated to isActive")
    func testIsActiveInversion() {
        let activeGenreDTO = GenreDTO(
            name: "Active Genre",
            isDeactivated: false
        )

        let activeEntity = GenreEntity(from: activeGenreDTO)
        #expect(activeEntity.isActive == true)

        let inactiveGenreDTO = GenreDTO(
            name: "Inactive Genre",
            isDeactivated: true
        )

        let inactiveEntity = GenreEntity(from: inactiveGenreDTO)
        #expect(inactiveEntity.isActive == false)
    }

    @Test("GenreEntity handles default DTO values")
    func testDefaultValues() {
        let genreDTO = GenreDTO(name: "Theater")

        let entity = GenreEntity(from: genreDTO)

        #expect(entity.name == "Theater")
        #expect(entity.details == "")
        #expect(entity.hexColor == "888888")
        #expect(entity.isActive == true)
    }
}

@Suite("GenreEntity - Display Representation")
struct GenreEntityDisplayTests {

    @Test("Display representation shows name as title")
    func testDisplayRepresentationTitle() {
        let genreDTO = GenreDTO(
            name: "Comedy",
            details: "Stand-up and sketch comedy"
        )

        let entity = GenreEntity(from: genreDTO)
        let displayRep = entity.displayRepresentation

        let titleString = String(localized: displayRep.title)
        #expect(titleString == "Comedy")
    }

    @Test("Display representation includes details as subtitle when present")
    func testDisplayRepresentationWithDetails() {
        let genreDTO = GenreDTO(
            name: "Drama",
            details: "Dramatic theatrical performances"
        )

        let entity = GenreEntity(from: genreDTO)
        let displayRep = entity.displayRepresentation

        #expect(displayRep.subtitle != nil)
        let subtitleString = String(localized: displayRep.subtitle!)
        #expect(subtitleString == "Dramatic theatrical performances")
    }

    @Test("Display representation has nil subtitle when details are empty")
    func testDisplayRepresentationEmptyDetails() {
        let genreDTO = GenreDTO(
            name: "Dance",
            details: ""
        )

        let entity = GenreEntity(from: genreDTO)
        let displayRep = entity.displayRepresentation

        #expect(displayRep.subtitle == nil)
    }
}

@Suite("GenreEntity - AppEntity Conformance")
struct GenreEntityAppEntityTests {

    @Test("Type display representation is correctly set")
    func testTypeDisplayRepresentation() {
        let typeDisplay = GenreEntity.typeDisplayRepresentation
        #expect(typeDisplay.name == "Genre")
    }

    @Test("Property wrappers are configured correctly")
    func testPropertyConfiguration() {
        let genreDTO = GenreDTO(
            name: "Opera",
            details: "Classical opera performances",
            hexColor: "AA33FF"
        )

        let entity = GenreEntity(from: genreDTO)

        #expect(entity.name == "Opera")
        #expect(entity.details == "Classical opera performances")
        #expect(entity.hexColor == "AA33FF")
        #expect(entity.isActive == true)
    }
}

@Suite("GenreEntity - Identifiable")
struct GenreEntityIdentifiableTests {

    @Test("GenreEntity uses UUID from DTO as identifier")
    func testIdentifiableConformance() {
        let customID = UUID()
        let genreDTO = GenreDTO(
            id: customID,
            name: "Jazz"
        )

        let entity = GenreEntity(from: genreDTO)
        #expect(entity.id == customID)
    }

    @Test("Different GenreEntity instances have different ids")
    func testUniqueIdentifiers() {
        let dto1 = GenreDTO(name: "Rock")
        let dto2 = GenreDTO(name: "Pop")

        let entity1 = GenreEntity(from: dto1)
        let entity2 = GenreEntity(from: dto2)

        #expect(entity1.id != entity2.id)
    }
}

@Suite("GenreEntity - Sendable")
struct GenreEntitySendableTests {

    @Test("GenreEntity conforms to Sendable for concurrent access")
    func testSendableConformance() async {
        let genreDTO = GenreDTO(
            name: "Classical",
            details: "Classical music performances"
        )

        let entity = GenreEntity(from: genreDTO)

        await withTaskGroup(of: GenreEntity.self) { group in
            group.addTask { entity }
            group.addTask { entity }
            group.addTask { entity }

            var results: [GenreEntity] = []
            for await result in group {
                results.append(result)
            }

            #expect(results.count == 3)
            #expect(results.allSatisfy { $0.id == entity.id })
            #expect(results.allSatisfy { $0.name == "Classical" })
        }
    }
}