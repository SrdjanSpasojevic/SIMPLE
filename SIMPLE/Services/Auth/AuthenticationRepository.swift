//
//  AuthenticationRepository.swift
//  SIMPLE
//
//  Created by Srdjan Spasojevic on 11. 3. 2026..
//

import Foundation

final class AuthenticationRepository: AuthService {
    private var database: DatabaseService
    
    init(database: DatabaseService) {
        self.database = database
    }
    
    func login(username: String, password: String) async throws -> Bool {
        let user = try await database.get(where: #Predicate<User> {
            $0.username == username && $0.password == password
        })
        
        if user.isEmpty {
            throw AuthError.invalidCredentials
        }
        
        return true
    }
    
    func register(user: User) async throws {
        do {
            try await database.save(user)
        } catch {
            throw AuthError.registrationError
        }
    }
    
    func logout(userId: String) async throws {
        guard let fetchedUser = try await database.get(where: #Predicate<User> {
            $0.id == userId
        }).first else {
            throw AuthError.logoutError
        }
        fetchedUser.isLoggedIn = false
        try await database.save(fetchedUser)
    }
}
