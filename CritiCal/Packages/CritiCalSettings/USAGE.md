# CritiCalSettings Usage Guide

## Overview

CritiCalSettings wraps the Defaults library with clean SwiftUI property wrappers and provides separate read-only and read-write access to app settings.

## Architecture

- **Property Wrappers**: Clean SwiftUI syntax for reactive settings
- **Protocols**: `SettingsReadable` (read-only) and `SettingsWritable` (read-write) for dependency injection
- **Concrete Classes**: `AppSettingsReader`, `AppSettingsWriter`, `MockSettingsWriter` for different use cases

## Usage in SwiftUI Views

### Read-Only Access (Most Views)

Use `@ReadOnlySetting` for views that should only read settings:

```swift
import SwiftUI
import MapKit
import CritiCalSettings

struct MapView: View {
    @ReadOnlySetting(.preferredTransitMode) var transitMode

    var body: some View {
        Map {
            // Use transitMode reactively
        }
    }

    func requestDirections() {
        // Convert to MapKit type
        let mkType = transitMode.mapKitTransportType

        let request = MKDirections.Request()
        request.transportType = mkType
        // ...
    }
}
```

### Read-Write Access (Settings Views)

Use `@Setting` for views that need to modify settings:

```swift
import SwiftUI
import CritiCalSettings

struct SettingsView: View {
    @Setting(.preferredTransitMode) var transitMode

    var body: some View {
        Picker("Transit Mode", selection: $transitMode) {
            ForEach(TransitMode.allCases, id: \.self) { mode in
                Label(mode.displayName, systemImage: mode.symbolName)
                    .tag(mode)
            }
        }
    }
}
```

## Usage in Non-SwiftUI Code

For business logic or other non-SwiftUI code, use the protocols:

```swift
import CritiCalSettings

class RouteCalculator {
    private let settings: SettingsReadable

    init(settings: SettingsReadable = AppSettingsReader.shared) {
        self.settings = settings
    }

    func calculateRoute() {
        let mode = settings.preferredTransitMode
        // Use mode for calculations
    }
}
```

## Testing

Use `MockSettingsWriter` for testing:

```swift
import Testing
import CritiCalSettings

@Test func testRouteWithCycling() {
    let suite = UserDefaults(suiteName: "test.routing")!
    defer { suite.removePersistentDomain(forName: "test.routing") }

    let mockSettings = MockSettingsWriter(suite: suite)
    mockSettings.setPreferredTransitMode(.cycling)

    let calculator = RouteCalculator(settings: mockSettings)
    // Test with cycling mode
}
```

## Available Settings

### Transit Mode
- **Key**: `.preferredTransitMode`
- **Type**: `TransitMode`
- **Default**: `.publicTransit`
- **Values**: `.publicTransit`, `.walking`, `.car`, `.cycling`
- **Helpers**:
  - `displayName: String` - Human-readable name
  - `symbolName: String` - SF Symbol name
  - `mapKitTransportType: MKDirectionsTransportType` - MapKit conversion

### Onboarding Version
- **Protocol access**: `completedOnboardingVersionNumber: Int?`
- **Used internally by OnboardingFlow package**

## Adding New Settings

1. Add enum/type to CritiCalSettings (if needed)
2. Add `Defaults.Key` in `SettingsKeys.swift`
3. Add getter to `SettingsReadable` protocol
4. Add setter to `SettingsWritable` protocol (if writable)
5. Implement in `AppSettingsReader`, `AppSettingsWriter`, and `MockSettingsWriter`
6. Create UI in AppSettings using `@Setting`
7. Use in other packages with `@ReadOnlySetting`
