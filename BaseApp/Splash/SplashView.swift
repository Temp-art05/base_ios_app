import SwiftUI
import DesignSystem

struct SplashView: View {
    var body: some View {
        ZStack {
            AppColor.background.ignoresSafeArea()
            VStack(spacing: AppSpacing.lg) {
                Image(systemName: "square.stack.3d.up.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(AppColor.primary)
                Text("Base App")
                    .textStyle(.largeTitle)
                    .foregroundStyle(AppColor.textPrimary)
            }
        }
        .accessibilityIdentifier(AccessibilityID.Splash.screen)
    }
}
