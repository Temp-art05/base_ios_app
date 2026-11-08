import Foundation

public enum HTTPMethod: String, Sendable {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

/// Mô tả một request. Mỗi API khai một `Endpoint` (xem `docs/guides/new-api.md`).
public struct Endpoint: Sendable {
    public var path: String
    public var method: HTTPMethod
    public var query: [String: String]
    public var headers: [String: String]
    public var body: Data?

    public init(
        path: String,
        method: HTTPMethod = .get,
        query: [String: String] = [:],
        headers: [String: String] = [:],
        body: Data? = nil
    ) {
        self.path = path
        self.method = method
        self.query = query
        self.headers = headers
        self.body = body
    }
}
