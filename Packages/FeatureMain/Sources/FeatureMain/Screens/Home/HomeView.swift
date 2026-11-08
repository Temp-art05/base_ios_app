import SwiftUI
import Domain
import DesignSystem

struct HomeView: View {
    let onOpenPost: (Int) -> Void

    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        NavigationStack {
            content
                .background(AppColor.background)
                .navigationTitle("Home")
                .searchable(text: $viewModel.query, prompt: "Search posts")
                .accessibilityIdentifier(AccessibilityID.Home.searchField)
        }
        .overlay(alignment: .bottom) { toastView }
        .accessibilityIdentifier(AccessibilityID.Home.screen)
        .onAppear { viewModel.onAppear() }
        .onChange(of: viewModel.toast) { _, message in
            guard message != nil else { return }
            Task {
                try? await Task.sleep(for: .seconds(2))
                viewModel.dismissToast()
            }
        }
        .animation(AppAnimation.standard, value: viewModel.toast)
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.loadState {
        case .idle, .loading:
            LoadingStateView()
        case .failed(let message):
            ErrorStateView(message: message) { viewModel.retry() }
        case .loaded where viewModel.posts.isEmpty:
            EmptyStateView(message: "No posts found")
        case .loaded:
            list
        }
    }

    private var list: some View {
        ScrollView {
            LazyVStack(spacing: AppSpacing.md) {
                ForEach(Array(viewModel.posts.enumerated()), id: \.element.id) { index, post in
                    PostRow(
                        post: post,
                        onTap: { onOpenPost(post.id) },
                        onToggleBookmark: { viewModel.toggleBookmark(post) },
                        bookmarkAccessibilityID: "\(AccessibilityID.Home.bookmarkButton)_\(index)"
                    )
                    .accessibilityIdentifier("\(AccessibilityID.Home.postRow)_\(index)")
                    .onAppear { viewModel.loadMoreIfNeeded(currentIndex: index) }
                }
                if viewModel.isLoadingMore {
                    ProgressView().accessibilityIdentifier(AccessibilityID.Home.loadMoreIndicator)
                }
            }
            .padding(AppSpacing.lg)
        }
        .refreshable { viewModel.refresh() }
        .accessibilityIdentifier(AccessibilityID.Home.list)
    }

    @ViewBuilder
    private var toastView: some View {
        if let toast = viewModel.toast {
            Text(toast)
                .textStyle(.callout)
                .foregroundStyle(AppColor.textOnPrimary)
                .padding(AppSpacing.md)
                .background(AppColor.textPrimary.opacity(AppOpacity.pressed))
                .clipShape(Capsule())
                .padding(.bottom, AppSpacing.xxxl)
                .transition(.opacity)
        }
    }
}
