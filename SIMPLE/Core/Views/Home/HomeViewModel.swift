//
//  HomeViewModel.swift
//  SIMPLE
//
//  Created by Cursor on 11. 3. 2026..
//

import Foundation
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var greeting: String = ""
    @Published var currentBalance: String = ""
    @Published var transactions: [HomeTransactionRow] = []
    @Published var isLoading: Bool = false

    private let coordinator: AppCoordinator
    private let database: DatabaseService

    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
        self.database = coordinator.databaseService
    }

    func load() {
        Task {
            await refresh()
        }
    }

    func logout() async {
        guard let currentUserId = coordinator.currentUser?.id else {
            return
        }
        
        do {
            try await coordinator.authService.logout(userId: currentUserId)
            coordinator.currentUser = nil
            coordinator.navigateToRoot()
        } catch {
            return
        }
    }

    private func refresh() async {
        guard let user = coordinator.currentUser else { return }

        isLoading = true
        defer { isLoading = false }

        let userId = user.id
        let dbTransactions = (try? await database.get(where: #Predicate<BankTransaction> {
            $0.fromUserId == userId || $0.toUserId == userId
        })) ?? []

        greeting = "Hi, \(user.firstName)"
        currentBalance = Self.currencyFormatter.string(from: NSNumber(value: user.account.balance))
            ?? "\(user.account.balance) RSD"

        let sortedTransactions = dbTransactions.sorted { $0.timestamp > $1.timestamp }

        var rows: [HomeTransactionRow] = []
        rows.reserveCapacity(sortedTransactions.count)

        for transaction in sortedTransactions {
            let direction: TransactionDirection = transaction.fromUserId == user.id ? .outgoing : .incoming
            let otherUserId = direction == .outgoing ? transaction.toUserId : transaction.fromUserId

            let users = try? await database.get(where: #Predicate<User> {
                $0.id == otherUserId
            })
            let otherUser = users?.first
            let counterpartyName: String

            if let otherUser {
                counterpartyName = "\(otherUser.firstName) \(otherUser.lastName)"
            } else {
                counterpartyName = "Unknown"
            }

            let signedAmountPrefix = direction == .outgoing ? "-" : "+"
            let formattedAmount = Self.currencyFormatter.string(from: NSNumber(value: transaction.amount))
                ?? "\(transaction.amount) RSD"
            let amountWithSign = "\(signedAmountPrefix) \(formattedAmount)"

            let dateString = Self.dateFormatter.string(from: transaction.timestamp)

            let row = HomeTransactionRow(
                id: transaction.id,
                counterpartyName: counterpartyName,
                amountFormatted: amountWithSign,
                dateFormatted: dateString,
                direction: direction
            )

            rows.append(row)
        }

        transactions = rows
    }

    private static let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "RSD"
        formatter.currencySymbol = "RSD"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.locale = Locale(identifier: "sr_RS")
        return formatter
    }()

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
}

enum TransactionDirection {
    case incoming
    case outgoing
}

struct HomeTransactionRow: Identifiable, Hashable {
    let id: String
    let counterpartyName: String
    let amountFormatted: String
    let dateFormatted: String
    let direction: TransactionDirection
}

