import Foundation
import Core
import Domain

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published private(set) var bookmarks: [Post] = []
    @Published private(set) var errorMessage: String?

    @Injected(\.postUseCase) private var useCase

    func onAppear() {
        Task { await load() }
    }

    func toggleBookmark(_ post: Post) {
        Task {
            do {
                _ = try await useCase.toggleBookmark(post)
                await load()
            } catch {
                errorMessage = error.userMessage
            }
        }
    }

    private func load() async {
        do {
            bookmarks = try await useCase.bookmarks()
            errorMessage = nil
        } catch {
            errorMessage = error.userMessage
        }
    }
}
