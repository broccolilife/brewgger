// PhaseAnimations.swift — iOS 17+ PhaseAnimator patterns for Brewgger
// Pixel+Muse — warm, deliberate cyclic animations for brewing UX

import SwiftUI

// MARK: - Brewing Phase Animations

/// Steam rising animation for active brew timer
@available(iOS 17.0, *)
struct SteamPhase: ViewModifier {
    func body(content: Content) -> some View {
        content
            .phaseAnimator([false, true]) { view, rising in
                view
                    .offset(y: rising ? -8 : 0)
                    .opacity(rising ? 0.5 : 0.9)
                    .scaleEffect(rising ? 1.1 : 1.0)
            } animation: { rising in
                rising ? .easeOut(duration: 1.5) : .easeIn(duration: 1.2)
            }
    }
}

/// Pour pulse — visual feedback during pour step
@available(iOS 17.0, *)
struct PourPulse: ViewModifier {
    func body(content: Content) -> some View {
        content
            .phaseAnimator([1.0, 1.06, 1.0]) { view, scale in
                view.scaleEffect(scale)
            } animation: { _ in
                .bouncy(duration: 1.0, extraBounce: 0.2)
            }
    }
}

/// Bloom indicator — expanding circle for coffee bloom phase
@available(iOS 17.0, *)
struct BloomPhase: ViewModifier {
    func body(content: Content) -> some View {
        content
            .phaseAnimator([false, true]) { view, blooming in
                view
                    .scaleEffect(blooming ? 1.3 : 1.0)
                    .opacity(blooming ? 0.3 : 0.8)
            } animation: { blooming in
                blooming
                    ? .easeOut(duration: 2.0)
                    : .easeIn(duration: 1.0)
            }
    }
}

// MARK: - View Extensions

@available(iOS 17.0, *)
extension View {
    func steamPhase() -> some View { modifier(SteamPhase()) }
    func pourPulse() -> some View { modifier(PourPulse()) }
    func bloomPhase() -> some View { modifier(BloomPhase()) }
}
