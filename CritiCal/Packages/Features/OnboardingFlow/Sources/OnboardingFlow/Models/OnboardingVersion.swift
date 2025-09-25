//
//  OnboardingVersion.swift
//  OnboardingFlow
//
//  Created by Scott Matthewman on 22/09/2025.
//

import Foundation

/// Represents the version of the onboarding flow
public struct OnboardingVersion: Codable, Comparable, Sendable {
    /// The version number of the onboarding flow
    public let version: Int

    /// The current version of the onboarding flow
    /// Increment this when you want to show the onboarding again to existing users
    public static let current = OnboardingVersion(version: 1)

    public init(version: Int) {
        self.version = version
    }

    // MARK: - Comparable

    public static func < (lhs: OnboardingVersion, rhs: OnboardingVersion) -> Bool {
        lhs.version < rhs.version
    }

    public static func == (lhs: OnboardingVersion, rhs: OnboardingVersion) -> Bool {
        lhs.version == rhs.version
    }
}