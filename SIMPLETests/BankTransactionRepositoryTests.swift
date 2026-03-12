//
//  BankTransactionRepositoryTests.swift
//  SIMPLETests
//
//  Created by Cursor on 12. 3. 2026..
//

import Testing
import SwiftData
@testable import SIMPLE

@MainActor
struct BankTransactionRepositoryTests {

    @Test
    func sendSucceedsAndUpdatesBalances() async throws {
        let database = MockDatabaseService()

        let fromAccount = Account(balance: 1000, ownerId: "from")
        let toAccount = Account(balance: 1000, ownerId: "to")

        let fromUser = User(
            id: "from",
            firstName: "From",
            lastName: "User",
            username: "from",
            password: "pw",
            account: fromAccount,
            isLoggedIn: false
        )
        let toUser = User(
            id: "to",
            firstName: "To",
            lastName: "User",
            username: "to",
            password: "pw",
            account: toAccount,
            isLoggedIn: false
        )

        await database.enqueueUsers([fromUser])
        await database.enqueueUsers([toUser])

        let repository = BankTransactionRepository(database: database)
        let result = await repository.send(fromUserId: "from", toUserId: "to", amount: 100)

        switch result {
        case .success(let successFlag):
            #expect(successFlag == true)
        case .failure(let error):
            #expect(Bool(false), "Unexpected error: \(error)")
        }

        let balances = [fromAccount.balance, toAccount.balance].sorted()
        #expect(balances == [900, 1100])

        let savedTransactions = await database.savedModels.compactMap { $0 as? BankTransaction }
        #expect(savedTransactions.count == 1)
        #expect(savedTransactions.first?.amount == 100)
    }

    @Test
    func sendFailsWithInsufficientFunds() async {
        let database = MockDatabaseService()

        let fromAccount = Account(balance: 50, ownerId: "from")
        let toAccount = Account(balance: 100, ownerId: "to")

        let fromUser = User(
            id: "from",
            firstName: "From",
            lastName: "User",
            username: "from",
            password: "pw",
            account: fromAccount,
            isLoggedIn: false
        )
        let toUser = User(
            id: "to",
            firstName: "To",
            lastName: "User",
            username: "to",
            password: "pw",
            account: toAccount,
            isLoggedIn: false
        )

        await database.enqueueUsers([fromUser])
        await database.enqueueUsers([toUser])

        let repository = BankTransactionRepository(database: database)
        let result = await repository.send(fromUserId: "from", toUserId: "to", amount: 100)

        switch result {
        case .success:
            #expect(Bool(false), "Expected insufficientFunds error")
        case .failure(let error as BankTransactionError):
            #expect(error == .insufficientFunds)
        case .failure(let error):
            #expect(Bool(false), "Unexpected error: \(error)")
        }

        #expect(fromAccount.balance == 50)
        #expect(toAccount.balance == 100)
    }

    @Test
    func sendFailsWhenUserMissing() async {
        let database = MockDatabaseService()

        await database.enqueueUsers([])
        await database.enqueueUsers([])

        let repository = BankTransactionRepository(database: database)
        let result = await repository.send(fromUserId: "from", toUserId: "to", amount: 10)

        switch result {
        case .success:
            #expect(Bool(false), "Expected incorrectToAccountNumber error")
        case .failure(let error as BankTransactionError):
            #expect(error == .incorrectToAccountNumber)
        case .failure(let error):
            #expect(Bool(false), "Unexpected error: \(error)")
        }
    }

    @Test
    func checkBalanceReturnsAccountBalance() async throws {
        let database = MockDatabaseService()
        let account = Account(balance: 123.45, ownerId: "owner")
        await database.enqueueAccounts([account])

        let repository = BankTransactionRepository(database: database)
        let result = await repository.checkBalance(for: account.id)

        switch result {
        case .success(let balance):
            #expect(balance == 123.45)
        case .failure(let error):
            #expect(Bool(false), "Unexpected error: \(error)")
        }
    }

    @Test
    func checkBalanceReturnsErrorWhenAccountMissing() async {
        let database = MockDatabaseService()
        await database.enqueueAccounts([])

        let repository = BankTransactionRepository(database: database)
        let result = await repository.checkBalance(for: "missing")

        switch result {
        case .success:
            #expect(Bool(false), "Expected somethingWentWrong error")
        case .failure(let error as BankTransactionError):
            #expect(error == .somethingWentWrong)
        case .failure(let error):
            #expect(Bool(false), "Unexpected error: \(error)")
        }
    }

    @Test
    func accountExistsReturnsTrueWhenAccountFound() async throws {
        let database = MockDatabaseService()
        let account = Account(balance: 10, ownerId: "owner")
        await database.enqueueAccounts([account])

        let repository = BankTransactionRepository(database: database)
        let exists = await repository.accountExists(withId: account.id)

        #expect(exists == true)
    }

    @Test
    func accountExistsReturnsFalseOnError() async throws {
        struct DummyError: Error {}

        let database = MockDatabaseService()
        await database.setAccountFetchError(DummyError())

        let repository = BankTransactionRepository(database: database)
        let exists = await repository.accountExists(withId: "any")

        #expect(exists == false)
    }
}

