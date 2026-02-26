// Typography.swift — Type system for Brewgger
// Pixel+Muse — warm, readable typography for coffee brewing

import SwiftUI

enum AppTypography {
    
    // MARK: - Display
    
    /// Hero — brew name, recipe title
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
    
    // MARK: - Monospaced (timers, ratios, measurements)
    
    /// Timer display — 3:45
    static let timerDisplay: Font = .system(size: 56, weight: .light, design: .monospaced)
    
    /// Ratio/measurement — "1:16", "18g"
    static let measurement: Font = .system(size: 20, weight: .medium, design: .monospaced)
    
    /// Small mono — grind size, temp readings
    static let monoCaption: Font = .system(size: 13, weight: .regular, design: .monospaced)
}

// MARK: - View Modifiers

struct TypeStyle: ViewModifier {
    let font: Font
    let color: Color
    let tracking: CGFloat
    
    init(_ font: Font, color: Color = .primary, tracking: CGFloat = 0) {
        self.font = font
        self.color = color
        self.tracking = tracking
    }
    
    func body(content: Content) -> some View {
        content
            .font(font)
            .foregroundStyle(color)
            .tracking(tracking)
    }
}

extension View {
    func typeStyle(_ font: Font, color: Color = .primary, tracking: CGFloat = 0) -> some View {
        modifier(TypeStyle(font, color: color, tracking: tracking))
    }
    
    /// Timer display — large, light, monospaced
    func timerStyle() -> some View {
        modifier(TypeStyle(AppTypography.timerDisplay, tracking: 2))
    }
    
    /// Measurement style for ratios and weights
    func measurementStyle() -> some View {
        modifier(TypeStyle(AppTypography.measurement, tracking: 0.5))
    }
}
