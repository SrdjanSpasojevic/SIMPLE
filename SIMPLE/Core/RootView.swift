//
//  RootView.swift
//  SIMPLE
//
//  Created by Srdjan Spasojevic on 11. 3. 2026..
//

import SwiftUI
import SwiftData

struct RootView: View {
    let container: ModelContainer
    @StateObject private var coordinator: AppCoordinator

    init(container: ModelContainer) {
        self.container = container
        _coordinator = StateObject(wrappedValue: AppCoordinator(container: container))
    }

    var body: some View {
        LoginView(coordinator: coordinator)
    }
}
