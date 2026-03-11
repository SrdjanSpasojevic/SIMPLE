//
//  Transaction.swift
//  SIMPLE
//
//  Created by Srdjan Spasojevic on 10. 3. 2026..
//

import Foundation
import SwiftData

@Model
final class Transaction: Identifiable {
    var id: String
    var fromAccountId: String
    var toAccountId: String
    var amount: Double
    var timestampStart: Date
    var timestampEnd: Date
    
    init(fromAccountId: String,
         toAccountId: String,
         amount: Double,
         timestampStart: Date,
         timestampEnd: Date) {
        id = UUID().uuidString
        
        self.fromAccountId = fromAccountId
        self.toAccountId = toAccountId
        self.amount = amount
        self.timestampStart = timestampStart
        self.timestampEnd = timestampEnd
    }
}
