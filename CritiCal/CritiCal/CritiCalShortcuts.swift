//
//  CritiCalShortcuts.swift
//  CritiCal
//
//  Created by Scott Matthewman on 18/09/2025.
//

import SwiftUI
import AppIntents
import CritiCalIntents

struct CritiCalShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: GetEventIntent(),
            phrases: ["Get \(.applicationName) event"],
            shortTitle: "Get Event",
            systemImageName: "calendar"
        )
        AppShortcut(
            intent: ListEventsIntent(),
            phrases: ["List \(.applicationName) events"],
            shortTitle: "List Events",
            systemImageName: "calendar"
        )
        AppShortcut(
            intent: OpenEventIntent(),
            phrases: ["Open \(.applicationName) event"],
            shortTitle: "Open Event",
            systemImageName: "arrow.up.forward.app"
        )
    }
}

