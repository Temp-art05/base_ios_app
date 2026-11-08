import SwiftUI
import DesignSystem

/// Nội dung tạm cho tab chưa làm. Dùng khi thêm tab mới để app luôn chạy được.
struct PlaceholderTab: View {
    let title: String
    let systemImage: String

    var body: some View {
        VStack(spacing: AppSpacing.lg) {
            Image(systemName: systemImage)
                .font(.largeTitle)
                .foregroundStyle(AppColor.primary)
            Text(title)
                .textStyle(.headline)
                .foregroundStyle(AppColor.textPrimary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColor.background)
    }
}
