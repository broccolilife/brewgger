# AGENTS.md — Brewgger

## Overview
Brewgger is an iOS coffee brewing companion app (SwiftUI). Tracks brews, recipes, and timing.

## Build
```bash
xcodebuild -scheme Brewgger -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 16' build
```

## Architecture
- **UI Layer**: SwiftUI with `NavigationStack` routing via `BrewRouter`
- **Design System**: `DesignTokens.swift` (spacing, colors, elevation, typography, motion)
- **Core/**: Error states, accessibility, adaptive layout, typography, navigation, onboarding

## Key Patterns
- `@Observable` for state management
- `DesignTokens.Spacing.*` / `DesignTokens.Typography.*` for consistency
- `ErrorStateView` / `EmptyStateView` / `LoadingStateView` for all states
- `AccessibilityAnnouncements` for VoiceOver events
- Reduce-motion-safe animations via `adaptiveAnimation` / `motionSafeTransition`

## Testing
```bash
xcodebuild test -scheme Brewgger -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 16'
```
