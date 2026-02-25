# ☕ Brewgger

Coffee brewing journal — track recipes, ratios, and tasting notes.

## Architecture
- **SwiftUI** with `@Observable` state management
- **Design Tokens** — Consistent spacing, typography, motion via `DesignTokens.swift`
- **Error States** — Enum-driven error handling with recovery suggestions
- **Accessibility** — VoiceOver labels, Dynamic Type, haptic feedback, color+icon redundancy

## Design System
- View decomposition pattern (from Ice/CodeEdit repos)
- `AppSection` reusable containers with material backgrounds
- `.annotation()` modifier for form helper text
- Tasting notes use both color AND icon (never color-only for accessibility)
- ViewThatFits for adaptive layouts

## Getting Started
Open `Brewgger.xcodeproj` in Xcode 16+ and run on iOS 17+.
