import Foundation

/// Nguồn dữ liệu Post. Impl ở package `Data`. Ném `DomainError`.
public protocol PostRepository: Sendable {
    /// Một trang post, đã gắn cờ `isBookmarked`.
    func fetchPosts(skip: Int, limit: Int) async throws -> Page<Post>
    func fetchPost(id: Int) async throws -> Post
    func search(query: String, skip: Int, limit: Int) async throws -> Page<Post>

    func bookmarkedIDs() async throws -> Set<Int>
    func setBookmarked(_ post: Post, isBookmarked: Bool) async throws
    func bookmarkedPosts() async throws -> [Post]
}
