//
//  TransactionService.swift
//  SIMPLE
//
//  Created by Srdjan Spasojevic on 11. 3. 2026..
//

import Foundation

protocol TransactionService: Sendable {
    func send(fromAccountId: String, toAccountId: String, ammount: Double) async throws -> Result<Bool, Error>
    func checkBalance(for accountId: String) throws -> Result<Double, Error>
    func accountExists(withId accountId: String) -> Bool
}
