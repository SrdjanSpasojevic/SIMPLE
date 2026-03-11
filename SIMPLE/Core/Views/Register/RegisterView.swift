//
//  RegisterView.swift
//  SIMPLE
//
//  Created by Srdjan Spasojevic on 11. 3. 2026..
//

import SwiftUI

private var registerViewText = "[REGISTER VIEW] "

struct RegisterView: View {
    @ObservedObject var coordinator: AppCoordinator
    @StateObject private var viewModel: RegisterViewModel

    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
        _viewModel = StateObject(wrappedValue: RegisterViewModel(coordinator: coordinator))
    }

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

            ScrollViewReader { proxy in
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
                    .id("registerTop")
                    .padding(.bottom, AppLayout.paddingSection)

                    VStack(spacing: 20) {
                        TextField("First name", text: $viewModel.firstName)
                            .textFieldStyle(.plain)
                            .textContentType(.givenName)
                            .autocapitalization(.words)
                            .padding(.horizontal, AppLayout.paddingContent)
                            .padding(.vertical, AppLayout.paddingVertical)
                            .glassEffect(.regular, in: .rect(cornerRadius: AppLayout.cornerRadiusControl))

                        TextField("Last name", text: $viewModel.lastName)
                            .textFieldStyle(.plain)
                            .textContentType(.familyName)
                            .autocapitalization(.words)
                            .padding(.horizontal, AppLayout.paddingContent)
                            .padding(.vertical, AppLayout.paddingVertical)
                            .glassEffect(.regular, in: .rect(cornerRadius: AppLayout.cornerRadiusControl))

                        TextField("Username", text: $viewModel.username)
                            .textFieldStyle(.plain)
                            .textContentType(.username)
                            .autocapitalization(.none)
                            .padding(.horizontal, AppLayout.paddingContent)
                            .padding(.vertical, AppLayout.paddingVertical)
                            .glassEffect(.regular, in: .rect(cornerRadius: AppLayout.cornerRadiusControl))

                        SecureField("Password", text: $viewModel.password)
                            .textFieldStyle(.plain)
                            .textContentType(.newPassword)
                            .padding(.horizontal, AppLayout.paddingContent)
                            .padding(.vertical, AppLayout.paddingVertical)
                            .glassEffect(.regular, in: .rect(cornerRadius: AppLayout.cornerRadiusControl))

                        SecureField("Confirm password", text: $viewModel.confirmPassword)
                            .textFieldStyle(.plain)
                            .textContentType(.newPassword)
                            .padding(.horizontal, AppLayout.paddingContent)
                            .padding(.vertical, AppLayout.paddingVertical)
                            .glassEffect(.regular, in: .rect(cornerRadius: AppLayout.cornerRadiusControl))

                        Button(action: {
                            Task {
                                await viewModel.register()
                                print(registerViewText, "Registration success for username: \(viewModel.username)")
                            }
                        }) {
                            Text("Sign up")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, AppLayout.paddingVertical)
                                .foregroundStyle(
                                    viewModel.isFormValid
                                        ? AppColors.loginPrimaryText
                                        : AppColors.loginDisabledText
                                )
                        }
                        .disabled(!viewModel.isFormValid)
                        .glassEffect(
                            viewModel.isFormValid
                                ? .regular.interactive().tint(.accentColor)
                                : .identity,
                            in: .rect(cornerRadius: AppLayout.cornerRadiusControl)
                        )
                    }
                    .padding(AppLayout.paddingScreen)
                    .glassEffect(.regular.tint(.clear), in: .rect(cornerRadius: AppLayout.cornerRadiusControl))

                    Button(action: viewModel.navigateBack) {
                        Text("Already have an account? **Sign in**")
                            .font(.subheadline)
                            .foregroundStyle(AppColors.loginPrimaryText.opacity(0.9))
                    }
                    .padding(.top, AppLayout.paddingSection)

                    Spacer(minLength: 80)
                }
                .padding(.horizontal, AppLayout.paddingScreen)
            }
            .onAppear {
                proxy.scrollTo("registerTop", anchor: .top)
            }
            }
        }
        .alert("Registration failed", isPresented: $viewModel.showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.alertMessage.isEmpty ? "Something went wrong. Please try again." : viewModel.alertMessage)
        }
    }
}
