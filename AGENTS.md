# Repository Guidelines

## Project Structure & Module Organization
CritiCal.xcworkspace drives the iOS app. The main app lives in `CritiCal/CritiCal`, with SwiftUI scenes, assets, and entitlements. Unit tests sit in `CritiCal/CritiCalTests`, UI tests in `CritiCal/CritiCalUITests`, and `AllTests.xctestplan` orchestrates both. Reusable logic is split across Swift packages under `CritiCal/Packages` (Domain, Models, Store, UI, Intents); each package keeps its own `Sources` and `Tests` folders for modular growth.

## Build, Test, and Development Commands
Use `xcodebuild -workspace CritiCal.xcworkspace -scheme CritiCal -destination "platform=iOS Simulator,name=iPhone 15" build` for a clean local build. Run the full suite with `xcodebuild test -workspace CritiCal.xcworkspace -testPlan CritiCal/AllTests.xctestplan -destination "platform=iOS Simulator,name=iPhone 15"`. Package-only checks run fastest via `swift test --package-path CritiCal/Packages/CritiCalDomain` (repeat for other packages).

## Coding Style & Naming Conventions
Adopt standard Swift formatting: four-space indentation, trailing commas for multi-line collections, and explicit `self` only when required for clarity. Use `UpperCamelCase` for types, `lowerCamelCase` for members, and suffix view types with `View`. Keep extensions grouped by protocol or feature. Document shared APIs with `///` doc comments and prefer async-first APIs that surface domain errors via `Error` enums.

## Testing Guidelines
Add new coverage with Swift Testing suites: declare `@Suite` types at the feature level and mark individual cases with `@Test`. Use `#expect` for assertions and `#expect(throws:)` for failure paths. Mirror the production module structure in test targets (`EventRepositorySuite` lives in `CritiCalDomain/Tests`). Ensure suites are included in `AllTests.xctestplan` and keep async tests deterministic by injecting mock stores.

## Commit & Pull Request Guidelines
Follow the existing concise, imperative commit style (`Refactor app routing`, `Add ConfirmationStatus enum`). Group related changes per commit and reference issues with `#123` when applicable. Pull requests should summarize behaviour changes, list the test commands you ran, and attach simulator screenshots or screen recordings for UI tweaks. Request review from domain owners when touching shared packages or app router logic.
