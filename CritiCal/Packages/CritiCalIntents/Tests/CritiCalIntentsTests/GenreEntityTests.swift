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

    @Test("GenreEntity initializes correctly from DetachedGenre")
    func testBasicInitializationFromDetachedGenre() {
        let genreId = UUID()
        let detachedGenre = DetachedGenre(
            id: genreId,
            name: "Music",
            details: "Live music performances",
            colorName: "Music",
            hexColor: "FF5500",
            symbolName: "music.note",
            isDeactivated: false
        )

        let entity = GenreEntity(from: detachedGenre)

        #expect(entity.id == genreId)
        #expect(entity.name == "Music")
        #expect(entity.details == "Live music performances")
        #expect(entity.hexColor == "FF5500")
        #expect(entity.isActive == true)  // Note: inverted from isDeactivated
    }

    @Test("GenreEntity correctly inverts isDeactivated to isActive")
    func testIsActiveInversion() {
        let activeGenre = DetachedGenre(
            id: UUID(),
            name: "Active Genre",
            details: "",
            colorName: "Active Genre",
            hexColor: "888888",
            symbolName: "tag",
            isDeactivated: false
        )

        let activeEntity = GenreEntity(from: activeGenre)
        #expect(activeEntity.isActive == true)

        let inactiveGenre = DetachedGenre(
            id: UUID(),
            name: "Inactive Genre",
            details: "",
            colorName: "Inactive Genre",
            hexColor: "888888",
            symbolName: "tag",
            isDeactivated: true
        )

        let inactiveEntity = GenreEntity(from: inactiveGenre)
        #expect(inactiveEntity.isActive == false)
    }

    @Test("GenreEntity handles default values")
    func testDefaultValues() {
        let genre = DetachedGenre(
            id: UUID(),
            name: "Theater",
            details: "",
            colorName: "Theater",
            hexColor: "888888",
            symbolName: "tag",
            isDeactivated: false
        )

        let entity = GenreEntity(from: genre)

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
        let genre = DetachedGenre(
            id: UUID(),
            name: "Comedy",
            details: "Stand-up and sketch comedy",
            colorName: "Comedy",
            hexColor: "888888",
            symbolName: "tag",
            isDeactivated: false
        )

        let entity = GenreEntity(from: genre)
        let displayRep = entity.displayRepresentation

        let titleString = String(localized: displayRep.title)
        #expect(titleString == "Comedy")
    }

    @Test("Display representation includes details as subtitle when present")
    func testDisplayRepresentationWithDetails() {
        let genre = DetachedGenre(
            id: UUID(),
            name: "Drama",
            details: "Dramatic theatrical performances",
            colorName: "Drama",
            hexColor: "888888",
            symbolName: "tag",
            isDeactivated: false
        )

        let entity = GenreEntity(from: genre)
        let displayRep = entity.displayRepresentation

        #expect(displayRep.subtitle != nil)
        let subtitleString = String(localized: displayRep.subtitle!)
        #expect(subtitleString == "Dramatic theatrical performances")
    }

    @Test("Display representation has nil subtitle when details are empty")
    func testDisplayRepresentationEmptyDetails() {
        let genre = DetachedGenre(
            id: UUID(),
            name: "Dance",
            details: "",
            colorName: "Dance",
            hexColor: "888888",
            symbolName: "tag",
            isDeactivated: false
        )

        let entity = GenreEntity(from: genre)
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
        let genre = DetachedGenre(
            id: UUID(),
            name: "Opera",
            details: "Classical opera performances",
            colorName: "Opera",
            hexColor: "AA33FF",
            symbolName: "tag",
            isDeactivated: false
        )

        let entity = GenreEntity(from: genre)

        #expect(entity.name == "Opera")
        #expect(entity.details == "Classical opera performances")
        #expect(entity.hexColor == "AA33FF")
        #expect(entity.isActive == true)
    }
}

@Suite("GenreEntity - Identifiable")
struct GenreEntityIdentifiableTests {

    @Test("GenreEntity uses UUID as identifier")
    func testIdentifiableConformance() {
        let customID = UUID()
        let genre = DetachedGenre(
            id: customID,
            name: "Jazz",
            details: "",
            colorName: "Jazz",
            hexColor: "888888",
            symbolName: "tag",
            isDeactivated: false
        )

        let entity = GenreEntity(from: genre)
        #expect(entity.id == customID)
    }

    @Test("Different GenreEntity instances have different ids")
    func testUniqueIdentifiers() {
        let genre1 = DetachedGenre(
            id: UUID(),
            name: "Rock",
            details: "",
            colorName: "Rock",
            hexColor: "888888",
            symbolName: "tag",
            isDeactivated: false
        )
        let genre2 = DetachedGenre(
            id: UUID(),
            name: "Pop",
            details: "",
            colorName: "Pop",
            hexColor: "888888",
            symbolName: "tag",
            isDeactivated: false
        )

        let entity1 = GenreEntity(from: genre1)
        let entity2 = GenreEntity(from: genre2)

        #expect(entity1.id != entity2.id)
    }
}

@Suite("GenreEntity - Sendable")
struct GenreEntitySendableTests {

    @Test("GenreEntity conforms to Sendable for concurrent access")
    func testSendableConformance() async {
        let genre = DetachedGenre(
            id: UUID(),
            name: "Classical",
            details: "Classical music performances",
            colorName: "Classical",
            hexColor: "888888",
            symbolName: "tag",
            isDeactivated: false
        )

        let entity = GenreEntity(from: genre)

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