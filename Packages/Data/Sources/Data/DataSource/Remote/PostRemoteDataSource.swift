import Foundation
import Networking

protocol PostRemoteDataSource: Sendable {
    func posts(skip: Int, limit: Int) async throws -> PostListDTO
    func search(query: String, skip: Int, limit: Int) async throws -> PostListDTO
    func post(id: Int) async throws -> PostDTO
}

struct PostRemoteDataSourceImpl: PostRemoteDataSource {
    let client: APIClient

    func posts(skip: Int, limit: Int) async throws -> PostListDTO {
        try await client.send(
            Endpoint(path: "posts", query: ["skip": "\(skip)", "limit": "\(limit)"]),
            as: PostListDTO.self
        )
    }

    func search(query: String, skip: Int, limit: Int) async throws -> PostListDTO {
        try await client.send(
            Endpoint(path: "posts/search", query: ["q": query, "skip": "\(skip)", "limit": "\(limit)"]),
            as: PostListDTO.self
        )
    }

    func post(id: Int) async throws -> PostDTO {
        try await client.send(Endpoint(path: "posts/\(id)"), as: PostDTO.self)
    }
}
