//
//  BankTransactionRepository.swift
//  SIMPLE
//
//  Created by Srdjan Spasojevic on 11. 3. 2026..
//

import Foundation

final class BankTransactionRepository: BankTransactionService {
    private var database: DatabaseService
    
    init(database: DatabaseService) {
        self.database = database
    }

    func send(fromAccountId: String, toAccountId: String, amount: Double) async -> Result<Bool, Error> {
        async let fromUsers = database.get(where: #Predicate<User> {
            $0.id == fromAccountId
        })
        async let toUsers = database.get(where: #Predicate<User> {
            $0.id == toAccountId
        })

        do {
            let (fromResult, toResult) = try await (fromUsers, toUsers)

            guard let from = fromResult.first,
                  let to = toResult.first else {
                return .failure(BankTransactionError.incorrectToAccountNumber)
            }

            let balanceAfterTransaction = from.account.balance - amount
            guard balanceAfterTransaction >= 0 else {
                return .failure(BankTransactionError.insufficientFunds)
            }

            let bankTransaction = BankTransaction(
                fromAccountId: fromAccountId,
                toAccountId: toAccountId,
                amount: amount,
                timestamp: Date()
            )

            do {
                try await database.performTransaction { transactionDb in
                    from.account.balance -= amount
                    to.account.balance += amount
                    try transactionDb.save(from)
                    try transactionDb.save(to)
                    try transactionDb.save(bankTransaction)
                }
                return .success(true)
            } catch {
                return .failure(error)
            }
        } catch {
            return .failure(error)
        }
    }
    
    func checkBalance(for accountId: String) throws -> Result<Double, Error> {
        return .failure(BankTransactionError.incorrectToAccountNumber)
    }
    
    func accountExists(withId accountId: String) -> Bool {
        return false
    }
}
