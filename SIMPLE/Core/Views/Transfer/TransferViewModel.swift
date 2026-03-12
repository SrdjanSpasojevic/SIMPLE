//
//  TransferViewModel.swift
//  SIMPLE
//

import Foundation
import Combine
import SwiftData

@MainActor
final class TransferViewModel: ObservableObject {
    @Published var recipientUserId: String = ""
    @Published var amountText: String = ""
    @Published var recipientName: String?
    @Published var userIdValid: Bool?
    @Published var isCheckingUserId: Bool = false
    @Published var sendInProgress: Bool = false
    @Published var alertMessage: String?
    @Published var isShowingAlert: Bool = false

    private let coordinator: AppCoordinator
    private let bankTransactionService: BankTransactionService
    private let databaseService: DatabaseService
    private let biometricAuthService: BiometricAuthenticationService
    private var validateTask: Task<Void, Never>?

    var currentBalance: Double {
        coordinator.currentUser?.account.balance ?? 0
    }

    var amountValue: Double {
        Self.parseAmount(amountText)
    }

    var balanceAfter: Double {
        currentBalance - amountValue
    }

    var isBalanceNegative: Bool {
        balanceAfter < 0
    }

    var canSend: Bool {
        guard let currentUserId = coordinator.currentUser?.id else { return false }
        guard userIdValid == true else { return false }
        guard amountValue > 0 else { return false }
        guard balanceAfter >= 0 else { return false }
        guard recipientUserId != currentUserId else { return false }
        return true
    }

    var formattedBalance: String {
        Self.currencyFormatter.string(from: NSNumber(value: currentBalance)) ?? "\(currentBalance)"
    }

    var formattedBalanceAfter: String {
        Self.currencyFormatter.string(from: NSNumber(value: balanceAfter)) ?? "\(balanceAfter)"
    }

    var formattedAmount: String {
        Self.currencyFormatter.string(from: NSNumber(value: amountValue)) ?? amountText
    }

    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
        self.bankTransactionService = coordinator.bankTransactionService
        self.databaseService = coordinator.databaseService
        self.biometricAuthService = coordinator.biometricAuthService
    }

    func validateUserId() {
        let id = recipientUserId.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !id.isEmpty else {
            userIdValid = nil
            recipientName = nil
            return
        }
        validateTask?.cancel()
        validateTask = Task {
            isCheckingUserId = true
            defer { isCheckingUserId = false }
            let exists = await coordinator.authService.userExists(withUserId: id)
            guard !Task.isCancelled else { return }
            userIdValid = exists
            if exists {
                let users = try? await databaseService.get(where: #Predicate<User> { $0.id == id })
                recipientName = users?.first.map { "\($0.firstName) \($0.lastName)" }
            } else {
                recipientName = nil
            }
        }
    }

    func send() async {
        guard canSend, let fromUserId = coordinator.currentUser?.id else { return }

        let reason = "Confirm transfer of \(formattedAmount) RSD"
        let authenticated = await biometricAuthService.authenticate(reason: reason)
        guard authenticated else { return }

        sendInProgress = true
        defer { sendInProgress = false }
        let result = await bankTransactionService.send(
            fromUserId: fromUserId,
            toUserId: recipientUserId.trimmingCharacters(in: .whitespacesAndNewlines),
            amount: amountValue
        )
        switch result {
        case .success:
            await coordinator.refreshCurrentUser()
            coordinator.navigateBack()
        case .failure(let error):
            let message: String
            if let localized = error as? LocalizedError, let description = localized.errorDescription {
                message = description
            } else {
                message = error.localizedDescription
            }
            alertMessage = message
            isShowingAlert = true
        }
    }

    private static func parseAmount(_ text: String) -> Double {
        let normalized = text.replacingOccurrences(of: ",", with: ".")
        return Double(normalized) ?? 0
    }

    private static let currencyFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.maximumFractionDigits = 2
        f.minimumFractionDigits = 2
        f.decimalSeparator = ","
        return f
    }()
}
