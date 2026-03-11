//
//  LoginView.swift
//  SIMPLE
//
//  Created by Srdjan Spasojevic on 11. 3. 2026..
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var coordinator: AppCoordinator
    @State private var username = ""
    @State private var password = ""

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.35, green: 0.18, blue: 0.55),  // rich violet
                    Color(red: 0.08, green: 0.22, blue: 0.42)   // deep teal-blue
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 28) {
                    Spacer(minLength: 60)

                    VStack(spacing: 8) {
                        Text("Welcome back")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                        Text("Sign in to continue")
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.7))
                    }
                    .padding(.bottom, 8)

                    VStack(spacing: 20) {
                        TextField("Username", text: $username)
                            .textFieldStyle(.plain)
                            .textContentType(.username)
                            .autocapitalization(.none)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                            .glassEffect(.regular, in: .rect(cornerRadius: 14))

                        SecureField("Password", text: $password)
                            .textFieldStyle(.plain)
                            .textContentType(.password)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                            .glassEffect(.regular, in: .rect(cornerRadius: 14))

                        Button(action: {}) {
                            Text("Sign in")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .foregroundStyle(username.isEmpty || password.isEmpty ? .gray : .white)
                        }
                        .disabled(username.isEmpty || password.isEmpty)
                        .glassEffect(
                            username.isEmpty || password.isEmpty
                                ? .identity
                                : .regular.interactive().tint(.accentColor),
                            in: .rect(cornerRadius: 14)
                        )
                    }
                    .padding(24)
                    .glassEffect(.regular, in: .rect(cornerRadius: 14))

                    Button(action: { coordinator.navigate(to: .register) }) {
                        Text("Don't have an account? **Sign up**")
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.9))
                    }
                    .padding(.top, 8)

                    Spacer(minLength: 80)
                }
                .padding(.horizontal, 24)
            }
        }
    }
}
