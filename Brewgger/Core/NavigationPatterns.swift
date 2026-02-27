// NavigationPatterns.swift — Modern Navigation (NavigationStack)
// From Pixel knowledge (2026-02-27): Migrate from NavigationView to NavigationStack

import SwiftUI

// MARK: - Navigation Destinations

enum BrewDestination: Hashable {
    case recipeDetail(id: String)
    case brewTimer(id: String)
    case settings
    case profile
    case newRecipe
}

// MARK: - NavigationStack Router

@Observable
final class BrewRouter {
    var path = NavigationPath()
    
    func navigate(to destination: BrewDestination) {
        path.append(destination)
    }
    
    func popToRoot() {
        path = NavigationPath()
    }
    
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
}

// MARK: - ViewThatFits Adaptive Layout

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

// MARK: - Brew-Specific Error States

enum BrewError: LocalizedError, Equatable {
    case timerFailed
    case recipeCorrupted
    case syncFailed(String)
    
    var errorDescription: String? {
        switch self {
        case .timerFailed: return "Timer Error"
        case .recipeCorrupted: return "Recipe Data Error"
        case .syncFailed(let msg): return "Sync Failed: \(msg)"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .timerFailed: return "Restart the brew timer."
        case .recipeCorrupted: return "Try re-importing the recipe."
        case .syncFailed: return "Check your connection and try again."
        }
    }
    
    var systemImage: String {
        switch self {
        case .timerFailed: return "timer.circle.fill"
        case .recipeCorrupted: return "doc.badge.ellipsis"
        case .syncFailed: return "icloud.slash.fill"
        }
    }
}
