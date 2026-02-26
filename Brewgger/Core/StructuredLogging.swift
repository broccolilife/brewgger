// StructuredLogging.swift — OSLog structured categories for agent-debuggable logging
// From Pixel knowledge (2026-02-26): Structure error handling + logging for agent debugging
import OSLog

extension Logger {
    private static let subsystem = Bundle.main.bundleIdentifier ?? "com.broccolilife.brewgger"
    
    /// Brew timer and recipe execution
    static let brewing = Logger(subsystem: subsystem, category: "Brewing")
    /// Recipe CRUD and search
    static let recipes = Logger(subsystem: subsystem, category: "Recipes")
    /// UI state transitions and navigation
    static let ui = Logger(subsystem: subsystem, category: "UI")
    /// Data persistence and Core Data / SwiftData
    static let persistence = Logger(subsystem: subsystem, category: "Persistence")
    /// CloudKit / iCloud sync
    static let sync = Logger(subsystem: subsystem, category: "Sync")
    /// Tasting notes and ratings
    static let tasting = Logger(subsystem: subsystem, category: "Tasting")
}
