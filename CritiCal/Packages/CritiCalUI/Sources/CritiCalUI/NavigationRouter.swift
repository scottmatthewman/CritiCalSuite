//
//  NavigationRouter.swift
//  CritiCalUI
//
//  Created by Scott Matthewman on 22/09/2025.
//

import Foundation

@Observable
public class NavigationRouter: Sendable {
    private protocol TabRoute: Hashable {}

    public enum EventTabRoute: @MainActor TabRoute {
        case eventDetails(UUID)
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

    public var selectedTab: TabOption = .events
    public var eventsPath: [EventTabRoute] = []
    public var reviewsPath: [ReviewsTabRoute] = []

    public init() {
        self.selectedTab = .events
        self.eventsPath = []
        self.reviewsPath = []
    }

    public func navigateHome() {
        selectedTab = .home
    }

    public func navigate(toEvent eventID: UUID) {
        selectedTab = .events
        eventsPath = [.eventDetails(eventID)]
    }
}

