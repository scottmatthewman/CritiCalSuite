# CritiCalUI

Reusable SwiftUI components and views for the CritiCal application.

## Overview

CritiCalUI provides the presentation layer components for the CritiCal app. It contains reusable SwiftUI views, styling utilities, and preview helpers that work seamlessly with the DetachedEvent architecture while maintaining clean separation from data persistence concerns.

## Key Components

### Core UI Components
- **`EventRow`**: Displays event information in list contexts
- **`EventListView`**: Complete event listing with @Query integration
- **`EventDetailView`**: Detailed event information view
- **`HomeView`**: Main application dashboard

### Styling & Utilities
- **`TintedIconLabelStyle`**: Custom label styling
- **`TagLabelStyle`**: Tag-based UI styling
- **`URL+Display`**: URL display utilities

### Preview & Testing Utilities
- **`FakeEventsReader`**: Mock EventReading implementation for previews
- **`FakeGenresReader`**: Mock GenreReading implementation for previews
- **Conversion Extensions**: EventDTO ↔ DetachedEvent helpers for preview data

## Dependencies

```
CritiCalUI
├── CritiCalDomain (Repository protocols, legacy DTOs)
└── CritiCalModels (DetachedEvent, DetachedGenre types)
```

- **CritiCalDomain**: Uses repository protocols and legacy DTOs for preview data
- **CritiCalModels**: Directly uses DetachedEvent/DetachedGenre and Event/Genre models

## Architecture Role

CritiCalUI serves as the presentation layer in the clean architecture:

```
┌─────────────────┐
│   CritiCalApp   │ (Main app target)
└────────┬────────┘
         │
    ┌────▼────┐     ┌──────────────┐     ┌─────────────┐
    │CritiCalUI│────▶│CritiCalDomain│────▶│CritiCalStore│
    │(Views)  │     │ (Protocols)  │     │(Data Layer) │
    └─────────┘     └──────────────┘     └─────────────┘
         │                  │                     │
         └──────────────────┼─────────────────────┘
                            │
                    ┌───────▼────────┐
                    │ CritiCalModels │
                    │ (Data Models)  │
                    └────────────────┘
```

## Usage Patterns

### Direct SwiftData Integration
Views can work directly with SwiftData models using @Query:
```swift
@Query(sort: \Event.date, order: .reverse) private var events: [Event]

List(events) { event in
    EventRow(event: event.detached()) // Convert to actor-safe type
}
```

### Repository-Based Data Access
For more complex data access, views use repository protocols:
```swift
@Environment(\.eventReader) private var reader

let events = try await reader.recent(limit: 10) // Returns [DetachedEvent]
```

### Preview Support
The package includes comprehensive preview support:
```swift
#Preview {
    let dto = EventDTO(title: "Sample Event", ...)
    let reader = FakeEventsReader(events: [DetachedEvent(eventDTO: dto)])

    EventDetailView(id: dto.id)
        .environment(\.eventReader, reader)
}
```

### Migration Support
The package supports both legacy DTOs and modern DetachedEvent types through conversion utilities, enabling gradual migration while maintaining preview functionality.