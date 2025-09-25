//
//  OnboardingVersionTests.swift
//  OnboardingFlowTests
//
//  Created by Scott Matthewman on 22/09/2025.
//

import Testing
import Foundation
@testable import OnboardingFlow

@Suite("OnboardingVersion") @MainActor
struct OnboardingVersionTests {

    @Test("Version comparison works correctly")
    func testVersionComparison() {
        let v1 = OnboardingVersion(version: 1)
        let v2 = OnboardingVersion(version: 2)
        let v1Copy = OnboardingVersion(version: 1)

        #expect(v1 < v2)
        #expect(!(v2 < v1))
        #expect(v1 == v1Copy)
        #expect(v1 != v2)
    }

    @Test("Current version is set")
    func testCurrentVersion() {
        let current = OnboardingVersion.current
        #expect(current.version > 0)
    }

    @Test("Version is Codable")
    func testVersionCodable() throws {
        let original = OnboardingVersion(version: 42)

        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(OnboardingVersion.self, from: data)

        #expect(decoded == original)
    }

    @Test("Version is Sendable")
    func testVersionSendable() async {
        let version = OnboardingVersion(version: 1)
        let versionValue = version.version  // Capture the value before the task group

        await withTaskGroup(of: Int.self) { group in
            group.addTask { versionValue }
            group.addTask { versionValue }

            var results: [Int] = []
            for await result in group {
                results.append(result)
            }

            #expect(results.count == 2)
            #expect(results.allSatisfy { $0 == 1 })
        }
    }
}
