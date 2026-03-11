//
//  AppCoordinator.swift
//  SIMPLE
//
//  Created by Srdjan Spasojevic on 11. 3. 2026..
//

import SwiftUI
import Combine
import SwiftData

let nav = "[NAVIGATION] "

@MainActor
final class AppCoordinator: Navigationable {
    @Published var navigationPath = NavigationPath()
    @Published var currentUser: User?

    // MARK: Services
    var authService: AuthenticationService
    var databaseService: DatabaseService

    init(container: ModelContainer) {
        self.databaseService = Database(container: container)
        self.authService = AuthenticationRepository(database: self.databaseService)
    }

    func bootstrap() async {
        if let user = await authService.currentUser() {
            self.currentUser = user
        }
    }

    func navigate(to route: Route) {
        print(nav, "Navigating to: \(route)")
        navigationPath.append(route)
    }
    
    func navigateBack() {
        guard !navigationPath.isEmpty else { return }
        print(nav, "Navigating back")
        navigationPath.removeLast()
    }
    
    func navigateToRoot() {
        print(nav, "Navigating back to root")
        navigationPath = NavigationPath()
    }
}

