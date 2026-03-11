//
//  BankTransactionError.swift
//  SIMPLE
//
//  Created by Srdjan Spasojevic on 11. 3. 2026..
//

import Foundation

enum BankTransactionError: Error, LocalizedError {
    case insufficientFunds
    case incorrectToAccountNumber

    var errorDescription: String? {
        switch self {
        case .insufficientFunds:
            return "Your account ballance is insuficient to complete this transaction, please add funds"
        case .incorrectToAccountNumber:
            return "The account you are trying to send money to doesn't exist"
        }
    }
}
