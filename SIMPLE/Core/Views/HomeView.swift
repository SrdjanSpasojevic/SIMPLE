//
//  HomeView.swift
//  SIMPLE
//
//  Created by Srdjan Spasojevic on 11. 3. 2026..
//


import SwiftUI
struct HomeView: View {
    @ObservedObject var coordinator: AppCoordinator
    @State private var text = ""
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            let text = coordinator.currentUser?.username ?? "Loading..."
            Text(text)
                .foregroundStyle(.white)
                .font(.largeTitle.bold())
            
        }
    }
}
