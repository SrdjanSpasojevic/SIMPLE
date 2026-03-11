//
//  DatabaseError.swift
//  SIMPLE
//
//  Created by Srdjan Spasojevic on 11. 3. 2026..
//

import Foundation

enum DatabaseError: Error, LocalizedError {
    case generalError(String)

    var errorDescription: String? {
        switch self {
        case .generalError(let message):
            return "Database error occurred when \(message)"
        }
    }
}
