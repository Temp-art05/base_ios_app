import Foundation
import SwiftData

/// Bookmark của một Post (SwiftData). Lưu snapshot đủ để hiện lại ở tab Profile không cần mạng.
@Model
public final class BookmarkEntity {
    @Attribute(.unique) public var postID: Int
    public var title: String
    public var body: String
    public var tags: [String]
    public var likes: Int
    public var views: Int
    public var createdAt: Date

    public init(
        postID: Int,
        title: String,
        body: String,
        tags: [String],
        likes: Int,
        views: Int,
        createdAt: Date = .now
    ) {
        self.postID = postID
        self.title = title
        self.body = body
        self.tags = tags
        self.likes = likes
        self.views = views
        self.createdAt = createdAt
    }
}
