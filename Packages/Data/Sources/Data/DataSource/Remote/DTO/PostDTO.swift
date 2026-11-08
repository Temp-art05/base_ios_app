import Foundation

struct PostDTO: Decodable, Sendable {
    let id: Int
    let title: String
    let body: String
    let tags: [String]?
    let views: Int?
    let reactions: Reactions?

    struct Reactions: Decodable, Sendable {
        let likes: Int?
        let dislikes: Int?
    }
}

/// Envelope phân trang của dummyjson: `{ posts, total, skip, limit }`.
struct PostListDTO: Decodable, Sendable {
    let posts: [PostDTO]
    let total: Int
    let skip: Int
    let limit: Int
}
