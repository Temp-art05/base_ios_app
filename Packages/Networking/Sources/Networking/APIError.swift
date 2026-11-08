import Foundation

/// Lỗi tầng transport. Chỉ Data/Networking được thấy; Domain/Presentation dùng `DomainError`.
public enum APIError: Error, Equatable, Sendable {
    case invalidURL
    case noConnection
    case timeout
    case cancelled
    /// Server trả status ngoài 2xx. `message` lấy từ body lỗi (nếu parse được).
    case http(status: Int, message: String?)
    case decoding(String)
    case unknown(String)
}
