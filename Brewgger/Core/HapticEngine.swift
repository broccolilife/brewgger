// HapticEngine.swift — Structured haptic feedback for Brewgger
// Pixel+Muse — tactile feedback for brew timers and interactions

import SwiftUI
import CoreHaptics

enum HapticEngine {

    // MARK: - Brew Events

    static func timerStart() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }

    static func timerTick() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred(intensity: 0.3)
    }

    static func brewComplete() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }

    static func stepTransition() {
        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
    }

    static func ratingSelected() {
        UISelectionFeedbackGenerator().selectionChanged()
    }

    // MARK: - CoreHaptics: Brew Complete Celebration

    static func brewCelebration() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        do {
            let engine = try CHHapticEngine()
            try engine.start()

            let events: [CHHapticEvent] = (0..<3).map { i in
                CHHapticEvent(
                    eventType: .hapticTransient,
                    parameters: [
                        CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(0.6 + Double(i) * 0.15)),
                        CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
                    ],
                    relativeTime: Double(i) * 0.12
                )
            }

            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: 0)
        } catch {
            brewComplete()
        }
    }
}
