# CritiCalModels

Core data models and detached types for the CritiCal application.

## Overview

CritiCalModels contains the fundamental data structures used throughout the CritiCal app. This package serves as the **single source of truth** for data models and provides safe, Sendable types for crossing actor boundaries.

## Key Components

### SwiftData Models
- **`Event`**: Main event model with SwiftData persistence
- **`Genre`**: Genre categorization with color and symbol support
- **`ConfirmationStatus`**: Enum for event confirmation states

### Detached Types (Actor-Safe)
- **`DetachedEvent`**: Lightweight, Sendable copy of Event for actor boundary crossing
- **`DetachedGenre`**: Lightweight, Sendable copy of Genre for actor boundary crossing

These detached types enable safe data passing between SwiftData's ModelActor contexts and other parts of the app while maintaining strict Swift 6.2 concurrency compliance.

## Dependencies

```
CritiCalModels
└── CritiCalExtensions (Color utilities)
```

- **CritiCalExtensions**: Provides `Color(hex:)` extension for genre colors

## Architecture Role

CritiCalModels sits at the foundation of the app architecture:

```
┌─────────────────┐
│  CritiCalApp    │
└─────────┬───────┘
          │
    ┌─────▼─────┐     ┌──────────────┐     ┌─────────────┐
    │CritiCalUI │────▶│CritiCalStore │────▶│CritiCalModels│
    └───────────┘     └──────────────┘     └─────────────┘
                             │                      │
                      ┌──────▼──────┐               │
                      │CritiCalDomain│◀─────────────┘
                      └─────────────┘
```

## Usage Patterns

### Creating Detached Copies
```swift
// In a ModelActor context
let event: Event = // ... SwiftData model
let detachedEvent = event.detached() // Safe to pass across actors
```

### Repository Returns
Repository methods return detached types instead of SwiftData models:
```swift
func recent(limit: Int) async throws -> [DetachedEvent]
```

This design eliminates the need for DTO conversion while maintaining actor safety and performance.