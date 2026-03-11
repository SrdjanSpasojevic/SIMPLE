//
//  LoginView.swift
//  SIMPLE
//
//  Created by Srdjan Spasojevic on 11. 3. 2026..
//

import SwiftUI

var loginViewText = "[LOGIN VIEW] "

struct LoginView: View {
    @ObservedObject var coordinator: AppCoordinator
    @State private var username = ""
    @State private var password = ""
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    AppColors.loginBackgroundTop,
                    AppColors.loginBackgroundBottom
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
                            .foregroundStyle(AppColors.loginPrimaryText)
                        Text("Sign in to continue")
                            .font(.subheadline)
                            .foregroundStyle(AppColors.loginSecondaryText)
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

                        Button(action: {
                            Task {
                                do {
                                    let loggedIn = try await coordinator.authService.login(username: username, password: password)
                                    print(loginViewText, "User is logged in: \(loggedIn)")
                                } catch {
                                    await MainActor.run {
                                        alertMessage = error.localizedDescription
                                        showAlert = true
                                    }
                                }
                            }
                        }) {
                            Text("Sign in")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .foregroundStyle(username.isEmpty || password.isEmpty ? AppColors.loginDisabledText : AppColors.loginPrimaryText)
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

                    Button(action: {
                        coordinator.navigate(to: .register)
                    }) {
                        Text("Don't have an account? **Sign up**")
                            .font(.subheadline)
                            .foregroundStyle(AppColors.loginPrimaryText.opacity(0.9))
                    }
                    .padding(.top, 8)

                    Spacer(minLength: 80)
                }
                .padding(.horizontal, 24)
            }
        }
        .alert("Login failed", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage.isEmpty ? "Something went wrong. Please try again." : alertMessage)
        }
    }
}
