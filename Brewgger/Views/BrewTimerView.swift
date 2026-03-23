// BrewTimerView.swift — Circular brew timer with haptic checkpoints
// Pixel (Eva) — 2026-03-23

import SwiftUI

struct BrewTimerView: View {
    let totalSeconds: Int
    let brewStage: String
    @Binding var isRunning: Bool
    
    @State private var remainingSeconds: Int
    @State private var timer: Timer?
    
    init(totalSeconds: Int, brewStage: String, isRunning: Binding<Bool>) {
        self.totalSeconds = totalSeconds
        self.brewStage = brewStage
        self._isRunning = isRunning
        self._remainingSeconds = State(initialValue: totalSeconds)
    }
    
    private var progress: Double {
        guard totalSeconds > 0 else { return 0 }
        return 1.0 - Double(remainingSeconds) / Double(totalSeconds)
    }
    
    private var timeDisplay: String {
        let m = remainingSeconds / 60
        let s = remainingSeconds % 60
        return String(format: "%d:%02d", m, s)
    }
    
    var body: some View {
        VStack(spacing: DesignTokens.Spacing.md) {
            timerRing
            controls
        }
        .onChange(of: isRunning) { _, running in
            running ? startTimer() : stopTimer()
        }
    }
    
    // MARK: - Subviews
    
    @ViewBuilder
    private var timerRing: some View {
        ZStack {
            // Track
            Circle()
                .stroke(Color.secondary.opacity(0.15), lineWidth: 10)
            
            // Progress
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    AngularGradient(
                        colors: [.orange, .red, .orange],
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: 10, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.linear(duration: 1), value: progress)
            
            // Center content
            VStack(spacing: DesignTokens.Spacing.xs) {
                Text(timeDisplay)
                    .font(.system(size: 44, weight: .light, design: .rounded))
                    .monospacedDigit()
                    .contentTransition(.numericText())
                
                Text(brewStage.uppercased())
                    .font(AppTypography.caption)
                    .foregroundStyle(.secondary)
                    .tracking(1.5)
            }
        }
        .frame(width: 220, height: 220)
    }
    
    @ViewBuilder
    private var controls: some View {
        HStack(spacing: DesignTokens.Spacing.lg) {
            Button {
                remainingSeconds = totalSeconds
                isRunning = false
            } label: {
                Image(systemName: "arrow.counterclockwise")
                    .font(.title2)
                    .foregroundStyle(.secondary)
            }
            
            Button {
                isRunning.toggle()
            } label: {
                Image(systemName: isRunning ? "pause.circle.fill" : "play.circle.fill")
                    .font(.system(size: 56))
                    .foregroundStyle(.orange)
                    .symbolEffect(.bounce, value: isRunning)
            }
            
            Button {
                // Skip to next stage
            } label: {
                Image(systemName: "forward.end")
                    .font(.title2)
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    // MARK: - Timer Logic
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if remainingSeconds > 0 {
                remainingSeconds -= 1
            } else {
                isRunning = false
                stopTimer()
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

#Preview {
    BrewTimerView(totalSeconds: 240, brewStage: "Mash", isRunning: .constant(false))
        .padding()
}
