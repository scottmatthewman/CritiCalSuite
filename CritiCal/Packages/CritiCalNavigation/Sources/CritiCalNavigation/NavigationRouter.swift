//
//  NavigationRouter.swift
//  CritiCalUI
//
//  Created by Scott Matthewman on 22/09/2025.
//

import CritiCalModels
import Foundation

@Observable
public final class NavigationRouter: Sendable {
    private protocol TabRoute: Hashable {}

    public enum EventTabRoute: @MainActor TabRoute {
        case event(Event)
        // backup (legacy) path -- hoipefully not needed
        case eventByIdentifier(UUID)
    }
    public enum ReviewsTabRoute: @MainActor TabRoute {
        case reviewDetails(UUID)
    }
    public enum TabOption {
        case home
        case events
        case reviews
        case developer
        case search
    }

    public var selectedTab: TabOption
    public var eventsPath: [EventTabRoute]
    public var reviewsPath: [ReviewsTabRoute]

    // modals
    public var isSettingsViewPresented: Bool = false

    public init() {
        self.selectedTab = .events
        self.eventsPath = []
        self.reviewsPath = []
    }

    public func navigateHome() {
        selectedTab = .home
    }

    public func navigate(toEventID eventID: UUID) {
        selectedTab = .events
        eventsPath = [.eventByIdentifier(eventID)]
    }

    public func navigate(to event: Event) {
        selectedTab = .events
        eventsPath = [.event(event)]
    }

    public func showSettings() {
        self.isSettingsViewPresented = true
    }
}

