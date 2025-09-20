//
//  SharedStores.swift
//  CritiCalStore
//
//  Created by Scott Matthewman on 18/09/2025.
//

import SwiftData
import CritiCalStore

struct SharedStores {
    private static var container: ModelContainer?

    static func eventRepo() async throws -> EventRepository {
        if let container {
            return EventRepository(modelContainer: container)
        }
        let newContainer = try StoreFactory.makeContainer(cloud: true)
        self.container = newContainer

        return EventRepository(modelContainer: newContainer)
    }
}
