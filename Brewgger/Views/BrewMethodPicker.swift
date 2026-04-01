// BrewMethodPicker.swift — Visual brew method selection grid
// Pixel (Eva) — 2026-04-01

import SwiftUI

/// A visually rich method picker displaying brew methods as tappable cards
/// with icons, typical brew times, and difficulty indicators.
struct BrewMethodPicker: View {
    struct Method: Identifiable {
        let id = UUID()
        let name: String
        let icon: String
        let brewMinutes: ClosedRange<Int>
        let difficulty: Difficulty
        let color: Color
        
        enum Difficulty: String {
            case beginner = "Beginner"
            case intermediate = "Intermediate"
            case advanced = "Advanced"
            
            var dots: Int {
                switch self {
                case .beginner: return 1
                case .intermediate: return 2
                case .advanced: return 3
                }
            }
        }
    }
    
    static let defaultMethods: [Method] = [
        .init(name: "Pour Over", icon: "drop.fill", brewMinutes: 3...4, difficulty: .intermediate, color: .brown),
        .init(name: "French Press", icon: "cup.and.saucer.fill", brewMinutes: 4...5, difficulty: .beginner, color: .orange),
        .init(name: "Espresso", icon: "bolt.fill", brewMinutes: 0...1, difficulty: .advanced, color: .red),
        .init(name: "AeroPress", icon: "arrow.down.circle.fill", brewMinutes: 1...2, difficulty: .beginner, color: .blue),
        .init(name: "Cold Brew", icon: "snowflake", brewMinutes: 720...1440, difficulty: .beginner, color: .cyan),
        .init(name: "Moka Pot", icon: "flame.fill", brewMinutes: 4...6, difficulty: .intermediate, color: .pink),
    ]
    
    let methods: [Method]
    @Binding var selectedMethodName: String?
    
    init(methods: [Method] = defaultMethods, selectedMethodName: Binding<String?>) {
        self.methods = methods
        self._selectedMethodName = selectedMethodName
    }
    
    private let columns = [
        GridItem(.flexible(), spacing: DesignTokens.Spacing.sm),
        GridItem(.flexible(), spacing: DesignTokens.Spacing.sm)
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: DesignTokens.Spacing.sm) {
            ForEach(methods) { method in
                methodCard(method)
            }
        }
    }
    
    @ViewBuilder
    private func methodCard(_ method: Method) -> some View {
        let isSelected = selectedMethodName == method.name
        
        Button {
            withAnimation(SpringPreset.snappy) {
                selectedMethodName = isSelected ? nil : method.name
            }
        } label: {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                HStack {
                    Image(systemName: method.icon)
                        .font(.title2)
                        .foregroundStyle(method.color)
                    Spacer()
                    difficultyDots(method.difficulty)
                }
                
                Text(method.name)
                    .font(AppTypography.cardTitle)
                    .foregroundStyle(.primary)
                
                Text(formatBrewTime(method.brewMinutes))
                    .font(AppTypography.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(DesignTokens.Spacing.md)
            .background(
                isSelected
                    ? AnyShapeStyle(method.color.opacity(0.12))
                    : AnyShapeStyle(.ultraThinMaterial),
                in: RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
            )
            .overlay(
                RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                    .strokeBorder(isSelected ? method.color.opacity(0.5) : .clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.selection, trigger: isSelected)
        .accessibilityLabel("\(method.name), \(method.difficulty.rawValue), \(formatBrewTime(method.brewMinutes))")
    }
    
    @ViewBuilder
    private func difficultyDots(_ difficulty: Method.Difficulty) -> some View {
        HStack(spacing: 3) {
            ForEach(0..<3, id: \.self) { i in
                Circle()
                    .fill(i < difficulty.dots ? Color.primary : Color.primary.opacity(0.15))
                    .frame(width: 6, height: 6)
            }
        }
    }
    
    private func formatBrewTime(_ range: ClosedRange<Int>) -> String {
        if range.lowerBound >= 60 {
            let lowH = range.lowerBound / 60
            let highH = range.upperBound / 60
            return "\(lowH)–\(highH)h"
        }
        return "\(range.lowerBound)–\(range.upperBound) min"
    }
}

#Preview {
    struct PreviewHost: View {
        @State private var selected: String? = "Pour Over"
        var body: some View {
            BrewMethodPicker(selectedMethodName: $selected)
                .padding()
        }
    }
    return PreviewHost()
}
