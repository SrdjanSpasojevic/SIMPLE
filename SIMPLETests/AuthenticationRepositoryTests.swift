//
//  AuthenticationRepositoryTests.swift
//  SIMPLETests
//
//  Created by Cursor on 12. 3. 2026..
//

import Testing
import SwiftData
@testable import SIMPLE

@MainActor
struct AuthenticationRepositoryTests {

    @Test
    func loginSucceedsWithValidCredentials() async throws {
        let database = MockDatabaseService()
        let account = Account(balance: 1000, ownerId: "user-1")
        let user = User(
            id: "user-1",
            firstName: "John",
            lastName: "Doe",
            username: "john.doe",
            password: "password1",
            account: account,
            isLoggedIn: false
        )
        await database.enqueueUsers([user])

        let repository = AuthenticationRepository(database: database)
        let result = try await repository.login(username: "john.doe", password: "password1")

        #expect(result == true)
        #expect(user.isLoggedIn == true)
        let savedUsers = await database.savedModels.compactMap { $0 as? User }
        #expect(savedUsers.contains(where: { $0.id == user.id && $0.isLoggedIn }))
    }

    @Test
    func loginFailsWithInvalidCredentials() async {
        let database = MockDatabaseService()
        await database.enqueueUsers([])
        let repository = AuthenticationRepository(database: database)

        do {
            _ = try await repository.login(username: "wrong", password: "wrong")
            #expect(Bool(false), "Expected invalidCredentials error")
        } catch let error as AuthenticationError {
            #expect(error == .invalidCredentials)
        } catch {
            #expect(Bool(false), "Unexpected error: \(error)")
        }
    }

    @Test
    func registerSavesUser() async throws {
        let database = MockDatabaseService()
        let repository = AuthenticationRepository(database: database)

        let account = Account(balance: 50, ownerId: "user-2")
        let user = User(
            id: "user-2",
            firstName: "Jane",
            lastName: "Doe",
            username: "jane.doe",
            password: "password2",
            account: account,
            isLoggedIn: false
        )

        try await repository.register(user: user)
        let savedUsers = await database.savedModels.compactMap { $0 as? User }
        #expect(savedUsers.contains(where: { $0.id == user.id }))
    }

    @Test
    func registerMapsDatabaseErrorsToRegistrationError() async {
        struct DummyError: Error {}

        let database = MockDatabaseService()
        await database.setSaveError(DummyError())
        let repository = AuthenticationRepository(database: database)

        let account = Account(balance: 0, ownerId: "user-3")
        let user = User(
            id: "user-3",
            firstName: "Alice",
            lastName: "Smith",
            username: "alice",
            password: "pw",
            account: account,
            isLoggedIn: false
        )

        do {
            try await repository.register(user: user)
            #expect(Bool(false), "Expected registrationError")
        } catch let error as AuthenticationError {
            #expect(error == .registrationError)
        } catch {
            #expect(Bool(false), "Unexpected error: \(error)")
        }
    }

    @Test
    func logoutClearsIsLoggedInFlag() async throws {
        let database = MockDatabaseService()
        let account = Account(balance: 10, ownerId: "user-4")
        let user = User(
            id: "user-4",
            firstName: "Bob",
            lastName: "Brown",
            username: "bob",
            password: "pw",
            account: account,
            isLoggedIn: true
        )
        await database.enqueueUsers([user])

        let repository = AuthenticationRepository(database: database)
        try await repository.logout(userId: "user-4")

        #expect(user.isLoggedIn == false)
        let savedUsers = await database.savedModels.compactMap { $0 as? User }
        #expect(savedUsers.contains(where: { $0.id == user.id && $0.isLoggedIn == false }))
    }

    @Test
    func logoutThrowsWhenUserNotFound() async {
        let database = MockDatabaseService()
        await database.enqueueUsers([])
        let repository = AuthenticationRepository(database: database)

        do {
            try await repository.logout(userId: "missing")
            #expect(Bool(false), "Expected logoutError")
        } catch let error as AuthenticationError {
            #expect(error == .logoutError)
        } catch {
            #expect(Bool(false), "Unexpected error: \(error)")
        }
    }

    @Test
    func currentUserReturnsLoggedInUser() async throws {
        let database = MockDatabaseService()
        let account = Account(balance: 10, ownerId: "user-5")
        let loggedIn = User(
            id: "user-5",
            firstName: "John",
            lastName: "Doe",
            username: "john",
            password: "pw",
            account: account,
            isLoggedIn: true
        )
        let loggedOut = User(
            id: "user-6",
            firstName: "Jane",
            lastName: "Doe",
            username: "jane",
            password: "pw",
            account: Account(balance: 10, ownerId: "user-6"),
            isLoggedIn: false
        )
        await database.enqueueUsers([loggedIn, loggedOut])

        let repository = AuthenticationRepository(database: database)
        let current = await repository.currentUser()

        #expect(current?.id == loggedIn.id)
    }

    @Test
    func userExistsReturnsTrueWhenUserFound() async throws {
        let database = MockDatabaseService()
        let account = Account(balance: 10, ownerId: "user-7")
        let user = User(
            id: "user-7",
            firstName: "User",
            lastName: "Seven",
            username: "user7",
            password: "pw",
            account: account,
            isLoggedIn: false
        )
        await database.enqueueUsers([user])

        let repository = AuthenticationRepository(database: database)
        let exists = await repository.userExists(withUserId: "user-7")

        #expect(exists == true)
    }

    @Test
    func userExistsReturnsFalseOnError() async throws {
        struct DummyError: Error {}

        let database = MockDatabaseService()
        await database.setUserFetchError(DummyError())

        let repository = AuthenticationRepository(database: database)
        let exists = await repository.userExists(withUserId: "any")

        #expect(exists == false)
    }
}

