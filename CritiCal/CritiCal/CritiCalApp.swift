//
//  CritiCalApp.swift
//  CritiCal
//
//  Created by Scott Matthewman on 18/09/2025.
//

import AppIntents
import CritiCalIntents
import CritiCalNavigation
import CritiCalStore
import CritiCalUI
import SwiftData
import SwiftUI

@main
struct CritiCalApp: App {
    let container: ModelContainer
    let repo: EventRepository
    let genreRepo: GenreRepository
    let router: NavigationRouter = NavigationRouter()

    init() {
        do {
            container = try StoreFactory.makeContainer(cloud: true)
            repo = EventRepository(modelContainer: container)
            genreRepo = GenreRepository(modelContainer: container)

            // Share the container with App Intents
            let containerToShare = container
            Task {
                await SharedStoresActor.shared.setContainer(containerToShare)
            }
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            AppRouter()
        }
        .environment(router)
        .environment(\.eventReader, repo)
        .environment(\.eventWriter, repo)
        .environment(\.genreReader, genreRepo)
        .environment(\.genreWriter, genreRepo)
        .modelContainer(container)
        .handlesExternalEvents(matching: [OpenEventIntent.persistentIdentifier])
    }
}
