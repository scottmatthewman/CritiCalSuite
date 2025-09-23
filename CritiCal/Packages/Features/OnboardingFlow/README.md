# OnboardingFlow

A self-contained, versioned onboarding flow package for SwiftUI applications.

## Features

- ✅ **Version tracking**: Only shows onboarding when the version is newer than what the user has seen
- ✅ **Persistent state**: Remembers completed onboarding across app launches
- ✅ **Customizable pages**: Easy to define custom onboarding content
- ✅ **Platform support**: Works on both iOS and macOS
- ✅ **SwiftUI native**: Built with modern SwiftUI patterns

## Usage

### Basic Integration

Add the onboarding flow to your app's main view:

```swift
import OnboardingFlow

struct ContentView: View {
    var body: some View {
        YourMainView()
            .onboardingFlow()
    }
}
```

### Custom Pages

Provide custom onboarding pages:

```swift
let customPages = [
    OnboardingPage(
        title: "Welcome",
        description: "Welcome to our app!",
        systemImage: "hand.wave",
        imageColor: .blue
    ),
    OnboardingPage(
        title: "Features",
        description: "Discover amazing features",
        systemImage: "star.fill",
        imageColor: .yellow
    )
]

OnboardingFlowView(pages: customPages) {
    // Completion handler
}
```

### Version Management

When you want to show onboarding again to existing users (e.g., for new features), increment the version number in `OnboardingVersion.swift`:

```swift
public static let current = OnboardingVersion(version: 2) // Increment this
```

### Testing

Reset onboarding for testing:

```swift
let settings = OnboardingSettings()
settings.resetOnboarding()
```

## Architecture

- **OnboardingVersion**: Tracks the version number and handles comparisons
- **OnboardingSettings**: Manages persistence using UserDefaults
- **OnboardingPage**: Data model for individual onboarding screens
- **OnboardingFlowView**: Main coordinator view that displays the flow
- **OnboardingFlowModifier**: View modifier for easy integration

## Requirements

- iOS 18.0+ / macOS 15.0+
- Swift 6.0+