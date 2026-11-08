import SwiftUI
import Domain
import DesignSystem

struct PostRow: View {
    let post: Post
    let onTap: () -> Void
    let onToggleBookmark: () -> Void
    let bookmarkAccessibilityID: String

    var body: some View {
        HStack(alignment: .top, spacing: AppSpacing.md) {
            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                Text(post.title)
                    .textStyle(.headline)
                    .foregroundStyle(AppColor.textPrimary)
                    .lineLimit(2)
                Text(post.body)
                    .textStyle(.callout)
                    .foregroundStyle(AppColor.textSecondary)
                    .lineLimit(3)
                Label("\(post.likes)", systemImage: "hand.thumbsup")
                    .textStyle(.caption)
                    .foregroundStyle(AppColor.textSecondary)
            }
            Spacer(minLength: AppSpacing.sm)
            Button(action: onToggleBookmark) {
                Image(systemName: post.isBookmarked ? "bookmark.fill" : "bookmark")
                    .foregroundStyle(AppColor.primary)
                    .frame(width: AppSize.iconLg, height: AppSize.iconLg)
            }
            .buttonStyle(.plain)
            .accessibilityIdentifier(bookmarkAccessibilityID)
        }
        .padding(AppSpacing.lg)
        .background(AppColor.surface)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg, style: .continuous))
        .contentShape(Rectangle())
        .onTapGesture(perform: onTap)
    }
}
