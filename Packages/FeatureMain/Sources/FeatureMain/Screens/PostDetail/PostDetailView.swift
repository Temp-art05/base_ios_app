import SwiftUI
import Domain
import DesignSystem

public struct PostDetailView: View {
    @StateObject private var viewModel: PostDetailViewModel

    public init(postID: Int) {
        _viewModel = StateObject(wrappedValue: PostDetailViewModel(postID: postID))
    }

    public var body: some View {
        Group {
            switch viewModel.loadState {
            case .loading:
                LoadingStateView()
            case .failed(let message):
                ErrorStateView(message: message) { viewModel.retry() }
            case .loaded(let post):
                ScrollView {
                    VStack(alignment: .leading, spacing: AppSpacing.lg) {
                        Text(post.title).textStyle(.title).foregroundStyle(AppColor.textPrimary)
                        Text(post.body).textStyle(.body).foregroundStyle(AppColor.textPrimary)
                        if !post.tags.isEmpty {
                            Text(post.tags.map { "#\($0)" }.joined(separator: " "))
                                .textStyle(.caption)
                                .foregroundStyle(AppColor.primary)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(AppSpacing.lg)
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button { viewModel.toggleBookmark() } label: {
                            Image(systemName: post.isBookmarked ? "bookmark.fill" : "bookmark")
                        }
                        .accessibilityIdentifier(AccessibilityID.PostDetail.bookmarkButton)
                    }
                }
            }
        }
        .background(AppColor.background)
        .navigationBarTitleDisplayMode(.inline)
        .accessibilityIdentifier(AccessibilityID.PostDetail.screen)
        .onAppear { viewModel.onAppear() }
    }
}
