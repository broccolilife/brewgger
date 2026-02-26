// SpringAnimations.swift — Spring animation presets for Brewgger
// Pixel+Muse — warm, deliberate motion for brewing UX

import SwiftUI

// MARK: - Spring Presets

enum SpringPreset {
    
    /// Pour animation — smooth, fluid motion
    static let pour: Animation = .spring(response: 0.6, dampingFraction: 0.75)
    
    /// Timer tick — subtle pulse on each second
    static let timerPulse: Animation = .spring(response: 0.2, dampingFraction: 0.5)
    
    /// Card expand — recipe detail expansion
    static let cardExpand: Animation = .spring(response: 0.45, dampingFraction: 0.8)
    
    /// Button press — tactile response
    static let buttonPress: Animation = .spring(response: 0.25, dampingFraction: 0.65)
    
    /// Step transition — moving between brew steps
    static let stepTransition: Animation = .spring(response: 0.5, dampingFraction: 0.85)
    
    /// Bloom effect — coffee bloom animation
    static let bloom: Animation = .spring(response: 0.8, dampingFraction: 0.6, blendDuration: 0.2)
    
    /// Gentle — settings toggles, subtle state changes
    static let gentle: Animation = .spring(response: 0.55, dampingFraction: 0.9)
    
    /// Snappy — tab switches, quick interactions
    static let snappy: Animation = .spring(response: 0.2, dampingFraction: 0.7)
}

// MARK: - Animated Modifiers

struct SlideInFromBottom: ViewModifier {
    @State private var appeared = false
    let delay: Double
    
    init(delay: Double = 0) { self.delay = delay }
    
    func body(content: Content) -> some View {
        content
            .offset(y: appeared ? 0 : 30)
            .opacity(appeared ? 1 : 0)
            .onAppear {
                withAnimation(SpringPreset.stepTransition.delay(delay)) {
                    appeared = true
                }
            }
    }
}

struct PressableStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(SpringPreset.buttonPress, value: configuration.isPressed)
    }
}

// MARK: - View Extensions

extension View {
    func slideInFromBottom(delay: Double = 0) -> some View {
        modifier(SlideInFromBottom(delay: delay))
    }
    
    func pressable() -> some View {
        buttonStyle(PressableStyle())
    }
}
