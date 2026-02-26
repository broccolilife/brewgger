// Onboarding.swift — TipKit-based contextual onboarding
// From Pixel knowledge (2023 web): TipKit for consistent contextual tooltips
import SwiftUI
import TipKit

// MARK: - Brew Tips

struct FirstBrewTip: Tip {
    var title: Text { Text("Log Your First Brew") }
    var message: Text? { Text("Tap + to record your coffee brew method, grind size, and tasting notes.") }
    var image: Image? { Image(systemName: "cup.and.saucer.fill") }
}

struct TastingNoteTip: Tip {
    @Parameter static var brewCount: Int = 0
    
    var title: Text { Text("Add Tasting Notes") }
    var message: Text? { Text("Describe the flavor profile — fruity, nutty, chocolatey? This helps you find your favorites.") }
    var image: Image? { Image(systemName: "star.bubble") }
    
    var rules: [Rule] {
        #Rule(Self.$brewCount) { $0 >= 2 }
    }
}

struct RatioTip: Tip {
    var title: Text { Text("Dial In Your Ratio") }
    var message: Text? { Text("Try adjusting your coffee-to-water ratio for different brew methods.") }
    var image: Image? { Image(systemName: "scalemass.fill") }
}

// MARK: - Tip Configuration

enum OnboardingManager {
    static func configure() {
        try? Tips.configure([
            .displayFrequency(.weekly),
            .datastoreLocation(.applicationDefault)
        ])
    }
}
