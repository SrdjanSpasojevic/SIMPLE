//
//  User.swift
//  SIMPLE
//
//  Created by Srdjan Spasojevic on 10. 3. 2026..
//

import Foundation
import SwiftData

@Model
final class User: Identifiable, Sendable {
    var id: String
    var firstName: String
    var lastName: String
    var username: String
    var password: String
    var account: Account
    var isLoggedIn: Bool
    
    init(firstName: String,
         lastName: String,
         username: String,
         password: String,
         account: Account) {
        self.id = UUID().uuidString
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
        self.password = password
        self.account = account
        self.isLoggedIn = false
    }
}
