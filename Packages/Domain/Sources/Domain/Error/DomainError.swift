import Foundation

/// Lỗi mà Presentation được phép thấy. Chuỗi lỗi: `APIError` (Data) → `DomainError` (Data mapper) → message.
/// Presentation không bao giờ import `Networking`/`Data`.
public enum DomainError: Error, Equatable, Sendable {
    case noConnection
    case timeout
    case notFound
    case server(message: String?)
    case invalidData
    case storage
    case unknown

    /// Mã lỗi nghiệp vụ riêng của project: thêm case ở đây rồi map trong `Data/Error/DomainErrorMapper`.
}

extension DomainError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noConnection: String(localized: "error_no_connection", defaultValue: "No internet connection.")
        case .timeout: String(localized: "error_timeout", defaultValue: "The request timed out. Please try again.")
        case .notFound: String(localized: "error_not_found", defaultValue: "We couldn't find what you were looking for.")
        case .server(let message): message ?? String(localized: "error_server", defaultValue: "Server error. Please try again later.")
        case .invalidData: String(localized: "error_invalid_data", defaultValue: "Received unexpected data.")
        case .storage: String(localized: "error_storage", defaultValue: "Couldn't access local storage.")
        case .unknown: String(localized: "error_unknown", defaultValue: "Something went wrong.")
        }
    }
}

public extension Error {
    /// Message hiển thị cho người dùng. Lỗi không phải `DomainError` rơi về `.unknown`.
    var userMessage: String {
        (self as? DomainError ?? .unknown).errorDescription ?? ""
    }
}
