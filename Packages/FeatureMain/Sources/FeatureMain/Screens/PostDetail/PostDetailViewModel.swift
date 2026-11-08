import Foundation
import Core
import Domain

@MainActor
final class PostDetailViewModel: ObservableObject {
    enum LoadState: Equatable {
        case loading
        case loaded(Post)
        case failed(String)
    }

    @Published private(set) var loadState: LoadState = .loading

    @Injected(\.postUseCase) private var useCase
    private let postID: Int

    init(postID: Int) {
        self.postID = postID
    }

    func onAppear() { Task { await load() } }
    func retry() { Task { await load() } }

    func toggleBookmark() {
        guard case .loaded(let post) = loadState else { return }
        Task {
            if let updated = try? await useCase.toggleBookmark(post) {
                loadState = .loaded(updated)
            }
        }
    }

    private func load() async {
        loadState = .loading
        do {
            loadState = .loaded(try await useCase.post(id: postID))
        } catch {
            loadState = .failed(error.userMessage)
        }
    }
}
