// BrewggerTheme.swift — App-specific design tokens for Brewgger
import SwiftUI

enum BrewggerTheme {
    // Coffee palette
    static let espresso = Color(red: 0.24, green: 0.15, blue: 0.10)
    static let crema = Color(red: 0.96, green: 0.91, blue: 0.82)
    static let caramel = Color(red: 0.80, green: 0.55, blue: 0.25)
    static let steam = Color(red: 0.95, green: 0.95, blue: 0.95)
    static let roast = Color(red: 0.44, green: 0.26, blue: 0.16)
    
    // Brew method icons
    static func brewMethodIcon(_ method: String) -> String {
        switch method.lowercased() {
        case "pourover", "v60": return "drop.fill"
        case "espresso": return "cup.and.saucer.fill"
        case "french press": return "cylinder.fill"
        case "aeropress": return "arrow.down.circle.fill"
        case "cold brew": return "snowflake"
        default: return "mug.fill"
        }
    }
    
    // Rating colors
    static func ratingColor(_ score: Int) -> Color {
        switch score {
        case 1...2: return .red
        case 3: return .orange
        case 4: return .yellow
        case 5: return .green
        default: return .gray
        }
    }
    
    // Tasting note categories (accessibility-friendly with both color + icon)
    enum TastingCategory: String, CaseIterable {
        case fruity, floral, nutty, chocolate, spicy, sweet, bitter, sour
        
        var color: Color {
            switch self {
            case .fruity: return .pink
            case .floral: return .purple
            case .nutty: return .brown
            case .chocolate: return Color(red: 0.4, green: 0.2, blue: 0.1)
            case .spicy: return .orange
            case .sweet: return .yellow
            case .bitter: return .gray
            case .sour: return .green
            }
        }
        
        var icon: String {
            switch self {
            case .fruity: return "cherry"
            case .floral: return "flower"
            case .nutty: return "leaf.fill"
            case .chocolate: return "square.fill"
            case .spicy: return "flame.fill"
            case .sweet: return "drop.fill"
            case .bitter: return "bolt.fill"
            case .sour: return "sparkle"
            }
        }
        
        var accessibilityLabel: String {
            "\(rawValue.capitalized) tasting note"
        }
    }
}

// MARK: - Brew Errors
enum BrewError: LocalizedError, Equatable {
    case timerFailed
    case recipeNotFound
    case syncFailed(String)
    
    var errorDescription: String? {
        switch self {
        case .timerFailed: return "Timer Error"
        case .recipeNotFound: return "Recipe Not Found"
        case .syncFailed(let msg): return "Sync Failed: \(msg)"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .timerFailed: return "The brew timer encountered an issue. Please restart."
        case .recipeNotFound: return "This recipe may have been deleted."
        case .syncFailed: return "Check your internet connection and try again."
        }
    }
}
