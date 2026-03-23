// RecipeCard.swift — Brew recipe summary card with key metrics
// Pixel (Eva) — 2026-03-23

import SwiftUI

struct RecipeCard: View {
    let name: String
    let style: String
    let abv: Double
    let ibu: Int
    let og: Double
    let fg: Double
    let brewDate: Date?
    let isFavorite: Bool
    let onTap: () -> Void
    let onToggleFavorite: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                header
                metricsRow
                if let brewDate {
                    dateLabel(brewDate)
                }
            }
            .padding(DesignTokens.Spacing.md)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: DesignTokens.Radius.md))
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - Subviews
    
    @ViewBuilder
    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(AppTypography.cardTitle)
                    .lineLimit(1)
                Text(style)
                    .font(AppTypography.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Button(action: onToggleFavorite) {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .foregroundStyle(isFavorite ? .red : .secondary)
                    .symbolEffect(.bounce, value: isFavorite)
            }
            .buttonStyle(.plain)
        }
    }
    
    @ViewBuilder
    private var metricsRow: some View {
        HStack(spacing: DesignTokens.Spacing.md) {
            MeasurementDisplay(value: String(format: "%.1f%%", abv), unit: "", label: "ABV")
            MeasurementDisplay(value: "\(ibu)", unit: "IBU", label: "Bitter")
            MeasurementDisplay(value: String(format: "%.3f", og), unit: "", label: "OG")
            MeasurementDisplay(value: String(format: "%.3f", fg), unit: "", label: "FG")
        }
    }
    
    @ViewBuilder
    private func dateLabel(_ date: Date) -> some View {
        HStack(spacing: DesignTokens.Spacing.xs) {
            Image(systemName: "calendar")
                .font(.caption2)
            Text(date, style: .date)
                .font(AppTypography.caption)
        }
        .foregroundStyle(.tertiary)
    }
}

#Preview {
    RecipeCard(
        name: "West Coast IPA",
        style: "American IPA",
        abv: 6.8,
        ibu: 65,
        og: 1.065,
        fg: 1.012,
        brewDate: .now,
        isFavorite: true,
        onTap: {},
        onToggleFavorite: {}
    )
    .padding()
}
