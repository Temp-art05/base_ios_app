import SwiftUI
import Core
import DesignSystem

/// Màn đồng ý điều khoản lần đầu. Chặn mọi tương tác tới khi người dùng đồng ý.
struct PolicyConsentView: View {
    let onAgree: () -> Void

    var body: some View {
        ZStack {
            AppColor.background.ignoresSafeArea()
            VStack(spacing: AppSpacing.xl) {
                Spacer()
                Text(Strings.Policy.title)
                    .textStyle(.largeTitle)
                    .foregroundStyle(AppColor.textPrimary)
                Text(Strings.Policy.message)
                    .textStyle(.body)
                    .foregroundStyle(AppColor.textSecondary)
                    .multilineTextAlignment(.center)
                HStack(spacing: AppSpacing.lg) {
                    Link(Strings.Policy.terms, destination: Constants.Links.termsOfUse)
                    Link(Strings.Policy.privacy, destination: Constants.Links.privacyPolicy)
                }
                .textStyle(.callout)
                Spacer()
                PrimaryButton(Strings.Policy.agree, accessibilityID: AccessibilityID.Policy.agreeButton, action: onAgree)
            }
            .padding(AppSpacing.xl)
        }
        .accessibilityIdentifier(AccessibilityID.Policy.screen)
    }
}
