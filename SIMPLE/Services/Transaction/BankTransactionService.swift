//
//  BankTransactionService.swift
//  SIMPLE
//
//  Created by Srdjan Spasojevic on 11. 3. 2026..
//

import Foundation

protocol BankTransactionService: Sendable {
    func send(fromUserId: String, toUserId: String, amount: Double) async -> Result<Bool, Error>
    func checkBalance(for accountId: String) async -> Result<Double, Error>
    func accountExists(withId accountId: String) async -> Bool
}
