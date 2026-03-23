// Typography.swift — Type system for Brewgger
// Pixel+Muse — warm, readable typography for coffee brewing

import SwiftUI

// MARK: - App Typography

enum AppTypography {

    // MARK: - Display

    /// Hero — brew name, recipe title (serif for warmth)
    static let hero: Font = .system(size: 32, weight: .bold, design: .serif)

    /// Section headers — "My Brews", "Recipes"
    static let sectionTitle: Font = .system(size: 22, weight: .semibold, design: .default)

    /// Card title — brew method name
    static let cardTitle: Font = .system(size: 17, weight: .semibold, design: .default)

    /// Body — recipe steps, descriptions
    static let body: Font = .system(size: 16, weight: .regular, design: .default)

    /// Secondary — metadata, notes
    static let secondary: Font = .system(size: 14, weight: .regular, design: .default)

    /// Caption — timestamps, ratios
    static let caption: Font = .system(size: 12, weight: .medium, design: .default)

    /// Micro — badge text
    static let micro: Font = .system(size: 10, weight: .bold, design: .default)

    // MARK: - Monospaced (timers, ratios, measurements)

    /// Timer display — 3:45
    static let timerDisplay: Font = .system(size: 56, weight: .light, design: .monospaced)

    /// Timer compact — for smaller timer views
    static let timerCompact: Font = .system(size: 32, weight: .medium, design: .monospaced)

    /// Ratio/measurement — "1:16", "18g"
    static let measurement: Font = .system(size: 20, weight: .medium, design: .monospaced)

    /// Small mono — grind size, temp readings
    static let monoCaption: Font = .system(size: 13, weight: .regular, design: .monospaced)

    // MARK: - Semantic Contexts

    enum Semantic {
        /// Step instructions during active brew
        static let brewStep: Font = .system(size: 18, weight: .medium, design: .default)
        /// Water amount callouts
        static let waterAmount: Font = .system(size: 24, weight: .semibold, design: .monospaced)
        /// Grind setting display
        static let grindSetting: Font = .system(size: 16, weight: .medium, design: .monospaced)
        /// Tasting notes
        static let tastingNote: Font = .system(size: 15, weight: .regular, design: .serif)
        /// Button labels
        static let button: Font = .system(size: 16, weight: .semibold, design: .default)
        /// Temperature reading
        static let temperature: Font = .system(size: 18, weight: .medium, design: .monospaced)
    }

    // MARK: - Dynamic Type Scaling

    static func scaled(_ size: CGFloat, weight: Font.Weight = .regular,
                       design: Font.Design = .default, relativeTo style: Font.TextStyle = .body) -> Font {
        .system(size: size, weight: weight, design: design)
    }
}

// MARK: - Typography View Modifier

struct TypeStyle: ViewModifier {
    let font: Font
    let color: Color
    let tracking: CGFloat
    let lineSpacing: CGFloat

    init(_ font: Font, color: Color = .primary, tracking: CGFloat = 0, lineSpacing: CGFloat = 0) {
        self.font = font
        self.color = color
        self.tracking = tracking
        self.lineSpacing = lineSpacing
    }

    func body(content: Content) -> some View {
        content
            .font(font)
            .foregroundStyle(color)
            .tracking(tracking)
            .lineSpacing(lineSpacing)
    }
}

// MARK: - View Extensions

extension View {
    func typeStyle(_ font: Font, color: Color = .primary, tracking: CGFloat = 0, lineSpacing: CGFloat = 0) -> some View {
        modifier(TypeStyle(font, color: color, tracking: tracking, lineSpacing: lineSpacing))
    }

    /// Timer display — large, light, monospaced with wide tracking
    func timerStyle() -> some View {
        modifier(TypeStyle(AppTypography.timerDisplay, tracking: 2))
    }

    /// Measurement style for ratios and weights
    func measurementStyle() -> some View {
        modifier(TypeStyle(AppTypography.measurement, tracking: 0.5))
    }

    /// Hero title — serif, warm
    func heroStyle() -> some View {
        modifier(TypeStyle(AppTypography.hero, tracking: -0.3))
    }

    /// Tasting note style — italic serif feel
    func tastingNoteStyle() -> some View {
        modifier(TypeStyle(AppTypography.Semantic.tastingNote, color: DesignTokens.Colors.textSecondary, lineSpacing: 4))
    }
}

// MARK: - Text Convenience

extension Text {
    func timer() -> Text {
        self.font(AppTypography.timerDisplay)
            .monospacedDigit()
    }

    func sectionHeader() -> Text {
        self.font(AppTypography.sectionTitle)
            .foregroundColor(.secondary)
    }

    func measurement() -> Text {
        self.font(AppTypography.measurement)
            .monospacedDigit()
    }
}
