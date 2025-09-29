# CritiCalCore

Core utilities and shared components for the CritiCal application.

## Overview

CritiCalCore provides UI-agnostic helper types and utilities that are used across multiple packages in the CritiCal application. This package focuses on providing common, reusable components that don't depend on specific UI frameworks or data persistence layers.

## Contents

### AppSymbol
- Represents SF Symbols with associated keywords for search functionality
- Used for icon selection throughout the application

### CuratedSymbols
- Pre-defined collections of SF Symbols organized by category:
  - Theatre & Stage
  - Music & Dance
  - People & Masks
  - Time & Calendar
  - Shapes & Badges

### ColorToken
- Enumeration of predefined color values used throughout the application
- Provides consistent color palette with hex color codes
- Supports all standard operations: Codable, CaseIterable, Identifiable

## Usage

```swift
import CritiCalCore

// Using AppSymbol
let theatreIcon = AppSymbol("theatermasks", keywords: ["theatre", "drama"])

// Using ColorToken
let primaryColor = ColorToken.blue

// Using CuratedSymbols
let allTheaterSymbols = CuratedSymbols.theatreAndStage.symbols
```

## Platform Support

- iOS 26+
- macOS 26+