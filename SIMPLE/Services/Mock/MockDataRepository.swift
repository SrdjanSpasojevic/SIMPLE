//
//  MockDataService.swift
//  SIMPLE
//
//  Created by Cursor on 12. 3. 2026..
//

import Foundation
import SwiftData

private var MockDataText = "[MOCK DATA] "

actor MockDataRepository: MockDataService {
    private let database: DatabaseService

    init(database: DatabaseService) {
        self.database = database
    }

    func seedUsersIfNeeded() async {
        let existingUsers = try? await database.get(where: #Predicate<User> { _ in true })
        guard (existingUsers?.isEmpty ?? true) else { return }

        let johnId = UUID().uuidString
        let janeId = UUID().uuidString
        let aliceId = UUID().uuidString
        let bobId = UUID().uuidString
        let charlieId = UUID().uuidString

        let johnAccount = Account(balance: 2500.0, ownerId: johnId)
        let janeAccount = Account(balance: 5000.0, ownerId: janeId)
        let aliceAccount = Account(balance: 1000.0, ownerId: aliceId)
        let bobAccount = Account(balance: 750.0, ownerId: bobId)
        let charlieAccount = Account(balance: 10000.0, ownerId: charlieId)

        let users: [User] = [
            User(id: johnId,
                 firstName: "John",
                 lastName: "Doe",
                 username: "john.doe",
                 password: "password1",
                 account: johnAccount,
                 isLoggedIn: false),
            User(id: janeId,
                 firstName: "Jane",
                 lastName: "Doe",
                 username: "jane.doe",
                 password: "password2",
                 account: janeAccount,
                 isLoggedIn: false),
            User(id: aliceId,
                 firstName: "Alice",
                 lastName: "Smith",
                 username: "alice.smith",
                 password: "password3",
                 account: aliceAccount,
                 isLoggedIn: false),
            User(id: bobId,
                 firstName: "Bob",
                 lastName: "Brown",
                 username: "bob.brown",
                 password: "password4",
                 account: bobAccount,
                 isLoggedIn: false),
            User(id: charlieId,
                 firstName: "Charlie",
                 lastName: "Johnson",
                 username: "charlie.johnson",
                 password: "password5",
                 account: charlieAccount,
                 isLoggedIn: false)
        ]

        do {
            try await database.performTransaction { transaction in
                for user in users {
                    print(MockDataText, "User to be saved: \(user.id) | \(user.username) | \(user.password)")
                    try transaction.save(user.account)
                    try transaction.save(user)
                }
            }
        } catch {
            print("MockDataRepository - Failed to seed users: \(error)")
        }
    }
}

