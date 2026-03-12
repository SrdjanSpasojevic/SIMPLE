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

    var authService: AuthenticationService
    var databaseService: DatabaseService
    var bankTransactionService: BankTransactionService
    var biometricAuthService: BiometricAuthenticationService
    var mockDataService: MockDataService

    init(container: ModelContainer) {
        self.databaseService = Database(container: container)
        self.authService = AuthenticationRepository(database: self.databaseService)
        self.bankTransactionService = BankTransactionRepository(database: self.databaseService)
        self.biometricAuthService = BiometricAuthentication()
        self.mockDataService = MockDataRepository(database: self.databaseService)
    }

    func bootstrap() async {
        await mockDataService.seedUsersIfNeeded()
        if let user = await authService.currentUser() {
            if await biometricAuthService.authenticate(reason: "Authenticate to access your SIMPLE account") {
                self.currentUser = user
            } else {
                self.currentUser = nil
            }
        }
    }

    func refreshCurrentUser() async {
        guard let userId = currentUser?.id else { return }
        let users = try? await databaseService.get(where: #Predicate<User> { $0.id == userId })
        currentUser = users?.first
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

