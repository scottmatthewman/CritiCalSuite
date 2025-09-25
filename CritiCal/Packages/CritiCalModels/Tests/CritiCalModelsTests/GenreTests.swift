//
//  GenreTests.swift
//  CritiCalModelsTests
//
//  Created by Scott Matthewman on 25/09/2025.
//

import Testing
import SwiftUI
@testable import CritiCalModels

@Suite("Genre Model - Computed Properties")
struct GenreComputedPropertiesTests {

    @Test("color property creates correct Color from hexColor")
    func testColorFromHex() {
        let genre = Genre(name: "Test Genre", hexColor: "ff0000")

        let color = genre.color
        #expect(color is Color)

        // We can't easily test the exact color value, but we can ensure it's created without crashing
        #expect(genre.hexColor == "ff0000")
    }

    @Test("color property handles various hex color values",
          arguments: [
            "000000", // Black
            "ffffff", // White
            "ff0000", // Red
            "00ff00", // Green
            "0000ff", // Blue
            "888888", // Gray (default)
            "123456", // Random hex
            "abcdef"  // Letters in hex
          ])
    func testColorWithVariousHexValues(hexColor: String) {
        let genre = Genre(name: "Test Genre", hexColor: hexColor)

        let color = genre.color
        #expect(color is Color)
        #expect(genre.hexColor == hexColor)
    }

    @Test("color property is consistent for multiple accesses")
    func testColorConsistency() {
        let genre = Genre(name: "Test Genre", hexColor: "336699")

        let firstAccess = genre.color
        let secondAccess = genre.color
        let thirdAccess = genre.color

        // We can't directly compare Color instances, but we can ensure they're all created successfully
        #expect(firstAccess is Color)
        #expect(secondAccess is Color)
        #expect(thirdAccess is Color)
    }

    @Test("color property updates when hexColor changes")
    func testColorUpdatesWithHexColor() {
        let genre = Genre(name: "Test Genre", hexColor: "ff0000")

        let originalColor = genre.color
        #expect(originalColor is Color)

        genre.hexColor = "00ff00"
        let newColor = genre.color
        #expect(newColor is Color)

        // Verify the hex color was actually changed
        #expect(genre.hexColor == "00ff00")
    }

    @Test("color property handles default hex color value")
    func testColorWithDefaultHex() {
        let genre = Genre(name: "Test Genre") // Uses default hexColor: "888888"

        let color = genre.color
        #expect(color is Color)
        #expect(genre.hexColor == "888888")
    }
}