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

    func send(fromUserId: String, toUserId: String, amount: Double) async -> Result<Bool, Error> {
        async let fromUsers = database.get(where: #Predicate<User> {
            $0.id == fromUserId
        })
        async let toUsers = database.get(where: #Predicate<User> {
            $0.id == toUserId
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
                fromUserId: fromUserId,
                toUserId: toUserId,
                amount: amount,
                timestamp: Date()
            )

            do {
                try await database.performTransaction { transactionDb in
                    try transactionDb.save(bankTransaction)

                    from.account.balance -= amount
                    to.account.balance += amount
                    try transactionDb.save(from)
                    try transactionDb.save(to)
                }
                return .success(true)
            } catch {
                return .failure(error)
            }
        } catch {
            return .failure(error)
        }
    }
    
    func checkBalance(for accountId: String) async -> Result<Double, Error> {
        do {
            guard let fetchedAccount = try await database.get(where: #Predicate<Account> {
                $0.id == accountId
            }).first else {
                return .failure(BankTransactionError.somethingWentWrong)
            }
            return .success(fetchedAccount.balance)
        } catch {
            return .failure(BankTransactionError.somethingWentWrong)
        }
    }
    
    func accountExists(withId accountId: String) async -> Bool {
        do {
            let accounts = try await database.get(where: #Predicate<Account> {
                $0.id == accountId
            })
            return !accounts.isEmpty
        } catch {
            return false
        }
    }
}
