import SwiftUI
import DesignSystem

/// Tab mẫu trống — thay bằng tính năng chính của app.
struct FeatureView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: AppSpacing.lg) {
                Image(systemName: "sparkles")
                    .font(.largeTitle)
                    .foregroundStyle(AppColor.primary)
                Text("Your main feature goes here")
                    .textStyle(.headline)
                    .foregroundStyle(AppColor.textPrimary)
                PrimaryButton("Sample button", accessibilityID: AccessibilityID.Feature.sampleButton) {}
                    .padding(.horizontal, AppSpacing.xl)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(AppColor.background)
            .navigationTitle("Feature")
        }
        .accessibilityIdentifier(AccessibilityID.Feature.screen)
    }
}
