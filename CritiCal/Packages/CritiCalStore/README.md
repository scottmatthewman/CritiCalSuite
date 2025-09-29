# CritiCalStore

Data persistence layer using SwiftData with ModelActor architecture.

## Overview

CritiCalStore implements the data access layer for the CritiCal application. It provides SwiftData-backed repositories that implement the CritiCalDomain protocols, ensuring clean separation between business logic and data persistence.

## Key Components

### Repository Implementations
- **`EventRepository`**: SwiftData ModelActor implementing EventReading & EventWriting
- **`GenreRepository`**: SwiftData ModelActor implementing GenreReading & GenreWriting

### Infrastructure
- **`StoreFactory`**: Creates ModelContainer instances with CloudKit sync support
- **`SharedStores`**: Provides singleton access to repository instances
- **`SampleDataProvider`**: Development and testing data utilities

### Repository Features
- **Concurrent Access**: ModelActor-based for safe concurrent operations
- **CloudKit Sync**: Built-in CloudKit integration for data synchronization
- **Time-based Queries**: Optimized queries for today, past, future events
- **Search Capabilities**: Full-text search across event properties

## Dependencies

```
CritiCalStore
└── CritiCalModels (Repository protocols, Event, Genre, DetachedEvent, DetachedGenre)
```

- **CritiCalModels**: Implements EventReading/EventWriting and GenreReading/GenreWriting protocols; uses Event/Genre SwiftData models and returns DetachedEvent/DetachedGenre types

## Architecture Role

CritiCalStore serves as the data persistence implementation:

```
┌─────────────────┐     ┌─────────────────┐
│   UI/Intents    │────▶│  CritiCalStore  │
│   (Consumers)   │     │ (Implementation)│
└─────────────────┘     └─────────┬───────┘
                                  │
                         ┌────────▼────────┐
                         │ CritiCalModels  │
                         │   (Protocols)   │
                         └────────┬────────┘
                                  │
                         ┌────────▼────────┐
                         │   SwiftData     │
                         │ + CloudKit Sync │
                         └─────────────────┘
```

## Usage Patterns

### Repository Access
```swift
let repository = try await StoreFactory.makeEventRepository()
let events = try await repository.recent(limit: 10) // Returns [DetachedEvent]
```

### ModelActor Safety
All repository operations run within ModelActor contexts, ensuring thread safety:
```swift
@ModelActor
public actor EventRepository: EventReading & EventWriting {
    public func recent(limit: Int) async throws -> [DetachedEvent] {
        // Safe SwiftData operations
        let entries = try modelContext.fetch(fetchDescriptor)
        return entries.map { $0.detached() } // Actor-safe detached copies
    }
}
```

### Testing Support
The package includes comprehensive test coverage (52 tests) validating:
- Repository CRUD operations
- Time-based querying
- Search functionality
- Error handling
- Data conversion accuracy

This design eliminates DTO conversion overhead while maintaining strict concurrency safety and CloudKit integration.