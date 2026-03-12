//
//  HomeView.swift
//  SIMPLE
//
//  Created by Srdjan Spasojevic on 11. 3. 2026..
//

private var homeViewText = "[HOME VIEW] "

import SwiftUI

struct HomeView: View {
    @ObservedObject var coordinator: AppCoordinator
    @StateObject private var viewModel: HomeViewModel

    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
        _viewModel = StateObject(wrappedValue: HomeViewModel(coordinator: coordinator))
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
                    balanceSection
                    transactionsSection
                }
                .padding(.horizontal, AppLayout.paddingContent)
                .padding(.vertical, AppLayout.paddingVertical)
            }
        }
        .navigationTitle(viewModel.greeting.isEmpty ? "Hi" : viewModel.greeting)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Sign Out") {
                    Task {
                        await viewModel.logout()
                    }
                    print(homeViewText, "User logged out")
                }
                .font(.callout.weight(.bold))
                .foregroundStyle(AppColors.loginPrimaryText)
            }
            ToolbarItem(placement: .bottomBar) {
                Button("Send") {
                    coordinator.navigate(to: .transfer)
                }
                .font(.callout.weight(.bold))
                .foregroundStyle(AppColors.loginPrimaryText)
            }
        }
        .task {
            viewModel.load()
        }
        .onChange(of: coordinator.navigationPath.count) { _, newCount in
            if newCount == 0 {
                viewModel.load()
            }
        }
    }

    private var balanceSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Current balance")
                .font(.subheadline.weight(.medium))
                .foregroundStyle(AppColors.loginSecondaryText)

            Text(viewModel.currentBalance)
                .font(.system(size: 34, weight: .bold))
                .foregroundStyle(AppColors.loginPrimaryText)
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

    private var transactionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Transactions")
                .font(.headline.weight(.bold))
                .foregroundStyle(AppColors.loginPrimaryText)

            if viewModel.isLoading && viewModel.transactions.isEmpty {
                ProgressView()
                    .tint(AppColors.loginPrimaryText)
            } else if viewModel.transactions.isEmpty {
                Text("No transactions yet")
                    .font(.subheadline)
                    .foregroundStyle(AppColors.loginSecondaryText)
            } else {
                VStack(spacing: 12) {
                    ForEach(viewModel.transactions) { row in
                        transactionRow(row)
                    }
                }
            }
        }
    }

    private func transactionRow(_ row: HomeTransactionRow) -> some View {
        HStack(spacing: 12) {
            let isIncoming = row.direction == .incoming
            let arrowName = isIncoming ? "arrow.down.left" : "arrow.up.right"
            let arrowColor: Color = isIncoming ? .green : .red

            ZStack {
                Circle()
                    .fill(arrowColor.opacity(0.15))
                Image(systemName: arrowName)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(arrowColor)
            }
            .frame(width: 30, height: 30)

            VStack(alignment: .leading, spacing: 4) {
                Text(row.counterpartyName)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(AppColors.loginPrimaryText)

                Text(row.dateFormatted)
                    .font(.caption)
                    .foregroundStyle(AppColors.loginSecondaryText)
            }

            Spacer()

            Text(row.amountFormatted)
                .font(.subheadline.weight(.semibold))
                .foregroundColor(row.direction == .incoming ? .green : .red)
        }
        .padding(AppLayout.paddingCard)
        .background(
            RoundedRectangle(cornerRadius: AppLayout.cornerRadiusRow, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: AppLayout.cornerRadiusRow, style: .continuous)
                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                )
        )
    }
}

