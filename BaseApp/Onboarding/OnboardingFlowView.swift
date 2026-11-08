import SwiftUI
import DesignSystem

/// Onboarding mẫu 3 trang (nội dung ở Localizable.strings). Thay bằng flow thật của app.
struct OnboardingFlowView: View {
    let onFinish: () -> Void

    @StateObject private var viewModel = OnboardingViewModel()

    var body: some View {
        VStack(spacing: AppSpacing.xl) {
            TabView(selection: $viewModel.page) {
                ForEach(1...OnboardingViewModel.pageCount, id: \.self) { index in
                    OnboardingPageView(index: index).tag(index)
                }
            }
            .tabViewStyle(.page)

            PrimaryButton(
                viewModel.isLastPage ? Strings.Common.getStarted : Strings.Common.continue,
                accessibilityID: AccessibilityID.Onboarding.nextButton
            ) {
                if viewModel.advance() { onFinish() }
            }
            .padding(.horizontal, AppSpacing.xl)

            Button(Strings.Common.skip, action: onFinish)
                .textStyle(.callout)
                .foregroundStyle(AppColor.textSecondary)
                .opacity(viewModel.isLastPage ? 0 : 1)
                .accessibilityIdentifier(AccessibilityID.Onboarding.skipButton)
        }
        .padding(.vertical, AppSpacing.xl)
        .background(AppColor.background.ignoresSafeArea())
        .onAppear { viewModel.onAppear() }
        .accessibilityIdentifier(AccessibilityID.Onboarding.screen)
    }
}

private struct OnboardingPageView: View {
    let index: Int

    var body: some View {
        VStack(spacing: AppSpacing.lg) {
            Image(systemName: "sparkles")
                .font(.largeTitle)
                .foregroundStyle(AppColor.primary)
            Text(Strings.Onboarding.title(index))
                .textStyle(.title)
                .foregroundStyle(AppColor.textPrimary)
            Text(Strings.Onboarding.message(index))
                .textStyle(.body)
                .foregroundStyle(AppColor.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(AppSpacing.xl)
        .accessibilityIdentifier("\(AccessibilityID.Onboarding.page)_\(index)")
    }
}
