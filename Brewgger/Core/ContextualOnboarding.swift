// ContextualOnboarding.swift — Contextual tips for Brewgger
// Pixel+Muse — NNGroup: teach in context, not front-loaded tutorials

import SwiftUI

// MARK: - Tip Model

struct BrewTip: Identifiable {
    let id: String
    let message: String
    let icon: String
}

// MARK: - Tip Store

@Observable
final class BrewTipStore {
    private var seen: Set<String> = []
    private let key = "brewgger_seen_tips"
    
    init() { seen = Set(UserDefaults.standard.stringArray(forKey: key) ?? []) }
    
    func shouldShow(_ id: String) -> Bool { !seen.contains(id) }
    
    func markSeen(_ id: String) {
        seen.insert(id)
        UserDefaults.standard.set(Array(seen), forKey: key)
    }
}

// MARK: - Brewgger Tips

extension BrewTip {
    static let ratioGuide = BrewTip(
        id: "ratio_guide",
        message: "A 1:16 ratio is a great starting point. Adjust to taste!",
        icon: "scalemass"
    )
    
    static let grindImportance = BrewTip(
        id: "grind_tip",
        message: "Grind size is the #1 variable. Finer = stronger, coarser = lighter.",
        icon: "gearshape"
    )
    
    static let firstBrew = BrewTip(
        id: "first_brew",
        message: "Start your timer when water hits coffee. We'll track everything.",
        icon: "timer"
    )
    
    static let tastingNote = BrewTip(
        id: "tasting_note",
        message: "Rate your brew and add notes. Over time you'll dial in your perfect cup.",
        icon: "star"
    )
}

// MARK: - Inline Tip View

struct InlineTip: View {
    let tip: BrewTip
    let store: BrewTipStore
    
    @State private var visible = false
    
    var body: some View {
        if store.shouldShow(tip.id) {
            HStack(spacing: 10) {
                Image(systemName: tip.icon)
                    .font(.title3)
                    .foregroundStyle(.brown)
                
                Text(tip.message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        visible = false
                    }
                    store.markSeen(tip.id)
                } label: {
                    Image(systemName: "xmark")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
            }
            .padding(12)
            .background(.brown.opacity(0.08), in: RoundedRectangle(cornerRadius: 12))
            .scaleEffect(visible ? 1 : 0.9)
            .opacity(visible ? 1 : 0)
            .onAppear {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.75).delay(0.5)) {
                    visible = true
                }
            }
        }
    }
}
