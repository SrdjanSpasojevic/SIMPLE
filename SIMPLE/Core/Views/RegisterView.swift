//
//  RegisterView.swift
//  SIMPLE
//
//  Created by Srdjan Spasojevic on 11. 3. 2026..
//

import SwiftUI

var registerViewText = "[REGISTER VIEW] "

struct RegisterView: View {
    @ObservedObject var coordinator: AppCoordinator
    @State private var username = ""
    @State private var password = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var confirmPassword = ""
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
                        Text("Create account")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundStyle(AppColors.loginPrimaryText)
                        Text("Sign up to get started")
                            .font(.subheadline)
                            .foregroundStyle(AppColors.loginSecondaryText)
                    }
                    .padding(.bottom, 8)

                    VStack(spacing: 20) {
                        TextField("First name", text: $firstName)
                            .textFieldStyle(.plain)
                            .textContentType(.username)
                            .autocapitalization(.none)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                            .glassEffect(.regular, in: .rect(cornerRadius: 14))
                        TextField("First name", text: $lastName)
                            .textFieldStyle(.plain)
                            .textContentType(.username)
                            .autocapitalization(.none)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                            .glassEffect(.regular, in: .rect(cornerRadius: 14))
                        TextField("Username", text: $username)
                            .textFieldStyle(.plain)
                            .textContentType(.username)
                            .autocapitalization(.none)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                            .glassEffect(.regular, in: .rect(cornerRadius: 14))

                        SecureField("Password", text: $password)
                            .textFieldStyle(.plain)
                            .textContentType(.newPassword)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                            .glassEffect(.regular, in: .rect(cornerRadius: 14))

                        SecureField("Confirm password", text: $confirmPassword)
                            .textFieldStyle(.plain)
                            .textContentType(.newPassword)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                            .glassEffect(.regular, in: .rect(cornerRadius: 14))

                        Button(action: {
                            Task {
                                do {
                                    let userId = UUID().uuidString
                                    let account = Account(balance: 100,
                                                          ownerId: userId,
                                                          transactions: nil)
                                    let user = User(id: userId,
                                                    firstName: firstName,
                                                    lastName: lastName,
                                                    username: username,
                                                    password: password,
                                                    account: account)
                                    try await coordinator.authService.register(user: user)
                                    print(registerViewText, "Registration success for username: \(username)")
                                } catch {
                                    await MainActor.run {
                                        alertMessage = error.localizedDescription
                                        showAlert = true
                                    }
                                }
                            }
                        }) {
                            Text("Sign up")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .foregroundStyle(
                                    isFormValid
                                    ? AppColors.loginPrimaryText
                                    : AppColors.loginDisabledText
                                )
                        }
                        .disabled(!isFormValid)
                        .glassEffect(
                            isFormValid
                                ? .regular.interactive().tint(.accentColor)
                                : .identity,
                            in: .rect(cornerRadius: 14)
                        )
                    }
                    .padding(24)
                    .glassEffect(.regular, in: .rect(cornerRadius: 14))

                    Button(action: {
                        coordinator.navigateBack()
                    }) {
                        Text("Already have an account? **Sign in**")
                            .font(.subheadline)
                            .foregroundStyle(AppColors.loginPrimaryText.opacity(0.9))
                    }
                    .padding(.top, 8)

                    Spacer(minLength: 80)
                }
                .padding(.horizontal, 24)
            }
            .alert("Registration failed", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage.isEmpty ? "Something went wrong. Please try again." : alertMessage)
            }
        }
    }
    

    private var isFormValid: Bool {
        !username.isEmpty && !password.isEmpty && password == confirmPassword
    }
}

