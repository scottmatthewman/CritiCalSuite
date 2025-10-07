//
//  StoreFactory.swift
//  CritiCalStore
//
//  Created by Scott Matthewman on 18/09/2025.
//

import SwiftData
import Foundation
import CritiCalModels

public enum StoreFactory {
    public static func makeContainer(cloud: Bool = true, inMemory: Bool = false) throws -> ModelContainer {
        let schema = Schema([Event.self, Genre.self])

        let config: ModelConfiguration

        if inMemory {
            config = ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: true
            )
        } else {
            guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.app.strangemagic.CritiCal") else {
                fatalError("Could not get group container URL")
            }
            let storeURL = containerURL.appendingPathComponent("default.store")
            config = ModelConfiguration(url: storeURL)
        }

        return try ModelContainer(for: schema, configurations: config)
    }

    public static func makeEventRepository(cloud: Bool = true, inMemory: Bool = false) throws -> EventRepository {
        let container = try makeContainer(cloud: cloud, inMemory: inMemory)
        return EventRepository(modelContainer: container)
    }
}
