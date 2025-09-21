//
//  CritiCalApp.swift
//  CritiCal
//
//  Created by Scott Matthewman on 18/09/2025.
//

import AppIntents
import CritiCalIntents
import CritiCalStore
import CritiCalUI
import SwiftData
import SwiftUI

@main
struct CritiCalApp: App {
    @State private var container = try! StoreFactory.makeContainer(cloud: true)
    private var repo: EventRepository {
        EventRepository(modelContainer: container)
    }

    var body: some Scene {
        WindowGroup {
            AppRouter()
        }
        .environment(\.eventReader, repo)
        .environment(\.eventWriter, repo)
        .modelContainer(container)
        .handlesExternalEvents(matching: [OpenEventIntent.persistentIdentifier])
    }
}
