import SwiftUI

// MARK: - Typography System for Brewgger

/// Semantic type styles with Dynamic Type support.
/// Uses SF Serif for warmth + SF default for UI.

enum AppTypography {

    // MARK: - Display & Headings (Serif for warmth)

    /// Display — recipe titles, brew day headers
    static let display = Font.system(.largeTitle, design: .serif, weight: .bold)

    /// Title — screen titles
    static let title = Font.system(.title2, design: .serif, weight: .bold)

    /// Subtitle — section headers
    static let subtitle = Font.system(.title3, design: .serif, weight: .semibold)

    // MARK: - UI Text (Default for readability)

    /// Headline — card titles, step names
    static let headline = Font.system(.headline, weight: .semibold)

    /// Body — descriptions, instructions
    static let body = Font.system(.body)

    /// Callout — tips, notes
    static let callout = Font.system(.callout)

    /// Caption — metadata, brew dates
    static let caption = Font.system(.caption)

    /// Micro — badges, tiny labels
    static let micro = Font.system(.caption2, weight: .medium)

    // MARK: - Specialized

    /// Timer — large monospaced digits for brew timers
    static let timer = Font.system(size: 56, weight: .light, design: .monospaced)

    /// Measurement — ingredient amounts (monospaced for alignment)
    static let measurement = Font.system(.body, design: .monospaced, weight: .medium)

    /// ABV/IBU — stats display
    static let stat = Font.system(.title, design: .rounded, weight: .bold)

    // MARK: - Line Heights

    static let tightLeading: CGFloat = 1.1
    static let normalLeading: CGFloat = 1.4
    static let relaxedLeading: CGFloat = 1.6

    // MARK: - Tracking

    static let tightTracking: CGFloat = -0.5
    static let normalTracking: CGFloat = 0
    static let wideTracking: CGFloat = 1.5
}

// MARK: - View Modifiers

extension View {
    func textStyle(_ font: Font, color: Color = DesignTokens.Colors.textPrimary) -> some View {
        self
            .font(font)
            .foregroundStyle(color)
    }

    /// Timer display — large monospaced countdown.
    func timerStyle() -> some View {
        self
            .font(AppTypography.timer)
            .monospacedDigit()
            .foregroundStyle(DesignTokens.Colors.timerActive)
    }

    /// Recipe title — warm serif heading.
    func recipeTitleStyle() -> some View {
        self
            .font(AppTypography.display)
            .foregroundStyle(DesignTokens.Colors.brewCopper)
    }

    /// Measurement values — aligned monospace.
    func measurementStyle() -> some View {
        self
            .font(AppTypography.measurement)
            .monospacedDigit()
    }
}

// MARK: - Text Convenience

extension Text {
    func captionSecondary() -> Text {
        self
            .font(AppTypography.caption)
            .foregroundStyle(DesignTokens.Colors.textSecondary)
    }

    func statStyle() -> Text {
        self
            .font(AppTypography.stat)
            .fontDesign(.rounded)
    }
}
