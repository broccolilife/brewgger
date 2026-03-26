// ObservableState.swift — @Observable macro patterns for Brewgger
// Pixel+Muse — fine-grained reactivity, iOS 17+

import SwiftUI
import Observation

// MARK: - Brew Session State

@Observable
final class BrewSession {
    var method: BrewMethod = .pourOver
    var coffeeGrams: Double = 18.0
    var waterGrams: Double = 300.0
    var grindSize: GrindSize = .medium
    var waterTemp: Double = 96.0
    var timerSeconds: Int = 0
    var isRunning: Bool = false
    var notes: String = ""
    
    var ratio: Double {
        guard coffeeGrams > 0 else { return 0 }
        return waterGrams / coffeeGrams
    }
    
    var ratioLabel: String {
        String(format: "1:%.1f", ratio)
    }
    
    enum BrewMethod: String, CaseIterable {
        case pourOver = "Pour Over"
        case frenchPress = "French Press"
        case aeropress = "AeroPress"
        case espresso = "Espresso"
        case chemex = "Chemex"
    }
    
    enum GrindSize: String, CaseIterable {
        case extraFine, fine, mediumFine, medium, mediumCoarse, coarse
    }
}

// MARK: - Journal State

@Observable
final class JournalState {
    var entries: [BrewEntry] = []
    var selectedEntry: BrewEntry?
    var filterMethod: BrewSession.BrewMethod?
    
    var filteredEntries: [BrewEntry] {
        guard let filter = filterMethod else { return entries }
        return entries.filter { $0.method == filter }
    }
    
    struct BrewEntry: Identifiable {
        let id = UUID()
        let date: Date
        let method: BrewSession.BrewMethod
        let rating: Int
        let notes: String
    }
}

// MARK: - Environment Registration

extension EnvironmentValues {
    @Entry var brewSession: BrewSession = BrewSession()
    @Entry var journalState: JournalState = JournalState()
}

/*
 Usage — @Bindable for two-way bindings:
 
 struct BrewSetupView: View {
     @Bindable var session: BrewSession
     
     var body: some View {
         Stepper("Coffee: \(session.coffeeGrams, specifier: "%.1f")g",
                 value: $session.coffeeGrams, in: 5...50, step: 0.5)
         
         Picker("Method", selection: $session.method) {
             ForEach(BrewSession.BrewMethod.allCases, id: \.self) { Text($0.rawValue) }
         }
     }
 }
*/
