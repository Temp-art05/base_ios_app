import Foundation
import Domain

/// DTO/entity → domain. Mapper nằm ở Data; Domain không biết DTO.
enum PostMapper {
    static func map(_ dto: PostDTO, isBookmarked: Bool) -> Post {
        Post(
            id: dto.id,
            title: dto.title,
            body: dto.body,
            tags: dto.tags ?? [],
            likes: dto.reactions?.likes ?? 0,
            views: dto.views ?? 0,
            isBookmarked: isBookmarked
        )
    }

    static func map(_ list: PostListDTO, bookmarkedIDs: Set<Int>) -> Page<Post> {
        Page(
            items: list.posts.map { map($0, isBookmarked: bookmarkedIDs.contains($0.id)) },
            hasMore: list.skip + list.posts.count < list.total
        )
    }

    static func map(_ record: BookmarkRecord) -> Post {
        Post(
            id: record.postID, title: record.title, body: record.body,
            tags: record.tags, likes: record.likes, views: record.views, isBookmarked: true
        )
    }

    static func record(_ post: Post) -> BookmarkRecord {
        BookmarkRecord(
            postID: post.id, title: post.title, body: post.body,
            tags: post.tags, likes: post.likes, views: post.views
        )
    }
}
