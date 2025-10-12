//
//  OnboardingSettingsTests.swift
//  OnboardingFlowTests
//
//  Created by Scott Matthewman on 22/09/2025.
//

import Testing
import Foundation
import CritiCalSettings
@testable import OnboardingFlow

@Suite("OnboardingSettings") @MainActor
struct OnboardingSettingsTests {

    @Test("Should show onboarding for first time users")
    func testFirstTimeUser() {
        let userDefaults = UserDefaults(suiteName: "test.onboarding")!
        userDefaults.removePersistentDomain(forName: "test.onboarding")

        let mockSettings = MockSettingsWriter(suite: userDefaults)
        let settings = OnboardingSettings(settings: mockSettings)

        #expect(settings.shouldShowOnboarding == true)
        #expect(settings.completedVersion == nil)

        // Clean up
        userDefaults.removePersistentDomain(forName: "test.onboarding")
    }

    @Test("Should not show onboarding after completion")
    func testCompletedOnboarding() {
        let userDefaults = UserDefaults(suiteName: "test.onboarding.completed")!
        userDefaults.removePersistentDomain(forName: "test.onboarding.completed")

        let mockSettings = MockSettingsWriter(suite: userDefaults)
        let settings = OnboardingSettings(settings: mockSettings)

        // Complete onboarding
        settings.completeOnboarding()

        #expect(settings.shouldShowOnboarding == false)
        #expect(settings.completedVersion == OnboardingVersion.current)

        // Clean up
        userDefaults.removePersistentDomain(forName: "test.onboarding.completed")
    }

    @Test("Should show onboarding for new version")
    func testNewVersionAvailable() {
        let userDefaults = UserDefaults(suiteName: "test.onboarding.version")!
        userDefaults.removePersistentDomain(forName: "test.onboarding.version")

        let mockSettings = MockSettingsWriter(suite: userDefaults)
        let settings = OnboardingSettings(settings: mockSettings)

        // Set completed version to older version
        settings.completedVersion = OnboardingVersion(version: OnboardingVersion.current.version - 1)

        #expect(settings.shouldShowOnboarding == true)

        // Clean up
        userDefaults.removePersistentDomain(forName: "test.onboarding.version")
    }

    @Test("Should persist across instances")
    func testPersistence() {
        let userDefaults = UserDefaults(suiteName: "test.onboarding.persist")!
        userDefaults.removePersistentDomain(forName: "test.onboarding.persist")

        let mockSettings1 = MockSettingsWriter(suite: userDefaults)
        let settings1 = OnboardingSettings(settings: mockSettings1)
        settings1.completeOnboarding()

        // Create new instance with same UserDefaults
        let mockSettings2 = MockSettingsWriter(suite: userDefaults)
        let settings2 = OnboardingSettings(settings: mockSettings2)

        #expect(settings2.shouldShowOnboarding == false)
        #expect(settings2.completedVersion == OnboardingVersion.current)

        // Clean up
        userDefaults.removePersistentDomain(forName: "test.onboarding.persist")
    }

    @Test("Reset onboarding works")
    func testResetOnboarding() {
        let userDefaults = UserDefaults(suiteName: "test.onboarding.reset")!
        userDefaults.removePersistentDomain(forName: "test.onboarding.reset")

        let mockSettings = MockSettingsWriter(suite: userDefaults)
        let settings = OnboardingSettings(settings: mockSettings)
        settings.completeOnboarding()

        #expect(settings.shouldShowOnboarding == false)

        settings.resetOnboarding()

        #expect(settings.shouldShowOnboarding == true)
        #expect(settings.completedVersion == nil)

        // Clean up
        userDefaults.removePersistentDomain(forName: "test.onboarding.reset")
    }
}
