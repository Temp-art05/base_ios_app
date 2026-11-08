import Foundation

/// Hook sửa request trước khi gửi (gắn token, chữ ký, header chung…).
/// Mặc định không có interceptor nào; thêm ở `Container.apiClient` của `Data`.
public protocol RequestInterceptor: Sendable {
    func adapt(_ request: URLRequest) async throws -> URLRequest
}

/// Cung cấp access token cho `BearerAuthInterceptor`. Base chưa có auth — cài đặt khi cần.
public protocol TokenProvider: Sendable {
    func accessToken() async -> String?
}

public struct BearerAuthInterceptor: RequestInterceptor {
    private let tokenProvider: TokenProvider

    public init(tokenProvider: TokenProvider) {
        self.tokenProvider = tokenProvider
    }

    public func adapt(_ request: URLRequest) async throws -> URLRequest {
        guard let token = await tokenProvider.accessToken() else { return request }
        var request = request
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
