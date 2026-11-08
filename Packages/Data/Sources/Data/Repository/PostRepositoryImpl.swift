import Foundation
import Domain

final class PostRepositoryImpl: PostRepository, @unchecked Sendable {
    private let remote: PostRemoteDataSource
    private let local: BookmarkLocalDataSource

    init(remote: PostRemoteDataSource, local: BookmarkLocalDataSource) {
        self.remote = remote
        self.local = local
    }

    func fetchPosts(skip: Int, limit: Int) async throws -> Page<Post> {
        try await mapping {
            let dto = try await remote.posts(skip: skip, limit: limit)
            return PostMapper.map(dto, bookmarkedIDs: try await local.ids())
        }
    }

    func search(query: String, skip: Int, limit: Int) async throws -> Page<Post> {
        try await mapping {
            let dto = try await remote.search(query: query, skip: skip, limit: limit)
            return PostMapper.map(dto, bookmarkedIDs: try await local.ids())
        }
    }

    func fetchPost(id: Int) async throws -> Post {
        try await mapping {
            let dto = try await remote.post(id: id)
            return PostMapper.map(dto, isBookmarked: try await local.ids().contains(id))
        }
    }

    func bookmarkedIDs() async throws -> Set<Int> {
        try await mapping { try await local.ids() }
    }

    func setBookmarked(_ post: Post, isBookmarked: Bool) async throws {
        do {
            if isBookmarked {
                try await local.upsert(PostMapper.record(post))
            } else {
                try await local.remove(postID: post.id)
            }
        } catch {
            throw DomainError.storage
        }
    }

    func bookmarkedPosts() async throws -> [Post] {
        do {
            return try await local.all().map(PostMapper.map)
        } catch {
            throw DomainError.storage
        }
    }
}
