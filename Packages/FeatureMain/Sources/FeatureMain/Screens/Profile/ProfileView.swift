import SwiftUI
import Domain
import DesignSystem

struct ProfileView: View {
    let onOpenSettings: () -> Void
    let onOpenPost: (Int) -> Void

    @StateObject private var viewModel = ProfileViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if let message = viewModel.errorMessage {
                    ErrorStateView(message: message) { viewModel.onAppear() }
                } else if viewModel.bookmarks.isEmpty {
                    EmptyStateView(systemImage: "bookmark", message: "No bookmarks yet")
                } else {
                    List(Array(viewModel.bookmarks.enumerated()), id: \.element.id) { index, post in
                        Button { onOpenPost(post.id) } label: {
                            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                                Text(post.title).textStyle(.headline).foregroundStyle(AppColor.textPrimary)
                                Text(post.body).textStyle(.callout).foregroundStyle(AppColor.textSecondary).lineLimit(2)
                            }
                        }
                        .accessibilityIdentifier("\(AccessibilityID.Profile.bookmarkRow)_\(index)")
                    }
                    .listStyle(.plain)
                }
            }
            .background(AppColor.background)
            .navigationTitle("Profile")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: onOpenSettings) { Image(systemName: "gearshape") }
                        .accessibilityIdentifier(AccessibilityID.Profile.settingsButton)
                }
            }
        }
        .accessibilityIdentifier(AccessibilityID.Profile.screen)
        .onAppear { viewModel.onAppear() }
    }
}
