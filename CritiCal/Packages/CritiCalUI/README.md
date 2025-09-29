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

## Dependencies

```
CritiCalUI
└── CritiCalModels (Repository protocols, DetachedEvent, DetachedGenre types)
```

- **CritiCalModels**: Uses repository protocols and DetachedEvent/DetachedGenre types

## Architecture Role

CritiCalUI serves as the presentation layer in the clean architecture:

```
┌─────────────────┐
│   CritiCalApp   │ (Main app target)
└────────┬────────┘
         │
    ┌────▼────┐     ┌─────────────┐
    │CritiCalUI│────▶│CritiCalStore│
    │(Views)  │     │(Data Layer) │
    └─────┬───┘     └──────┬──────┘
          │                │
          └────────┬───────┘
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
    let event = DetachedEvent(
        id: UUID(),
        title: "Sample Event",
        date: .now,
        // ... other properties
    )
    let reader = FakeEventsReader(events: [event])

    EventDetailView(id: event.id)
        .environment(\.eventReader, reader)
}
```