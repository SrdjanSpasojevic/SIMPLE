//
//  BiometricAuthenticationService.swift
//  SIMPLE
//
//  Created by Srdjan Spasojevic on 12. 3. 2026..
//


protocol BiometricAuthenticationService {
    var isBiometricAvailable: Bool { get }
    func authenticate(reason: String) async -> Bool
}