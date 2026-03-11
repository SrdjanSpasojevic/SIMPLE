//
//  BankTransaction.swift
//  SIMPLE
//
//  Created by Srdjan Spasojevic on 10. 3. 2026..
//

import Foundation
import SwiftData

@Model
final class BankTransaction: Identifiable {
    var id: String
    var fromUserId: String
    var toUserId: String
    var amount: Double
    var timestamp: Date
    
    init(fromUserId: String,
         toUserId: String,
         amount: Double,
         timestamp: Date) {
        id = UUID().uuidString
        
        self.fromUserId = fromUserId
        self.toUserId = toUserId
        self.amount = amount
        self.timestamp = timestamp
    }
}
