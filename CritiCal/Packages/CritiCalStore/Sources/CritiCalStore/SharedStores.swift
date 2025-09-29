//
//  SharedStores.swift
//  CritiCalStore
//
//  Manages shared ModelContainer instances for the app and extensions
//

import SwiftData
import Foundation
import CritiCalModels

/// Global actor to manage shared ModelContainer safely
@globalActor
public actor SharedStoresActor {
    public static let shared = SharedStoresActor()

    private var container: ModelContainer?

    private init() {}

    /// Set the container from the main app
    public func setContainer(_ container: ModelContainer) {
        self.container = container
    }

    /// Get or create the shared ModelContainer
    public func getContainer() async throws -> ModelContainer {
        if let container = container {
            return container
        }
        // Fallback: create container if not set by main app
        // This happens when App Intents run without the main app
        let newContainer = try StoreFactory.makeContainer(cloud: true)
        self.container = newContainer
        return newContainer
    }

    /// Reset container for testing purposes
    public func resetContainer() async {
        self.container = nil
    }
}

/// Protocol for providing event repository instances
public protocol EventRepositoryProviding: Sendable {
    nonisolated func eventRepo() async throws -> any EventReading & EventWriting
}

/// Thread-safe repository provider using actor-based container management
public struct SharedStores: EventRepositoryProviding, Sendable {

    /// Private initializer to enforce singleton pattern
    nonisolated private init() {}

    /// Factory method for creating shared instance
    nonisolated public static func defaultProvider() -> SharedStores {
        return SharedStores()
    }

    nonisolated public func eventRepo() async throws -> any EventReading & EventWriting {
        let container = try await SharedStoresActor.shared.getContainer()
        return EventRepository(modelContainer: container)
    }

    /// Legacy static method - guaranteed single container instance
    nonisolated public static func eventRepo() async throws -> EventRepository {
        let container = try await SharedStoresActor.shared.getContainer()
        return EventRepository(modelContainer: container)
    }
}