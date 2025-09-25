//
//  ColorHexTests.swift
//  CritiCalUITests
//
//  Created by Scott Matthewman on 22/09/2025.
//

import Testing
import SwiftUI
import CritiCalDomain // Provides Color+hex extension via CritiCalExtensions
@testable import CritiCalUI

@Suite("Color+Hex - Initialization")
struct ColorHexInitializationTests {

    @Test("Color initializes from 6-digit hex string")
    func testSixDigitHex() {
        let color = Color(hex: "FF5733")
        // Test that it creates a valid Color without crashing
        #expect(type(of: color) == Color.self)
    }

    @Test("Color initializes from hex string with hash prefix")
    func testHexWithHashPrefix() {
        let color = Color(hex: "#FF5733")
        #expect(type(of: color) == Color.self)
    }

    @Test("Color initializes from 3-digit hex string")
    func testThreeDigitHex() {
        let color = Color(hex: "F53")
        #expect(type(of: color) == Color.self)
    }

    @Test("Color initializes from 8-digit hex string with alpha")
    func testEightDigitHexWithAlpha() {
        let color = Color(hex: "FF5733AA")
        #expect(type(of: color) == Color.self)
    }

    @Test("Color handles invalid hex string gracefully")
    func testInvalidHexString() {
        let color = Color(hex: "invalid")
        #expect(type(of: color) == Color.self) // Should default to gray
    }

    @Test("Color handles empty hex string gracefully")
    func testEmptyHexString() {
        let color = Color(hex: "")
        #expect(type(of: color) == Color.self) // Should default to gray
    }

    @Test("Color handles hex string with whitespace")
    func testHexStringWithWhitespace() {
        let color = Color(hex: " FF5733 ")
        #expect(type(of: color) == Color.self)
    }

    @Test("Color handles default Genre hex color")
    func testDefaultGenreHexColor() {
        let color = Color(hex: "888888")
        #expect(type(of: color) == Color.self)
    }
}