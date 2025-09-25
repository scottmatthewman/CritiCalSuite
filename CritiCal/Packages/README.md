# CritiCal Package Architecture

This document provides an overview of the modular Swift Package Manager (SPM) architecture used in the CritiCal application.

## Package Overview

The CritiCal application is built using a clean architecture pattern with separate Swift packages for different layers of functionality:

```
CritiCal App
├── CritiCalModels     (Core data models and detached types)
├── CritiCalDomain     (Repository protocols and contracts)
├── CritiCalStore      (SwiftData persistence implementation)
├── CritiCalUI         (SwiftUI presentation layer)
└── CritiCalIntents    (App Intents for system integration)
```

## Dependency Graph

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│   CritiCalApp   │     │  CritiCalUI     │     │ CritiCalIntents │
│  (Main Target)  │────▶│  (Presentation) │     │ (System Intents)│
└─────────────────┘     └─────────┬───────┘     └─────────┬───────┘
                                  │                       │
                        ┌─────────▼───────┐     ┌─────────▼───────┐
                        │ CritiCalDomain  │◀────│  CritiCalStore  │
                        │  (Protocols)    │     │ (Data Access)   │
                        └─────────┬───────┘     └─────────┬───────┘
                                  │                       │
                            ┌─────▼─────────────────────▼─────┐
                            │        CritiCalModels           │
                            │    (Core Data Models)           │
                            └─────────────────────────────────┘
```

## Package Responsibilities

### CritiCalModels
**Foundation Layer**
- SwiftData models (`Event`, `Genre`) for persistence
- Detached types (`DetachedEvent`, `DetachedGenre`) for actor boundary crossing
- Core enums (`ConfirmationStatus`) used across the application
- **Dependencies**: CritiCalExtensions (for color utilities)

### CritiCalDomain
**Contract Layer**
- Repository protocols (`EventReading`, `EventWriting`, `GenreReading`, `GenreWriting`)
- Legacy DTOs for backward compatibility during migration
- Defines contracts between UI/Intents and data persistence
- **Dependencies**: CritiCalModels, CritiCalExtensions

### CritiCalStore
**Data Persistence Layer**
- Repository implementations using SwiftData ModelActors
- CloudKit sync integration for data synchronization
- Time-based querying and search capabilities
- Thread-safe concurrent access patterns
- **Dependencies**: CritiCalDomain (protocols), CritiCalModels (data types)

### CritiCalUI
**Presentation Layer**
- Reusable SwiftUI components (`EventRow`, `EventListView`, `EventDetailView`)
- Styling utilities and custom label styles
- Preview support with mock repositories
- Direct SwiftData integration via `@Query`
- **Dependencies**: CritiCalDomain (protocols), CritiCalModels (data types)

### CritiCalIntents
**System Integration Layer**
- App Intents for Siri and Shortcuts integration
- Entity representations (`EventEntity`, `GenreEntity`)
- System-level event querying and display
- SwiftUI snippet views for intent results
- **Dependencies**: CritiCalDomain, CritiCalModels, CritiCalStore

## Key Architecture Patterns

### Repository Pattern
Clean separation between business logic and data access:
```swift
protocol EventReading {
    func recent(limit: Int) async throws -> [DetachedEvent]
}

@ModelActor
class EventRepository: EventReading {
    // SwiftData implementation
}
```

### Detached Event Architecture
Actor-safe data passing using detached copies:
```swift
// In ModelActor context
let event: Event = // SwiftData model
let detached = event.detached() // Safe to pass across actors

// Repository returns detached types
func recent(limit: Int) async throws -> [DetachedEvent]
```

### Dependency Injection
Repository access via environment and protocols:
```swift
@Environment(\.eventReader) private var reader
let events = try await reader.recent(limit: 10)
```

## Migration Strategy

The architecture supports gradual migration from DTOs to DetachedEvent types:

- **Legacy**: EventDTO ↔ EventEntity conversion for backward compatibility
- **Modern**: DetachedEvent ↔ EventEntity direct conversion
- **Preview Support**: Both patterns supported in SwiftUI previews

## Testing Architecture

Each package maintains comprehensive test coverage:
- **Unit Tests**: Repository operations, entity conversions, intent execution
- **Integration Tests**: Cross-package functionality and data flow
- **Mock Providers**: Isolated testing with fake repositories

This modular architecture enables:
- **Clear separation of concerns** across application layers
- **Independent development and testing** of each component
- **Flexible deployment** and feature development
- **Strong type safety** with Swift 6.2 concurrency compliance
- **Maintainable codebase** with explicit dependencies and contracts