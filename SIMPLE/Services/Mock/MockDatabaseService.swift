//
//  MockDatabaseService.swift
//  SIMPLE
//
//  Created by Cursor on 12. 3. 2026..
//

import Foundation
import SwiftData

actor MockDatabaseService: DatabaseService {
    var queuedUserResults: [[User]] = []
    var queuedAccountResults: [[Account]] = []
    var queuedTransactionResults: [[BankTransaction]] = []

    private(set) var savedModels: [Any] = []
    private(set) var removedModels: [Any] = []

    var userFetchError: Error?
    var accountFetchError: Error?
    var transactionFetchError: Error?
    var saveError: Error?

    func enqueueUsers(_ users: [User]) {
        queuedUserResults.append(users)
    }

    func enqueueAccounts(_ accounts: [Account]) {
        queuedAccountResults.append(accounts)
    }

    func enqueueTransactions(_ transactions: [BankTransaction]) {
        queuedTransactionResults.append(transactions)
    }

    func get<T: PersistentModel>(where predicate: Predicate<T>?) async throws -> [T] {
        if T.self == User.self {
            if let error = userFetchError { throw error }
            if !queuedUserResults.isEmpty {
                return queuedUserResults.removeFirst() as! [T]
            }
            return [] as [T]
        } else if T.self == Account.self {
            if let error = accountFetchError { throw error }
            if !queuedAccountResults.isEmpty {
                return queuedAccountResults.removeFirst() as! [T]
            }
            return [] as [T]
        } else if T.self == BankTransaction.self {
            if let error = transactionFetchError { throw error }
            if !queuedTransactionResults.isEmpty {
                return queuedTransactionResults.removeFirst() as! [T]
            }
            return [] as [T]
        }

        return [] as [T]
    }

    func save<T: PersistentModel>(_ model: T) async throws {
        if let error = saveError {
            throw error
        }
        savedModels.append(model)
    }

    func remove<T: PersistentModel>(_ model: T) async throws {
        removedModels.append(model)
    }

    func performTransaction(_ operations: (TransactionDatabase) throws -> Void) async throws {
        let transactionContext = MockTransactionDatabase(recorder: self)
        try operations(transactionContext)
    }
}

private struct MockTransactionDatabase: TransactionDatabase {
    let recorder: MockDatabaseService

    func save<T: PersistentModel>(_ model: T) throws {
        Task { await recorder.saveFromTransaction(model) }
    }

    func remove<T: PersistentModel>(_ model: T) throws {
        Task { await recorder.removeFromTransaction(model) }
    }
}

extension MockDatabaseService {
    fileprivate func saveFromTransaction<T: PersistentModel>(_ model: T) {
        savedModels.append(model)
    }

    fileprivate func removeFromTransaction<T: PersistentModel>(_ model: T) {
        removedModels.append(model)
    }

    func setUserFetchError(_ error: Error?) {
        userFetchError = error
    }

    func setAccountFetchError(_ error: Error?) {
        accountFetchError = error
    }

    func setSaveError(_ error: Error?) {
        saveError = error
    }
}


