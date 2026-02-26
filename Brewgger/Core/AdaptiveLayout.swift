// AdaptiveLayout.swift — Adaptive layout utilities + Liquid Glass prep
// From Pixel knowledge: ViewThatFits, Liquid Glass (iOS 26)
import SwiftUI

// MARK: - ViewThatFits Wrappers

struct AdaptiveStack<Content: View>: View {
    let spacing: CGFloat
    @ViewBuilder let content: () -> Content
    
    init(spacing: CGFloat = DesignTokens.Spacing.md, @ViewBuilder content: @escaping () -> Content) {
        self.spacing = spacing
        self.content = content
    }
    
    var body: some View {
        ViewThatFits(in: .horizontal) {
            HStack(spacing: spacing, content: content)
            VStack(spacing: spacing, content: content)
        }
    }
}

// MARK: - Liquid Glass Prep (iOS 26+)
// Brewgger: toolbar + tab bar will auto-adopt Liquid Glass.
// Custom glass cards for recipe detail overlays.

struct GlassCard<Content: View>: View {
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        content()
            .padding(DesignTokens.Spacing.md)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: DesignTokens.Radius.lg))
    }
}

// MARK: - Phase Animator Utilities (iOS 17+)

struct PulsingModifier: ViewModifier {
    let isActive: Bool
    
    func body(content: Content) -> some View {
        if isActive {
            content
                .phaseAnimator([false, true]) { view, phase in
                    view
                        .scaleEffect(phase ? 1.05 : 1.0)
                        .opacity(phase ? 1.0 : 0.8)
                } animation: { _ in
                    .easeInOut(duration: 1.5)
                }
        } else {
            content
        }
    }
}

extension View {
    func pulsing(when active: Bool = true) -> some View {
        modifier(PulsingModifier(isActive: active))
    }
}
