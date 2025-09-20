//
//  CritiCalApp.swift
//  CritiCal
//
//  Created by Scott Matthewman on 18/09/2025.
//

import SwiftUI
import SwiftData
import CritiCalStore

@main
struct CritiCalApp: App {
    var container: ModelContainer {
        do {
            return try StoreFactory.makeContainer(cloud: true)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
    }
}
