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
    var fromAccountId: String
    var toAccountId: String
    var amount: Double
    var timestamp: Date
    
    init(fromAccountId: String,
         toAccountId: String,
         amount: Double,
         timestamp: Date) {
        id = UUID().uuidString
        
        self.fromAccountId = fromAccountId
        self.toAccountId = toAccountId
        self.amount = amount
        self.timestamp = timestamp
    }
}
