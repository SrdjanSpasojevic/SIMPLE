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
        NavigationStack(path: $coordinator.navigationPath) {
            Group {
                if coordinator.currentUser != nil {
                    HomeView(coordinator: coordinator)
                } else {
                    LoginView(coordinator: coordinator)
                }
            }
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .login:
                        LoginView(coordinator: coordinator)
                    case .register:
                        RegisterView(coordinator: coordinator)
                    case .home:
                        HomeView(coordinator: coordinator)
                    case .transfer:
                        #warning("TRANSFER VC")
                    }
                }
        }
        .task {
            await coordinator.bootstrap()
        }
    }
}
