//
//  RegisterViewModel.swift
//  SIMPLE
//
//  Created by Cursor on 11. 3. 2026..
//

import Foundation
import Combine

@MainActor
final class RegisterViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var confirmPassword: String = ""
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""

    var isFormValid: Bool {
        !username.isEmpty
            && !password.isEmpty
            && !firstName.isEmpty
            && !lastName.isEmpty
            && password == confirmPassword
    }

    private let coordinator: AppCoordinator

    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
    }

    func register() async {
        do {
            let userId = UUID().uuidString
            let account = Account(balance: 100, ownerId: userId)
            let user = User(
                id: userId,
                firstName: firstName,
                lastName: lastName,
                username: username,
                password: password,
                account: account,
                isLoggedIn: true
            )
            try await coordinator.authService.register(user: user)
            await coordinator.bootstrap()
            coordinator.navigateToRoot()
        } catch {
            alertMessage = error.localizedDescription
            showAlert = true
        }
    }

    func navigateBack() {
        coordinator.navigateBack()
    }
}
