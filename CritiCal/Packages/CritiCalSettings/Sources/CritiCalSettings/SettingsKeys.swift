//
//  SettingsKeys.swift
//  CritiCalSettings
//
//  Created by Scott Matthewman on 11/10/2025.
//

import Defaults

extension Defaults.Keys {
    /// The version of onboarding that was last completed (stored as Int)
    public static let completedOnboardingVersion = Key<Int?>(
        "com.critical.onboardingVersion",
        default: nil
    )
}
