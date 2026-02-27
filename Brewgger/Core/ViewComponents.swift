// ViewComponents.swift — Reusable view patterns for Brewgger
// Pixel+Muse — annotation modifier, section pattern, tab indicator

import SwiftUI

// MARK: - Annotation Modifier

struct AnnotationModifier: ViewModifier {
    let text: String
    
    func body(content: Content) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            content
            Text(text)
                .font(AppTypography.caption)
                .foregroundStyle(.secondary)
        }
    }
}

extension View {
    func annotation(_ text: String) -> some View {
        modifier(AnnotationModifier(text: text))
    }
}

// MARK: - Brew Section

struct BrewSection<Content: View>: View {
    let title: String?
    @ViewBuilder let content: () -> Content
    
    init(_ title: String? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.content = content
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            if let title {
                Text(title)
                    .font(AppTypography.sectionTitle)
                    .foregroundStyle(.secondary)
            }
            content()
        }
        .padding(DesignTokens.Spacing.md)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: DesignTokens.Radius.md))
    }
}

// MARK: - Brew Step Indicator

struct BrewStepIndicator: View {
    let steps: [String]
    let currentStep: Int
    
    var body: some View {
        HStack(spacing: DesignTokens.Spacing.xs) {
            ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
                VStack(spacing: 4) {
                    Circle()
                        .fill(index <= currentStep ? Color.accentColor : Color.secondary.opacity(0.3))
                        .frame(width: 10, height: 10)
                    Text(step)
                        .font(AppTypography.caption)
                        .foregroundStyle(index <= currentStep ? .primary : .secondary)
                }
                .frame(maxWidth: .infinity)
                
                if index < steps.count - 1 {
                    Rectangle()
                        .fill(index < currentStep ? Color.accentColor : Color.secondary.opacity(0.3))
                        .frame(height: 2)
                        .frame(maxWidth: .infinity)
                }
            }
        }
    }
}

// MARK: - Measurement Display

struct MeasurementDisplay: View {
    let value: String
    let unit: String
    let label: String
    
    var body: some View {
        VStack(spacing: 2) {
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(value)
                    .font(AppTypography.measurement)
                Text(unit)
                    .font(AppTypography.caption)
                    .foregroundStyle(.secondary)
            }
            Text(label)
                .font(AppTypography.caption)
                .foregroundStyle(.secondary)
        }
    }
}
