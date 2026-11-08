import SwiftUI

public struct LoadingStateView: View {
    public init() {}

    public var body: some View {
        ProgressView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .accessibilityIdentifier(DSAccessibilityID.State.loading)
    }
}

public struct ErrorStateView: View {
    private let message: String
    private let onRetry: () -> Void

    public init(message: String, onRetry: @escaping () -> Void) {
        self.message = message
        self.onRetry = onRetry
    }

    public var body: some View {
        VStack(spacing: AppSpacing.lg) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundStyle(AppColor.error)
            Text(message)
                .textStyle(.body)
                .foregroundStyle(AppColor.textSecondary)
                .multilineTextAlignment(.center)
            Button(Strings.Common.retry, action: onRetry)
                .textStyle(.headline)
                .accessibilityIdentifier(DSAccessibilityID.State.retryButton)
        }
        .padding(AppSpacing.xl)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityIdentifier(DSAccessibilityID.State.error)
    }
}

public struct EmptyStateView: View {
    private let systemImage: String
    private let message: String

    public init(systemImage: String = "tray", message: String) {
        self.systemImage = systemImage
        self.message = message
    }

    public var body: some View {
        VStack(spacing: AppSpacing.md) {
            Image(systemName: systemImage)
                .font(.largeTitle)
                .foregroundStyle(AppColor.textSecondary)
            Text(message)
                .textStyle(.body)
                .foregroundStyle(AppColor.textSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityIdentifier(DSAccessibilityID.State.empty)
    }
}
