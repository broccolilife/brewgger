import SwiftUI

// MARK: - Spring Animation Presets for Brewgger

enum SpringPreset {
    case snappy, bouncy, gentle, pour, bubble, timerTick

    var animation: Animation {
        switch self {
        case .snappy:    return .spring(response: 0.2, dampingFraction: 0.7)
        case .bouncy:    return .bouncy(duration: 0.5, extraBounce: 0.25)
        case .gentle:    return .spring(response: 0.55, dampingFraction: 0.9)
        case .pour:      return .easeIn(duration: 1.2)
        case .bubble:    return .spring(response: 0.8, dampingFraction: 0.5)
        case .timerTick: return .spring(response: 0.15, dampingFraction: 0.6)
        }
    }
}

// MARK: - Brew-Specific Spring Modifiers

extension View {
    /// Generic spring scale toggle.
    func springScale(isActive: Bool, preset: SpringPreset = .bouncy, activeScale: CGFloat = 1.1) -> some View {
        self
            .scaleEffect(isActive ? activeScale : 1.0)
            .animation(preset.animation, value: isActive)
    }

    /// Timer completion pulse — quick bounce on brew step done.
    func timerPulse(trigger: Bool) -> some View {
        self
            .scaleEffect(trigger ? 1.15 : 1.0)
            .animation(SpringPreset.timerTick.animation, value: trigger)
    }

    /// Pour fill animation — opacity rising from bottom.
    func pourFillEffect(progress: CGFloat) -> some View {
        self
            .opacity(Double(progress))
            .scaleEffect(y: progress, anchor: .bottom)
            .animation(SpringPreset.pour.animation, value: progress)
    }

    /// Bubble float — gently rising element.
    func bubbleFloat(isActive: Bool, offset: CGFloat = -20) -> some View {
        self
            .offset(y: isActive ? offset : 0)
            .opacity(isActive ? 0.0 : 1.0)
            .animation(SpringPreset.bubble.animation, value: isActive)
    }

    /// Recipe card entrance — slide in from trailing with spring.
    func cardEntrance(isVisible: Bool, delay: Double = 0) -> some View {
        self
            .offset(x: isVisible ? 0 : 60)
            .opacity(isVisible ? 1.0 : 0.0)
            .animation(
                SpringPreset.gentle.animation.delay(delay),
                value: isVisible
            )
    }

    /// Ingredient check-off — shrink and fade.
    func ingredientCheckOff(isChecked: Bool) -> some View {
        self
            .scaleEffect(isChecked ? 0.95 : 1.0)
            .opacity(isChecked ? 0.5 : 1.0)
            .animation(SpringPreset.snappy.animation, value: isChecked)
    }
}

// MARK: - Transitions

extension AnyTransition {
    static var springPopIn: AnyTransition {
        .scale(scale: 0.5)
        .combined(with: .opacity)
    }

    static var slideUpSpring: AnyTransition {
        .move(edge: .bottom)
        .combined(with: .opacity)
    }

    static var pourReveal: AnyTransition {
        .asymmetric(
            insertion: .scale(scale: 0.8, anchor: .bottom).combined(with: .opacity),
            removal: .opacity
        )
    }
}
