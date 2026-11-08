import Foundation

public struct Post: Identifiable, Equatable, Hashable, Sendable {
    public let id: Int
    public let title: String
    public let body: String
    public let tags: [String]
    public let likes: Int
    public let views: Int
    public var isBookmarked: Bool

    public init(
        id: Int,
        title: String,
        body: String,
        tags: [String] = [],
        likes: Int = 0,
        views: Int = 0,
        isBookmarked: Bool = false
    ) {
        self.id = id
        self.title = title
        self.body = body
        self.tags = tags
        self.likes = likes
        self.views = views
        self.isBookmarked = isBookmarked
    }
}
