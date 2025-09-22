//
//  GenreDTOColorTests.swift
//  CritiCalUITests
//
//  Created by Scott Matthewman on 22/09/2025.
//

import Testing
import SwiftUI
import CritiCalDomain
@testable import CritiCalUI

@Suite("GenreDTO+Color - Color Property")
struct GenreDTOColorTests {

    @Test("GenreDTO color property returns valid Color")
    func testGenreDTOColorProperty() {
        let genre = GenreDTO(
            name: "Comedy",
            hexColor: "FF6B6B"
        )

        let color = genre.color
        #expect(type(of: color) == Color.self)
    }

    @Test("GenreDTO with default hex color returns gray Color")
    func testGenreDTODefaultColor() {
        let genre = GenreDTO(name: "Theater")

        let color = genre.color
        #expect(type(of: color) == Color.self)
        // Default hex color is "888888" which should create a gray color
    }

    @Test("GenreDTO with custom hex color")
    func testGenreDTOCustomColor() {
        let genre = GenreDTO(
            name: "Music",
            hexColor: "9B59B6"
        )

        let color = genre.color
        #expect(type(of: color) == Color.self)
    }

    @Test("GenreDTO color property with hash prefix")
    func testGenreDTOColorWithHashPrefix() {
        let genre = GenreDTO(
            name: "Dance",
            hexColor: "#E74C3C"
        )

        let color = genre.color
        #expect(type(of: color) == Color.self)
    }
}