// AnimationChoreography.swift — Coordinated brew animations
// Pixel+Muse — orchestrated motion for satisfying brew UX

import SwiftUI

// MARK: - Brew Mastery Ring (Goal-Gradient from UX Laws)

struct MasteryRing: View {
    let progress: Double  // 0...1
    let method: String
    
    @State private var animatedProgress: Double = 0
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(.brown.opacity(0.15), lineWidth: 8)
            
            Circle()
                .trim(from: 0, to: animatedProgress)
                .stroke(.brown.gradient, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                .rotationEffect(.degrees(-90))
            
            VStack(spacing: 2) {
                Text("\(Int(animatedProgress * 100))%")
                    .font(.system(.title3, design: .rounded, weight: .bold))
                    .contentTransition(.numericText())
                
                Text(method)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.2)) {
                animatedProgress = progress
            }
        }
    }
}

// MARK: - Timer Pulse

struct TimerPulse: ViewModifier {
    let isRunning: Bool
    @State private var pulse = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(pulse ? 1.02 : 1.0)
            .animation(
                isRunning
                    ? .easeInOut(duration: 1.0).repeatForever(autoreverses: true)
                    : .spring(response: 0.3, dampingFraction: 0.8),
                value: pulse
            )
            .onChange(of: isRunning) { _, running in
                pulse = running
            }
    }
}

// MARK: - Pour Animation

struct PourProgress: View {
    let current: Double
    let target: Double
    
    private var fillPercent: Double {
        guard target > 0 else { return 0 }
        return min(current / target, 1.0)
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.brown.opacity(0.1))
                
                RoundedRectangle(cornerRadius: 8)
                    .fill(.brown.opacity(0.3).gradient)
                    .frame(height: geo.size.height * fillPercent)
                    .animation(.spring(response: 0.5, dampingFraction: 0.8), value: fillPercent)
            }
        }
        .frame(width: 40, height: 100)
    }
}

// MARK: - Extensions

extension View {
    func timerPulse(isRunning: Bool) -> some View {
        modifier(TimerPulse(isRunning: isRunning))
    }
}
