//
//  SIMPLEApp.swift
//  SIMPLE
//
//  Created by Srdjan Spasojevic on 10. 3. 2026..
//

import SwiftUI
import SwiftData

@main
struct SIMPLEApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            User.self,
            Account.self,
            BankTransaction.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            RootView(container: sharedModelContainer)
        }
        .modelContainer(sharedModelContainer)
    }
}
