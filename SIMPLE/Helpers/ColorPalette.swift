//
//  ColorPalette.swift
//  SIMPLE
//
//  Created by Srdjan Spasojevic on 11. 3. 2026..
//

import SwiftUI

enum AppColors {
    static let loginBackgroundTop = Color(red: 0.35, green: 0.18, blue: 0.55)  // rich violet
    static let loginBackgroundBottom = Color(red: 0.08, green: 0.22, blue: 0.42)  // deep teal-blue

    // MARK: Text
    static let loginPrimaryText = Color.white
    static let loginSecondaryText = Color.white.opacity(0.7)
    static let loginDisabledText = Color.gray
}

enum AppLayout {
    static let cornerRadiusCard: CGFloat = 24
    static let cornerRadiusRow: CGFloat = 18
    static let cornerRadiusControl: CGFloat = 14

    static let paddingScreen: CGFloat = 24
    static let paddingContent: CGFloat = 20
    static let paddingVertical: CGFloat = 16
    static let paddingCard: CGFloat = 14
    static let paddingSection: CGFloat = 8
}

