//
//  TransitModeTests.swift
//  CritiCalSettingsTests
//
//  Created by Scott Matthewman on 11/10/2025.
//

import Testing
import Foundation
@testable import CritiCalSettings

@Suite("TransitMode") @MainActor
struct TransitModeTests {

    @Test("All cases have display names")
    func testDisplayNames() {
        #expect(TransitMode.publicTransit.displayName == "Public Transit")
        #expect(TransitMode.walking.displayName == "Walking")
        #expect(TransitMode.car.displayName == "Driving")
        #expect(TransitMode.cycling.displayName == "Cycling")
    }

    @Test("All cases have symbol names")
    func testSymbolNames() {
        #expect(TransitMode.publicTransit.symbolName == "bus.fill")
        #expect(TransitMode.walking.symbolName == "figure.walk")
        #expect(TransitMode.car.symbolName == "car.fill")
        #expect(TransitMode.cycling.symbolName == "bicycle")
    }

    @Test("Default transit mode is public transit")
    func testDefaultValue() {
        let suite = UserDefaults(suiteName: "test.transitmode.default")!
        suite.removePersistentDomain(forName: "test.transitmode.default")

        let mockSettings = MockSettingsWriter(suite: suite)
        #expect(mockSettings.preferredTransitMode == .publicTransit)

        suite.removePersistentDomain(forName: "test.transitmode.default")
    }

    @Test("Can set and retrieve transit mode")
    func testSetAndGet() {
        let suite = UserDefaults(suiteName: "test.transitmode.setget")!
        suite.removePersistentDomain(forName: "test.transitmode.setget")

        let mockSettings = MockSettingsWriter(suite: suite)
        mockSettings.setPreferredTransitMode(.cycling)

        #expect(mockSettings.preferredTransitMode == .cycling)

        suite.removePersistentDomain(forName: "test.transitmode.setget")
    }

    @Test("Transit mode persists across instances")
    func testPersistence() {
        let suite = UserDefaults(suiteName: "test.transitmode.persist")!
        suite.removePersistentDomain(forName: "test.transitmode.persist")

        let settings1 = MockSettingsWriter(suite: suite)
        settings1.setPreferredTransitMode(.car)

        let settings2 = MockSettingsWriter(suite: suite)
        #expect(settings2.preferredTransitMode == .car)

        suite.removePersistentDomain(forName: "test.transitmode.persist")
    }
}
