# CritiCalDomain

Domain protocols and transfer objects for the CritiCal application.

## Overview

CritiCalDomain defines the contracts and interfaces that separate the business logic from implementation details. It provides protocol definitions for data access and legacy DTOs for backward compatibility during the migration to DetachedEvent architecture.

## Key Components

### Repository Protocols
- **`EventReading`**: Protocol for reading event data (returns `DetachedEvent`)
- **`EventWriting`**: Protocol for creating/updating/deleting events
- **`GenreReading`**: Protocol for reading genre data (returns `DetachedGenre`)
- **`GenreWriting`**: Protocol for creating/updating/deleting genres

### Legacy DTOs (Backward Compatibility)
- **`EventDTO`**: Legacy data transfer object for events
- **`GenreDTO`**: Legacy data transfer object for genres

### Compatibility Layer
- **`ConfirmationStatus`**: Re-exports from CritiCalModels for seamless migration

## Dependencies

```
CritiCalDomain
├── CritiCalModels (DetachedEvent, DetachedGenre, ConfirmationStatus)
└── CritiCalExtensions (Color utilities for GenreDTO)
```

- **CritiCalModels**: Provides DetachedEvent/DetachedGenre types used in protocols
- **CritiCalExtensions**: Enables `GenreDTO.color` computed property

## Architecture Role

CritiCalDomain acts as the contract layer between UI/Intents and the data store:

```
┌─────────────┐     ┌─────────────────┐     ┌──────────────┐
│ CritiCalUI  │────▶│ CritiCalDomain  │◀────│CritiCalStore │
└─────────────┘     │   (Protocols)   │     └──────────────┘
                    └─────────────────┘
                            │
                    ┌───────▼────────┐
                    │ CritiCalModels │
                    │  (Data Types)  │
                    └────────────────┘
```

## Migration Strategy

The package supports both new and legacy patterns:

### Modern Pattern (DetachedEvent)
```swift
protocol EventReading: Sendable {
    func recent(limit: Int) async throws -> [DetachedEvent]
    func event(byIdentifier id: UUID) async throws -> DetachedEvent?
}
```

### Legacy Pattern (EventDTO)
```swift
// Still supported for existing code
let entity = EventEntity(from: eventDTO) // Backward compatible
```

This dual approach enables gradual migration while maintaining clean architecture principles.