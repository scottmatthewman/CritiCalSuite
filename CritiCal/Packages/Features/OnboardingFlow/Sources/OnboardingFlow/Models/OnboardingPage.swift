//
//  OnboardingPage.swift
//  OnboardingFlow
//
//  Created by Scott Matthewman on 22/09/2025.
//

import SwiftUI

/// Represents a single page in the onboarding flow
public struct OnboardingPage: Identifiable, Sendable {
    public let id = UUID()
    public let title: String
    public let description: String
    public let disclaimer: String
    public let systemImage: String
    public let imageColor: Color

    public init(
        title: String,
        description: String,
        disclaimer: String = "",
        systemImage: String,
        imageColor: Color = .accentColor
    ) {
        self.title = title
        self.description = description
        self.disclaimer = disclaimer
        self.systemImage = systemImage
        self.imageColor = imageColor
    }
}

// MARK: - Default Pages

extension OnboardingPage {
    /// Default onboarding pages for CritiCal
    public static let defaultPages: [OnboardingPage] = [
        OnboardingPage(
            title: "Welcome to CritiCal",
            description: "Track all your cultural events in one place. From theatre shows to concerts, keep everything organized.",
            systemImage: "theatermasks.fill",
            imageColor: .purple
        ),
        OnboardingPage(
            title: "Track your billable work*",
            description: "Keep track of the reviews you need to invoice for. CritiCal isn't an invoicing system but will help you reconcile your work",
            disclaimer: "* Coming soon. Billable features will be a subscriber-only feature at launch, but available during beta testing.",
            systemImage: "sterlingsign.gauge.chart.leftthird.topthird.rightthird",
            imageColor: .green
        ),
        OnboardingPage(
            title: "Automatic Sync",
            description: "Plan your calendar on your Mac or iPad, then take the same data with you on iPhone. iCloud keeps your data secure and automatically synced.",
            disclaimer: "Sync requires iCloud account. You can use CritiCal on a single device without sync.",
            systemImage: "macbook.and.iphone",
            imageColor: .indigo
        ),
        OnboardingPage(
            title: "Connect to navigation apps",
            description: "On iPhone, navigation insttructions to your next event are a single click away",
            systemImage: "iphone.badge.location",
            imageColor: .teal
        ),
        OnboardingPage(
            title: "Track +1 and PR Contacts",
            description: "Connect with your device's Contacts to keep track of PR contacts and +1 attendees for each show",
            systemImage: "person.2.badge.plus"
        ),
        OnboardingPage(
            title: "Siri & Shortcuts",
            description: "Ask Siri about your upcoming events or create shortcuts for quick access to your schedule.",
            systemImage: "waveform.badge.mic",
            imageColor: .blue
        ),
    ]
}
