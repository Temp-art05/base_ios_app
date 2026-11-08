import Foundation

/// Cấu hình build-time mà Domain/Presentation được biết (không chứa secret).
public struct AppConfig: Sendable {
    public let pageSize: Int

    public init(pageSize: Int = 20) {
        self.pageSize = pageSize
    }
}
