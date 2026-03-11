//
//  LoginViewModel.swift
//  SIMPLE
//
//  Created by Cursor on 11. 3. 2026..
//

import Foundation
import SwiftData
import Combine

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""

    var canSubmit: Bool {
        !username.isEmpty && !password.isEmpty
    }

    private let coordinator: AppCoordinator

    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
    }

    func login() async {
        do {
            _ = try await coordinator.authService.login(username: username, password: password)
            let users = try? await coordinator.databaseService.get(where: #Predicate<User> {
                $0.username == username && $0.password == password
            })
            if let user = users?.first {
                coordinator.currentUser = user
                coordinator.navigateToRoot()
            }
            print(loginViewText, "User is logged in: true")
        } catch {
            alertMessage = error.localizedDescription
            showAlert = true
        }
    }

    func navigateToRegister() {
        coordinator.navigate(to: .register)
    }
}
