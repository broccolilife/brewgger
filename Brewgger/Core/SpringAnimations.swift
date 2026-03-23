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

    /// Steam rise — slow, dreamy upward motion
    static let steamRise: Animation = .spring(response: 1.0, dampingFraction: 0.95)

    /// Grind adjust — precise, controlled
    static let grindAdjust: Animation = .spring(response: 0.3, dampingFraction: 0.8)
}

// MARK: - Transition Presets

enum TransitionPreset {
    /// Card-style pop in
    static let cardPresent: AnyTransition = .asymmetric(
        insertion: .scale(scale: 0.9).combined(with: .opacity),
        removal: .scale(scale: 0.95).combined(with: .opacity)
    )

    /// Slide up from bottom
    static let slideUp: AnyTransition = .move(edge: .bottom).combined(with: .opacity)

    /// Step change — horizontal slide
    static let stepForward: AnyTransition = .asymmetric(
        insertion: .move(edge: .trailing).combined(with: .opacity),
        removal: .move(edge: .leading).combined(with: .opacity)
    )

    /// Timer complete — scale out
    static let timerDone: AnyTransition = .scale(scale: 1.2).combined(with: .opacity)

    /// Fade through (crossfade)
    static let fadeThrough: AnyTransition = .opacity
}

// MARK: - Haptic-Coupled Animations

struct HapticSpring {
    static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium,
                       animation: Animation = SpringPreset.buttonPress,
                       _ body: @escaping () -> Void) {
        UIImpactFeedbackGenerator(style: style).impactOccurred()
        withAnimation(animation, body)
    }

    static func notification(_ type: UINotificationFeedbackGenerator.FeedbackType,
                             animation: Animation = SpringPreset.cardExpand,
                             _ body: @escaping () -> Void) {
        UINotificationFeedbackGenerator().notificationOccurred(type)
        withAnimation(animation, body)
    }

    static func selection(animation: Animation = SpringPreset.snappy,
                          _ body: @escaping () -> Void) {
        UISelectionFeedbackGenerator().selectionChanged()
        withAnimation(animation, body)
    }
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

struct StaggeredAppear: ViewModifier {
    let index: Int
    let baseDelay: Double
    @State private var appeared = false

    func body(content: Content) -> some View {
        content
            .offset(y: appeared ? 0 : 16)
            .opacity(appeared ? 1 : 0)
            .onAppear {
                withAnimation(SpringPreset.gentle.delay(baseDelay + Double(index) * 0.08)) {
                    appeared = true
                }
            }
    }
}

struct PressableStyle: ButtonStyle {
    let scale: CGFloat

    init(scale: CGFloat = 0.95) {
        self.scale = scale
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scale : 1)
            .opacity(configuration.isPressed ? 0.85 : 1)
            .animation(SpringPreset.buttonPress, value: configuration.isPressed)
    }
}

struct BreathingEffect: ViewModifier {
    @State private var breathing = false
    let scale: CGFloat

    func body(content: Content) -> some View {
        content
            .scaleEffect(breathing ? scale : 1.0)
            .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: breathing)
            .onAppear { breathing = true }
    }
}

// MARK: - View Extensions

extension View {
    func slideInFromBottom(delay: Double = 0) -> some View {
        modifier(SlideInFromBottom(delay: delay))
    }

    func staggeredAppear(index: Int, baseDelay: Double = 0) -> some View {
        modifier(StaggeredAppear(index: index, baseDelay: baseDelay))
    }

    func pressable(scale: CGFloat = 0.95) -> some View {
        buttonStyle(PressableStyle(scale: scale))
    }

    /// Gentle breathing/pulsing for active timers
    func breathing(scale: CGFloat = 1.02) -> some View {
        modifier(BreathingEffect(scale: scale))
    }

    func withSpring(_ preset: Animation, value: some Equatable) -> some View {
        animation(preset, value: value)
    }

    func springWithHaptic(_ preset: Animation = SpringPreset.buttonPress, value: some Equatable) -> some View {
        animation(preset, value: value)
            .sensoryFeedback(.impact(flexibility: .rigid), trigger: value)
    }
}
