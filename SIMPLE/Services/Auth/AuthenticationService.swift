//
//  AuthService.swift
//  SIMPLE
//
//  Created by Srdjan Spasojevic on 11. 3. 2026..
//

import Foundation

protocol AuthenticationService {
    func login(username: String, password: String) async throws -> Bool
    func register(user: User) async throws
    func logout(userId: String) async throws
    func currentUser() async -> User?
    func userExists(withUserId userId: String) async -> Bool
}
