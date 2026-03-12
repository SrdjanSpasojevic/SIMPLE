//
//  Account.swift
//  SIMPLE
//
//  Created by Srdjan Spasojevic on 11. 3. 2026..
//

import Foundation
import SwiftData

@Model
final class Account: Identifiable {
    var id: String
    var balance: Double
    var ownerId: String
    
    init(balance: Double,
         ownerId: String) {
        self.id = UUID().uuidString
        self.balance = balance
        self.ownerId = ownerId
    }
}
