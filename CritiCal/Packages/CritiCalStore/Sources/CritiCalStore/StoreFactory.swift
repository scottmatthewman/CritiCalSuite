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
    public static func makeContainer(cloud: Bool = true) throws -> ModelContainer {
        let schema = Schema([Event.self])
        let config = ModelConfiguration(
            schema: schema,
            cloudKitDatabase: cloud ? .automatic : .none
        )
        return try ModelContainer(for: schema, configurations: config)
    }

    public static func makeEventRepository(cloud: Bool = true) throws -> EventRepository {
        let container = try makeContainer(cloud: cloud)
        return EventRepository(modelContainer: container)
    }
}
