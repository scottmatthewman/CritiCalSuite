//
//  StoreFactoryTests.swift
//  CritiCalStoreTests
//
//  Created by Claude on 20/09/2025.
//

import Testing
import SwiftData
import Foundation
import CritiCalModels
@testable import CritiCalStore

@Suite("StoreFactory - Container Creation")
struct StoreFactoryContainerTests {

    @Test("StoreFactory creates in-memory ModelContainer for testing")
    func testInMemoryContainerCreation() throws {
        let container = try StoreFactory.makeContainer(cloud: false, inMemory: true)

        #expect(container.schema.entities.count == 2)
        #expect(container.schema.entities.contains { $0.name == "Event" })
    }

    @Test("StoreFactory creates ModelContainer with CloudKit enabled")
    func testContainerWithCloudKit() throws {
        let container = try StoreFactory.makeContainer(cloud: true, inMemory: true)

        #expect(container.schema.entities.count == 2)
        #expect(container.schema.entities.contains { $0.name == "Event" })
    }

    @Test("StoreFactory creates ModelContainer with CloudKit disabled")
    func testContainerWithoutCloudKit() throws {
        let container = try StoreFactory.makeContainer(cloud: false, inMemory: true)

        #expect(container.schema.entities.count == 2)
        #expect(container.schema.entities.contains { $0.name == "Event" })
    }

    @Test("StoreFactory creates ModelContainer with default CloudKit setting")
    func testContainerWithDefaultCloudKit() throws {
        let container = try StoreFactory.makeContainer(inMemory: true)

        #expect(container.schema.entities.count == 2)
        #expect(container.schema.entities.contains { $0.name == "Event" })
    }

    @Test("StoreFactory container has correct schema configuration")
    func testContainerSchemaConfiguration() throws {
        let container = try StoreFactory.makeContainer(cloud: false, inMemory: true)

        // Verify Event entity is properly configured
        let eventEntity = container.schema.entities.first { $0.name == "Event" }
        #expect(eventEntity != nil)

        // Verify entity has expected properties
        let properties = eventEntity?.properties
        #expect(properties?.contains { $0.name == "identifier" } == true)
        #expect(properties?.contains { $0.name == "title" } == true)
        #expect(properties?.contains { $0.name == "date" } == true)
        #expect(properties?.contains { $0.name == "venueName" } == true)
    }

    @Test("StoreFactory can create multiple containers independently")
    func testMultipleContainerCreation() throws {
        let container1 = try StoreFactory.makeContainer(cloud: false, inMemory: true)
        let container2 = try StoreFactory.makeContainer(cloud: true, inMemory: true)

        // Should be different instances
        #expect(container1 !== container2)

        // But should have the same schema
        #expect(container1.schema.entities.count == container2.schema.entities.count)
        #expect(container1.schema.entities.first?.name == container2.schema.entities.first?.name)
    }

    @Test("StoreFactory respects inMemory parameter")
    func testInMemoryParameter() throws {
        // Test that inMemory parameter works correctly
        let memoryContainer = try StoreFactory.makeContainer(cloud: false, inMemory: true)
        let diskContainer = try StoreFactory.makeContainer(cloud: false, inMemory: false)

        // Both should have the same schema
        #expect(memoryContainer.schema.entities.count == diskContainer.schema.entities.count)
        #expect(memoryContainer.schema.entities.first?.name == diskContainer.schema.entities.first?.name)
    }
}

@Suite("StoreFactory - EventRepository Creation")
struct StoreFactoryEventRepositoryTests {

    @Test("StoreFactory creates in-memory EventRepository for testing")
    func testInMemoryEventRepositoryCreation() throws {
        let repository = try StoreFactory.makeEventRepository(cloud: false, inMemory: true)

        #expect(type(of: repository) == EventRepository.self)
    }

    @Test("StoreFactory creates EventRepository with CloudKit enabled")
    func testEventRepositoryWithCloudKit() throws {
        let repository = try StoreFactory.makeEventRepository(cloud: true, inMemory: true)

        #expect(type(of: repository) == EventRepository.self)
    }

    @Test("StoreFactory creates EventRepository with CloudKit disabled")
    func testEventRepositoryWithoutCloudKit() throws {
        let repository = try StoreFactory.makeEventRepository(cloud: false, inMemory: true)

        #expect(type(of: repository) == EventRepository.self)
    }

    @Test("StoreFactory creates EventRepository with default CloudKit setting")
    func testEventRepositoryWithDefaultCloudKit() throws {
        let repository = try StoreFactory.makeEventRepository(inMemory: true)

        #expect(type(of: repository) == EventRepository.self)
    }

    @Test("StoreFactory EventRepository conforms to protocols")
    func testEventRepositoryProtocolConformance() throws {
        let repository = try StoreFactory.makeEventRepository(cloud: false, inMemory: true)

        // Verify protocol conformance
        let _: any EventReading = repository
        let _: any EventWriting = repository
        #expect(Bool(true)) // If it compiles, the protocols are implemented
    }

    @Test("StoreFactory can create multiple repositories independently")
    func testMultipleRepositoryCreation() throws {
        let repository1 = try StoreFactory.makeEventRepository(cloud: false, inMemory: true)
        let repository2 = try StoreFactory.makeEventRepository(cloud: false, inMemory: true)

        #expect(type(of: repository1) == EventRepository.self)
        #expect(type(of: repository2) == EventRepository.self)

        // Should be different actor instances
        #expect(repository1 !== repository2)
    }

    @Test("StoreFactory EventRepository can perform basic operations")
    func testEventRepositoryBasicFunctionality() async throws {
        let repository = try StoreFactory.makeEventRepository(cloud: false, inMemory: true)

        // Test that basic operations work (this ensures the repository is properly initialized)
        let events = try await repository.recent(limit: 10)
        #expect(events.isEmpty) // Should start empty

        // Test search functionality
        let searchResults = try await repository.search(text: "test", limit: 10)
        #expect(searchResults.isEmpty) // Should start empty
    }

    @Test("StoreFactory repository respects inMemory parameter")
    func testRepositoryInMemoryParameter() async throws {
        // Both should work correctly, but inMemory should be used for tests
        let memoryRepository = try StoreFactory.makeEventRepository(cloud: false, inMemory: true)
        let diskRepository = try StoreFactory.makeEventRepository(cloud: false, inMemory: false)

        // Both should be functional
        let memoryEvents = try await memoryRepository.recent(limit: 10)
        let diskEvents = try await diskRepository.recent(limit: 10)

        #expect(memoryEvents.isEmpty)
        #expect(diskEvents.isEmpty)
    }
}

@Suite("StoreFactory - Error Handling")
struct StoreFactoryErrorTests {

    @Test("StoreFactory container creation is consistent")
    func testContainerCreationConsistency() throws {
        // Create multiple containers with same configuration
        let container1 = try StoreFactory.makeContainer(cloud: false, inMemory: true)
        let container2 = try StoreFactory.makeContainer(cloud: false, inMemory: true)

        // Should have identical schemas
        #expect(container1.schema.entities.count == container2.schema.entities.count)

        let entity1 = container1.schema.entities.first { $0.name == "Event" }
        let entity2 = container2.schema.entities.first { $0.name == "Event" }

        #expect(entity1?.name == entity2?.name)
        #expect(entity1?.properties.count == entity2?.properties.count)
    }

    @Test("StoreFactory repository creation is consistent")
    func testRepositoryCreationConsistency() async throws {
        // Create multiple repositories with same configuration
        let repository1 = try StoreFactory.makeEventRepository(cloud: false, inMemory: true)
        let repository2 = try StoreFactory.makeEventRepository(cloud: false, inMemory: true)

        // Both should work identically
        let events1 = try await repository1.recent(limit: 10)
        let events2 = try await repository2.recent(limit: 10)

        #expect(events1.count == events2.count) // Both should be empty initially
        #expect(events1.isEmpty && events2.isEmpty)
    }

    @Test("StoreFactory handles CloudKit configuration correctly")
    func testCloudKitConfiguration() throws {
        // Test that different CloudKit settings create valid containers
        let cloudContainer = try StoreFactory.makeContainer(cloud: true, inMemory: true)
        let localContainer = try StoreFactory.makeContainer(cloud: false, inMemory: true)

        // Both should have the same schema regardless of CloudKit setting
        #expect(cloudContainer.schema.entities.count == localContainer.schema.entities.count)
        #expect(cloudContainer.schema.entities.first?.name == localContainer.schema.entities.first?.name)
    }

    @Test("StoreFactory handles parameter combinations correctly")
    func testParameterCombinations() throws {
        // Test all valid parameter combinations
        let cloudMemory = try StoreFactory.makeContainer(cloud: true, inMemory: true)
        let cloudDisk = try StoreFactory.makeContainer(cloud: true, inMemory: false)
        let localMemory = try StoreFactory.makeContainer(cloud: false, inMemory: true)
        let localDisk = try StoreFactory.makeContainer(cloud: false, inMemory: false)

        // All should have the same schema
        let containers = [cloudMemory, cloudDisk, localMemory, localDisk]
        for container in containers {
            #expect(container.schema.entities.count == 2)
            #expect(container.schema.entities.first?.name == "Event")
        }
    }
}

@Suite("StoreFactory - Integration")
struct StoreFactoryIntegrationTests {

    @Test("StoreFactory repository can create and retrieve events")
    func testRepositoryEventOperations() async throws {
        let repository = try StoreFactory.makeEventRepository(cloud: false, inMemory: true)

        // Create an event
        let eventID = try await repository.create(
            title: "Factory Test Event",
            festivalName: "Factory Test Festival",
            venueName: "Factory Test Venue",
            date: Date.now,
            details: ""
        )

        // Retrieve the event
        let retrievedEvent = try await repository.event(byIdentifier: eventID)

        #expect(retrievedEvent != nil)
        #expect(retrievedEvent?.id == eventID)
        #expect(retrievedEvent?.title == "Factory Test Event")
        #expect(retrievedEvent?.festivalName == "Factory Test Festival")
        #expect(retrievedEvent?.venueName == "Factory Test Venue")
    }

    @Test("StoreFactory repository maintains data across operations")
    func testRepositoryDataPersistence() async throws {
        let repository = try StoreFactory.makeEventRepository(cloud: false, inMemory: true)

        // Create multiple events
        let event1ID = try await repository.create(
            title: "Event 1",
            festivalName: "",
            venueName: "Venue 1",
            date: Date.now,
            details: ""
        )
        let event2ID = try await repository.create(
            title: "Event 2",
            festivalName: "",
            venueName: "Venue 2",
            date: Date.now.addingTimeInterval(3600),
            details: ""
        )

        // Verify both events exist
        let event1 = try await repository.event(byIdentifier: event1ID)
        let event2 = try await repository.event(byIdentifier: event2ID)

        #expect(event1?.title == "Event 1")
        #expect(event2?.title == "Event 2")

        // Verify recent events include both
        let recentEvents = try await repository.recent(limit: 10)
        #expect(recentEvents.count == 2)
    }

    @Test("StoreFactory repository handles concurrent access")
    func testRepositoryConcurrentAccess() async throws {
        let repository = try StoreFactory.makeEventRepository(cloud: false, inMemory: true)

        // Perform concurrent operations
        await withTaskGroup(of: UUID?.self) { group in
            for i in 0..<5 {
                group.addTask {
                    try? await repository.create(
                        title: "Concurrent Event \(i)",
                        festivalName: "Concurrent Festival",
                        venueName: "Venue \(i)",
                        date: Date.now.addingTimeInterval(Double(i) * 3600),
                        details: ""
                    )
                }
            }

            var createdIDs: [UUID] = []
            for await id in group {
                if let id = id {
                    createdIDs.append(id)
                }
            }

            #expect(createdIDs.count == 5)
        }

        // Verify all events were created
        let allEvents = try await repository.recent(limit: 10)
        #expect(allEvents.count == 5)
    }

    @Test("StoreFactory ensures in-memory isolation between repositories")
    func testInMemoryIsolation() async throws {
        // Create two separate in-memory repositories
        let repository1 = try StoreFactory.makeEventRepository(cloud: false, inMemory: true)
        let repository2 = try StoreFactory.makeEventRepository(cloud: false, inMemory: true)

        // Add event to repository1
        let event1ID = try await repository1.create(
            title: "Repository 1 Event",
            festivalName: "Festival 1",
            venueName: "Venue 1",
            date: Date.now,
            details: ""
        )

        // Add event to repository2
        let event2ID = try await repository2.create(
            title: "Repository 2 Event",
            festivalName: "Festival 2",
            venueName: "Venue 2",
            date: Date.now,
            details: ""
        )

        // Each repository should only see its own events
        let repo1Events = try await repository1.recent(limit: 10)
        let repo2Events = try await repository2.recent(limit: 10)

        #expect(repo1Events.count == 1)
        #expect(repo2Events.count == 1)
        #expect(repo1Events[0].title == "Repository 1 Event")
        #expect(repo2Events[0].title == "Repository 2 Event")

        // Cross-repository lookups should fail
        let repo1LookupRepo2Event = try await repository1.event(byIdentifier: event2ID)
        let repo2LookupRepo1Event = try await repository2.event(byIdentifier: event1ID)

        #expect(repo1LookupRepo2Event == nil)
        #expect(repo2LookupRepo1Event == nil)
    }

    @Test("StoreFactory repository supports full CRUD operations")
    func testRepositoryFullCRUD() async throws {
        let repository = try StoreFactory.makeEventRepository(cloud: false, inMemory: true)

        // Create
        let eventID = try await repository.create(
            title: "CRUD Test Event",
            festivalName: "CRUD Festival",
            venueName: "CRUD Venue",
            date: Date.now,
            details: ""
        )

        // Read
        let createdEvent = try await repository.event(byIdentifier: eventID)
        #expect(createdEvent?.title == "CRUD Test Event")

        // Update
        try await repository.update(
            eventID: eventID,
            title: "Updated CRUD Event",
            festivalName: "Updated CRUD Festival",
            venueName: "Updated CRUD Venue",
            date: nil,
            durationMinutes: nil,
            confirmationStatus: nil,
            url: nil,
            details: nil
        )

        let updatedEvent = try await repository.event(byIdentifier: eventID)
        #expect(updatedEvent?.title == "Updated CRUD Event")
        #expect(updatedEvent?.festivalName == "Updated CRUD Festival")
        #expect(updatedEvent?.venueName == "Updated CRUD Venue")

        // Delete
        try await repository.delete(eventID: eventID)

        let deletedEvent = try await repository.event(byIdentifier: eventID)
        #expect(deletedEvent == nil)
    }
}
