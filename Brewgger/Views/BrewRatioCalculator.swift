// BrewRatioCalculator.swift — Interactive coffee-to-water ratio calculator
// Pixel (Eva) — 2026-04-01

import SwiftUI

/// Quick ratio calculator with a draggable slider for coffee dose,
/// auto-computing water volume. Supports common brew methods with preset ratios.
struct BrewRatioCalculator: View {
    enum BrewMethod: String, CaseIterable, Identifiable {
        case pourOver = "Pour Over"
        case frenchPress = "French Press"
        case espresso = "Espresso"
        case aeropress = "AeroPress"
        case coldBrew = "Cold Brew"
        
        var id: String { rawValue }
        var icon: String {
            switch self {
            case .pourOver: return "drop.fill"
            case .frenchPress: return "cup.and.saucer.fill"
            case .espresso: return "bolt.fill"
            case .aeropress: return "arrow.down.circle.fill"
            case .coldBrew: return "snowflake"
            }
        }
        var defaultRatio: Double { // water:coffee
            switch self {
            case .pourOver: return 16
            case .frenchPress: return 15
            case .espresso: return 2
            case .aeropress: return 12
            case .coldBrew: return 8
            }
        }
    }
    
    @State private var selectedMethod: BrewMethod = .pourOver
    @State private var coffeeDoseGrams: Double = 18
    @State private var customRatio: Double = 16
    
    private var waterML: Double {
        coffeeDoseGrams * customRatio
    }
    
    var body: some View {
        VStack(spacing: DesignTokens.Spacing.lg) {
            methodPicker
            doseSlider
            ratioAdjuster
            resultDisplay
        }
        .padding(DesignTokens.Spacing.lg)
        .onChange(of: selectedMethod) {
            withAnimation(SpringPreset.snappy) {
                customRatio = selectedMethod.defaultRatio
            }
        }
    }
    
    // MARK: - Subviews
    
    @ViewBuilder
    private var methodPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: DesignTokens.Spacing.sm) {
                ForEach(BrewMethod.allCases) { method in
                    Button {
                        withAnimation(SpringPreset.snappy) {
                            selectedMethod = method
                        }
                    } label: {
                        VStack(spacing: 4) {
                            Image(systemName: method.icon)
                                .font(.title3)
                            Text(method.rawValue)
                                .font(AppTypography.caption)
                        }
                        .padding(.horizontal, DesignTokens.Spacing.md)
                        .padding(.vertical, DesignTokens.Spacing.sm)
                        .background(
                            selectedMethod == method
                                ? AnyShapeStyle(DesignTokens.Colors.primary.opacity(0.15))
                                : AnyShapeStyle(.ultraThinMaterial),
                            in: RoundedRectangle(cornerRadius: DesignTokens.Radius.sm)
                        )
                        .foregroundStyle(selectedMethod == method ? DesignTokens.Colors.primary : .secondary)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(method.rawValue)
                }
            }
        }
    }
    
    @ViewBuilder
    private var doseSlider: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
            HStack {
                Text("Coffee")
                    .font(AppTypography.sectionTitle)
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(coffeeDoseGrams, specifier: "%.1f")g")
                    .font(AppTypography.measurement)
                    .monospacedDigit()
            }
            Slider(value: $coffeeDoseGrams, in: 5...60, step: 0.5)
                .tint(DesignTokens.Colors.primary)
        }
    }
    
    @ViewBuilder
    private var ratioAdjuster: some View {
        HStack {
            Text("Ratio 1:")
                .font(AppTypography.caption)
                .foregroundStyle(.secondary)
            Text("\(customRatio, specifier: "%.1f")")
                .font(AppTypography.cardTitle)
                .monospacedDigit()
            Stepper("", value: $customRatio, in: 1...20, step: 0.5)
                .labelsHidden()
        }
    }
    
    @ViewBuilder
    private var resultDisplay: some View {
        HStack(spacing: DesignTokens.Spacing.xl) {
            MeasurementDisplay(
                value: String(format: "%.1f", coffeeDoseGrams),
                unit: "g",
                label: "Coffee"
            )
            Image(systemName: "arrow.right")
                .foregroundStyle(.tertiary)
            MeasurementDisplay(
                value: String(format: "%.0f", waterML),
                unit: "ml",
                label: "Water"
            )
        }
        .padding(DesignTokens.Spacing.lg)
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: DesignTokens.Radius.md))
        .contentTransition(.numericText())
        .animation(SpringPreset.snappy, value: waterML)
    }
}

#Preview {
    BrewRatioCalculator()
}
