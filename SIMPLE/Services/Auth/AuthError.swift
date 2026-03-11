//
//  AuthError.swift
//  SIMPLE
//
//  Created by Srdjan Spasojevic on 11. 3. 2026..
//

import Foundation

enum AuthError: Error, LocalizedError {
    case invalidCredentials
    case registrationError
    case logoutError

    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "The username or password you entered is incorrect."
        case .registrationError:
            return "An error occurred while creating your account. Please try again."
        case .logoutError:
            return "An error occurred while logging out. Please try again."
        }
    }
}
