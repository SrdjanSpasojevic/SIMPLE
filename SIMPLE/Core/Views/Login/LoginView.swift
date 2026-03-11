//
//  LoginView.swift
//  SIMPLE
//
//  Created by Srdjan Spasojevic on 11. 3. 2026..
//

import SwiftUI

private var loginViewText = "[LOGIN VIEW] "

struct LoginView: View {
    @ObservedObject var coordinator: AppCoordinator
    @StateObject private var viewModel: LoginViewModel

    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
        _viewModel = StateObject(wrappedValue: LoginViewModel(coordinator: coordinator))
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
                        Text("Welcome back")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundStyle(AppColors.loginPrimaryText)
                        Text("Sign in to continue")
                            .font(.subheadline)
                            .foregroundStyle(AppColors.loginSecondaryText)
                    }
                    .id("loginTop")
                    .padding(.bottom, AppLayout.paddingSection)

                    VStack(spacing: 20) {
                        TextField("Username", text: $viewModel.username)
                            .textFieldStyle(.plain)
                            .textContentType(.username)
                            .autocapitalization(.none)
                            .padding(.horizontal, AppLayout.paddingContent)
                            .padding(.vertical, AppLayout.paddingVertical)
                            .glassEffect(.regular, in: .rect(cornerRadius: AppLayout.cornerRadiusControl))

                        SecureField("Password", text: $viewModel.password)
                            .textFieldStyle(.plain)
                            .textContentType(.password)
                            .padding(.horizontal, AppLayout.paddingContent)
                            .padding(.vertical, AppLayout.paddingVertical)
                            .glassEffect(.regular, in: .rect(cornerRadius: AppLayout.cornerRadiusControl))

                        Button(action: {
                            Task {
                                await viewModel.login()
                                print(loginViewText, "User is logged in: true")
                            }
                        }) {
                            Text("Sign in")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, AppLayout.paddingVertical)
                                .foregroundStyle(viewModel.canSubmit ? AppColors.loginPrimaryText : AppColors.loginDisabledText)
                        }
                        .disabled(!viewModel.canSubmit)
                        .glassEffect(
                            viewModel.canSubmit
                                ? .regular.interactive().tint(.accentColor)
                                : .identity,
                            in: .rect(cornerRadius: AppLayout.cornerRadiusControl)
                        )
                    }
                    .padding(AppLayout.paddingScreen)
                    .glassEffect(.regular.tint(.clear), in: .rect(cornerRadius: AppLayout.cornerRadiusControl))

                    Button(action: viewModel.navigateToRegister) {
                        Text("Don't have an account? **Sign up**")
                            .font(.subheadline)
                            .foregroundStyle(AppColors.loginPrimaryText.opacity(0.9))
                    }
                    .padding(.top, AppLayout.paddingSection)

                    Spacer(minLength: 80)
                }
                .padding(.horizontal, AppLayout.paddingScreen)
            }
            .onAppear {
                proxy.scrollTo("loginTop", anchor: .top)
            }
            }
        }
        .alert("Login failed", isPresented: $viewModel.showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.alertMessage.isEmpty ? "Something went wrong. Please try again." : viewModel.alertMessage)
        }
    }
}
