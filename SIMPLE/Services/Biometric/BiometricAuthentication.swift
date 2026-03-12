//
//  BiometricAuthService.swift
//  SIMPLE
//
//  Created by Cursor on 12. 3. 2026..
//

import Foundation
import LocalAuthentication

final class BiometricAuthentication: BiometricAuthenticationService {
    private let context: LAContext

    init(context: LAContext = LAContext()) {
        self.context = context
    }

    var isBiometricAvailable: Bool {
        var error: NSError?
        let canEvaluate = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        return canEvaluate
    }

    func authenticate(reason: String) async -> Bool {
        let context = LAContext()
        var error: NSError?

        let canEvaluate = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        guard canEvaluate else {
            return false
        }

        return await withCheckedContinuation { continuation in
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, _ in
                continuation.resume(returning: success)
            }
        }
    }
}

