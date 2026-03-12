//
//  AuthenticationRepository.swift
//  SIMPLE
//
//  Created by Srdjan Spasojevic on 11. 3. 2026..
//

import Foundation

final class AuthenticationRepository: AuthenticationService {
    private var database: DatabaseService
    
    init(database: DatabaseService) {
        self.database = database
    }
    
    func login(username: String, password: String) async throws -> Bool {
        let user = try await database.get(where: #Predicate<User> {
            $0.username == username && $0.password == password
        })
        
        if user.isEmpty {
            throw AuthenticationError.invalidCredentials
        }
        
        return true
    }
    
    func register(user: User) async throws {
        do {
            try await database.save(user)
        } catch {
            throw AuthenticationError.registrationError
        }
    }
    
    func logout(userId: String) async throws {
        guard let fetchedUser = try await database.get(where: #Predicate<User> {
            $0.id == userId
        }).first else {
            throw AuthenticationError.logoutError
        }
        fetchedUser.isLoggedIn = false
        try await database.save(fetchedUser)
    }

    func currentUser() async -> User? {
        do {
            let users = try await database.get(where: #Predicate<User> {
                $0.isLoggedIn == true
            })
            return users.first
        } catch {
            return nil
        }
    }

    func userExists(withUserId userId: String) async -> Bool {
        do {
            let users = try await database.get(where: #Predicate<User> {
                $0.id == userId
            })
            return !users.isEmpty
        } catch {
            return false
        }
    }
}
