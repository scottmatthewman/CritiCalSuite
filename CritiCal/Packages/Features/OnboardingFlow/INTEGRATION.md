# OnboardingFlow Integration Instructions

## Adding the Package to Your Xcode Project

Since OnboardingFlow is a local Swift package, you need to add it to your Xcode workspace:

### Steps:

1. **Open your Xcode workspace** (`CritiCal.xcworkspace`)

2. **Add the package**:
   - In Xcode, go to File → Add Package Dependencies...
   - Click "Add Local..."
   - Navigate to `Packages/Features/OnboardingFlow`
   - Click "Add Package"

3. **Add to target**:
   - Select your app target (CritiCal)
   - In the "Frameworks, Libraries, and Embedded Content" section
   - Click the "+" button
   - Select "OnboardingFlow"
   - Click "Add"

4. **Enable the integration**:
   - Open `AppRouter.swift`
   - Uncomment the import statement:
     ```swift
     import OnboardingFlow
     ```
   - Uncomment the state property:
     ```swift
     @State private var onboardingSettings = OnboardingSettings()
     ```
   - Uncomment the modifier:
     ```swift
     .onboardingFlow(settings: onboardingSettings)
     ```

5. **Build and run** your app

## Testing the Onboarding

### First Launch
The onboarding will automatically appear on first launch.

### Force Show Onboarding
To test the onboarding flow again, you can:

1. Delete the app from the simulator/device
2. Or add a debug button that calls:
   ```swift
   onboardingSettings.resetOnboarding()
   ```

### Version Updates
To show onboarding to existing users (for new features):

1. Open `OnboardingFlow/Sources/OnboardingFlow/Models/OnboardingVersion.swift`
2. Increment the version number:
   ```swift
   public static let current = OnboardingVersion(version: 2)
   ```
3. Optionally update the pages in `OnboardingPage.swift` to show new features

## Customization

### Custom Pages
Edit the default pages in `OnboardingPage.swift`:
```swift
public static let defaultPages: [OnboardingPage] = [
    // Your custom pages here
]
```

### Styling
The OnboardingFlow uses your app's accent color automatically. To customize further, modify the views in the `Views` folder.