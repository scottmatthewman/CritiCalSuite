# CritiCalIntents

App Intents implementation for Siri and Shortcuts integration.

## Overview

CritiCalIntents provides system-level integration for the CritiCal application through Apple's App Intents framework. This package enables users to interact with their events via Siri, Shortcuts app, and other system features, maintaining clean separation from data persistence while providing rich intent-based functionality.

## Key Components

### App Intents
- **`ListEventsIntent`**: Lists events within specified timeframes (today, past, future, etc.)
- **`GetEventIntent`**: Retrieves and displays specific events with validation
- **`ShowEventIntent`**: Shows event details in the main app
- **`OpenEventIntent`**: Opens event URLs in appropriate apps
- **`EventSnippetIntent`**: Provides compact event previews

### App Entities
- **`EventEntity`**: AppEntity representation of events with rich display properties
- **`GenreEntity`**: AppEntity for genre categorization with color support

### Entity Queries
- **`EventQuery`**: Handles event search, suggestions, and ID-based lookups
- **`GenreQuery`**: Manages genre entity resolution and suggestions

### Supporting Types
- **`EventTimeframe`**: Enumeration for time-based event filtering
- **`ConfirmationStatus`**: Event confirmation state for App Intents
- **`EventIntentError`**: Specialized error handling for intent operations

### UI Components
- **`EventSnippetView`**: SwiftUI view for displaying events in intent results

## Dependencies

```
CritiCalIntents
├── CritiCalDomain (Repository protocols, legacy DTOs)
├── CritiCalModels (DetachedEvent, DetachedGenre, ConfirmationStatus)
└── CritiCalStore (SharedStores for repository access)
```

- **CritiCalDomain**: Uses repository protocols for data access and EventDTO for backward compatibility
- **CritiCalModels**: Consumes DetachedEvent/DetachedGenre types from repositories
- **CritiCalStore**: Accesses SharedStores.defaultProvider() for repository instances

## Architecture Role

CritiCalIntents serves as the system integration layer:

```
┌─────────────────┐     ┌──────────────────┐     ┌─────────────────┐
│   Siri/Shortcuts│────▶│  CritiCalIntents │────▶│  CritiCalStore  │
│   (System UI)   │     │   (App Intents)  │     │ (Data Access)   │
└─────────────────┘     └─────────┬────────┘     └─────────────────┘
                                  │                        │
                          ┌───────▼────────┐      ┌────────▼────────┐
                          │ CritiCalDomain │      │  CritiCalModels │
                          │  (Protocols)   │      │  (Data Types)   │
                          └────────────────┘      └─────────────────┘
```

## Usage Patterns

### Intent Implementation
```swift
public struct ListEventsIntent: AppIntent {
    @Parameter(title: "Timeframe", default: .today) var timeframe: EventTimeframe

    public func perform() async throws -> some IntentResult & ReturnsValue<[EventEntity]> {
        let repo = try await repositoryProvider.eventRepo()
        let events = try await repo.eventsToday(in: .current, now: .now)
        return .result(value: events.map { EventEntity(from: $0) })
    }
}
```

### Entity Conversion
EventEntity supports both DetachedEvent and legacy EventDTO:
```swift
// Modern DetachedEvent conversion
let entity = EventEntity(from: detachedEvent)

// Legacy DTO support for backward compatibility
let entity = EventEntity(from: eventDTO)
```

### Repository Integration
```swift
public init() {
    self.repositoryProvider = SharedStores.defaultProvider()
}

let repo = try await repositoryProvider.eventRepo()
let events = try await repo.recent(limit: 10) // Returns [DetachedEvent]
```

### Testing Support
The package includes comprehensive test coverage (47 tests) validating:
- Intent execution and parameter handling
- Entity query functionality and search
- Repository integration and error handling
- Entity conversion accuracy
- Mock repository providers for isolated testing

### Swift Concurrency Integration
All intents and entities are Sendable-compliant and use modern Swift concurrency patterns with MainActor isolation where appropriate, ensuring safe operation within the App Intents framework.

This design provides seamless system integration while maintaining the clean architecture established by the repository pattern and DetachedEvent types.