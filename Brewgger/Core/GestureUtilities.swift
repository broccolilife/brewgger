// GestureUtilities.swift — Reusable gesture patterns for Brewgger
// Pixel+Muse — precise touch handling with spring-based feedback

import SwiftUI

// MARK: - Tap Bounce

struct TapBounce: ViewModifier {
    let action: () -> Void
    @State private var tapped = false

    func body(content: Content) -> some View {
        content
            .scaleEffect(tapped ? 0.9 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.5), value: tapped)
            .onTapGesture {
                tapped = true
                action()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { tapped = false }
            }
    }
}

// MARK: - Pull to Refresh Spring

struct PullSpring: ViewModifier {
    @State private var pullOffset: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .offset(y: pullOffset * 0.4)
            .gesture(
                DragGesture()
                    .onChanged { pullOffset = max(0, $0.translation.height) }
                    .onEnded { _ in
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.65)) {
                            pullOffset = 0
                        }
                    }
            )
    }
}

// MARK: - View Extensions

extension View {
    func tapBounce(action: @escaping () -> Void) -> some View {
        modifier(TapBounce(action: action))
    }

    func pullSpring() -> some View {
        modifier(PullSpring())
    }
}
