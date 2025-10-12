# CritiCalSettings

A type-safe settings wrapper for the CritiCal app, built on [Defaults](https://github.com/sindresorhus/Defaults).

## Features

- **Clean SwiftUI API**: Property wrappers for reactive settings (`@ReadOnlySetting`, `@Setting`)
- **Compile-time Safety**: Separate read-only and read-write access
- **Testable**: Mock implementations for unit testing
- **Type-safe**: All settings are strongly typed with Swift enums and structs

## Quick Start

### Read-Only Access (Most Views)

```swift
import SwiftUI
import CritiCalSettings

struct MapView: View {
    @ReadOnlySetting(.preferredTransitMode) var transitMode

    var body: some View {
        Text("Using \(transitMode.displayName)")
    }
}
```

### Read-Write Access (Settings Views)

```swift
import SwiftUI
import CritiCalSettings

struct SettingsView: View {
    @Setting(.preferredTransitMode) var transitMode

    var body: some View {
        Picker("Transit Mode", selection: $transitMode) {
            ForEach(TransitMode.allCases, id: \.self) { mode in
                Text(mode.displayName).tag(mode)
            }
        }
    }
}
```

## Architecture

### Property Wrappers

- **`@ReadOnlySetting`**: For views that only read settings (reactive, no setter)
- **`@Setting`**: For settings UI (reactive, provides binding via `$` projection)

### Protocols

- **`SettingsReadable`**: Read-only protocol for dependency injection
- **`SettingsWritable`**: Read-write protocol (includes `SettingsReadable`)

### Implementations

- **`AppSettingsReader.shared`**: Singleton for read-only access
- **`AppSettingsWriter.shared`**: Singleton for read-write access
- **`MockSettingsWriter`**: Injectable mock for testing

## Available Settings

### Transit Mode

```swift
@ReadOnlySetting(.preferredTransitMode) var transitMode: TransitMode
```

**Type**: `TransitMode` enum
**Values**: `.publicTransit`, `.walking`, `.car`, `.cycling`
**Default**: `.publicTransit`

**Helpers**:
- `displayName: String` - Human-readable name
- `symbolName: String` - SF Symbol name
- `mapKitTransportType: MKDirectionsTransportType` - MapKit conversion

## Testing

```swift
import Testing
import CritiCalSettings

@Test func testWithCustomTransitMode() {
    let suite = UserDefaults(suiteName: "test.mytest")!
    defer { suite.removePersistentDomain(forName: "test.mytest") }

    let mockSettings = MockSettingsWriter(suite: suite)
    mockSettings.setPreferredTransitMode(.cycling)

    // Use mockSettings in your code
}
```

## Adding New Settings

See [USAGE.md](./USAGE.md) for detailed instructions on adding new settings.
