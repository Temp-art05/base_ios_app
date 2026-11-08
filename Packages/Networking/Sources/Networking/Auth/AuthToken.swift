import Foundation

/// Cặp token đăng nhập. Lưu qua `TokenStore` (Keychain), không UserDefaults.
public struct AuthToken: Codable, Equatable, Sendable {
    public let accessToken: String
    public let refreshToken: String?

    public init(accessToken: String, refreshToken: String? = nil) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }

    /// Hết hạn (theo claim `exp` của JWT) trong `leeway` giây tới. Token không phải JWT → coi như chưa hết hạn.
    public func isExpired(leeway: TimeInterval = 30, now: Date = .now) -> Bool {
        guard let exp = JWTDecoder.expiration(of: accessToken) else { return false }
        return exp.timeIntervalSince(now) <= leeway
    }
}
