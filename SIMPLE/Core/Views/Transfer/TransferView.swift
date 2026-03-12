//
//  TransferView.swift
//  SIMPLE
//

import SwiftUI

struct TransferView: View {
    @ObservedObject var coordinator: AppCoordinator
    @StateObject private var viewModel: TransferViewModel
    @FocusState private var isAmountFocused: Bool

    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
        _viewModel = StateObject(wrappedValue: TransferViewModel(coordinator: coordinator))
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    AppColors.loginBackgroundTop,
                    AppColors.loginBackgroundBottom
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    upperSection
                    downSection
                    balanceSection
                    if viewModel.isBalanceNegative {
                        validationMessage
                    }
                }
                .padding(.horizontal, AppLayout.paddingContent)
                .padding(.vertical, AppLayout.paddingVertical)
            }
        }
        .navigationTitle("Transfer")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if viewModel.canSend {
                    Button("Send") {
                        Task { await viewModel.send() }
                    }
                    .font(.callout.weight(.bold))
                    .foregroundStyle(AppColors.loginPrimaryText)
                    .disabled(viewModel.sendInProgress)
                }
            }
        }
        .onChange(of: viewModel.recipientUserId) { _, _ in
            viewModel.validateUserId()
        }
    }

    private var upperSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(recipientHeaderText)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(AppColors.loginSecondaryText)

            TextField("0,00", text: $viewModel.amountText)
                .keyboardType(.decimalPad)
                .font(.system(size: isAmountFocused ? 40 : 28, weight: .bold))
                .foregroundStyle(viewModel.isBalanceNegative ? Color.red : AppColors.loginPrimaryText)
                .focused($isAmountFocused)
                .animation(.easeInOut(duration: 0.25), value: isAmountFocused)
        }
        .padding(AppLayout.paddingCard)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: AppLayout.cornerRadiusCard, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: AppLayout.cornerRadiusCard, style: .continuous)
                        .stroke(Color.white.opacity(0.12), lineWidth: 1)
                )
        )
    }

    private var recipientHeaderText: String {
        if viewModel.isCheckingUserId {
            return "Checking..."
        }
        if let name = viewModel.recipientName {
            return "\(name) gets"
        }
        if viewModel.userIdValid == false {
            return "Recipient not found"
        }
        return "Recipient gets"
    }

    private var downSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("User ID")
                .font(.subheadline.weight(.medium))
                .foregroundStyle(AppColors.loginSecondaryText)

            TextField("Recipient user ID", text: $viewModel.recipientUserId)
                .textFieldStyle(.plain)
                .textContentType(.username)
                .autocapitalization(.none)
                .padding(.horizontal, AppLayout.paddingContent)
                .padding(.vertical, AppLayout.paddingVertical)
                .background(
                    RoundedRectangle(cornerRadius: AppLayout.cornerRadiusControl, style: .continuous)
                        .fill(.ultraThinMaterial)
                        .overlay(
                            RoundedRectangle(cornerRadius: AppLayout.cornerRadiusControl, style: .continuous)
                                .stroke(Color.white.opacity(0.12), lineWidth: 1)
                        )
                )
                .foregroundStyle(AppColors.loginPrimaryText)
        }
    }

    private var balanceSection: some View {
        HStack {
            Text("Amount available:")
                .font(.subheadline)
                .foregroundStyle(viewModel.isBalanceNegative ? Color.red.opacity(0.9) : AppColors.loginSecondaryText)
            Text("\(viewModel.formattedBalance) RSD")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(viewModel.isBalanceNegative ? Color.red : Color.green)
        }
    }

    private var validationMessage: some View {
        Text("Insufficient balance. After this transfer your balance would be \(viewModel.formattedBalanceAfter) RSD.")
            .font(.caption)
            .foregroundStyle(Color.red.opacity(0.9))
    }
}
