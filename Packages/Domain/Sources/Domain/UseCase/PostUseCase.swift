import Foundation

/// Use case gộp theo năng lực nghiệp vụ "Post" (không mỗi hàm repository một class).
/// Mọi rule (kích thước trang, trim query, khử trùng lặp…) nằm ở đây, không nằm ở ViewModel.
public protocol PostUseCase: Sendable {
    /// Trang đầu tiên (`reset`) hoặc trang kế tiếp tính từ số item đã có.
    func loadPage(loaded: Int, query: String) async throws -> Page<Post>
    func post(id: Int) async throws -> Post
    func toggleBookmark(_ post: Post) async throws -> Post
    func bookmarks() async throws -> [Post]
}

public struct DefaultPostUseCase: PostUseCase {
    private let repository: PostRepository
    private let config: AppConfig

    public init(repository: PostRepository, config: AppConfig) {
        self.repository = repository
        self.config = config
    }

    public func loadPage(loaded: Int, query: String) async throws -> Page<Post> {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            return try await repository.fetchPosts(skip: loaded, limit: config.pageSize)
        }
        return try await repository.search(query: trimmed, skip: loaded, limit: config.pageSize)
    }

    public func post(id: Int) async throws -> Post {
        try await repository.fetchPost(id: id)
    }

    public func toggleBookmark(_ post: Post) async throws -> Post {
        var updated = post
        updated.isBookmarked.toggle()
        try await repository.setBookmarked(post, isBookmarked: updated.isBookmarked)
        return updated
    }

    public func bookmarks() async throws -> [Post] {
        try await repository.bookmarkedPosts()
    }
}
