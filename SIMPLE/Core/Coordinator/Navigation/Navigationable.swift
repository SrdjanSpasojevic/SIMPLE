//
//  Navigationable.swift
//  SIMPLE
//
//  Created by Srdjan Spasojevic on 11. 3. 2026..
//

import Combine
import SwiftUI

protocol Navigationable: ObservableObject {
    var navigationPath: NavigationPath { get set }
    
    func navigate(to route: Route)
    func navigateBack()
    func navigateToRoot()
}
