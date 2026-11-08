import Foundation
import Domain
import Networking

/// Chuyển lỗi tầng thấp → `DomainError`. Repository bọc mọi lời gọi DataSource qua `mapping { }`.
enum DomainErrorMapper {
    static func map(_ error: Error) -> Error {
        if error is DomainError { return error }
        if let api = error as? APIError {
            switch api {
            case .noConnection: return DomainError.noConnection
            case .timeout: return DomainError.timeout
            case .cancelled: return CancellationError()
            case .invalidURL: return DomainError.unknown
            case .decoding: return DomainError.invalidData
            case .http(let status, let message):
                // Mã lỗi nghiệp vụ riêng của project: thêm nhánh ở đây (vd 401 → .unauthorized).
                if status == 404 { return DomainError.notFound }
                return DomainError.server(message: message)
            case .unknown: return DomainError.unknown
            }
        }
        if error is CancellationError { return error }
        return DomainError.unknown
    }
}

func mapping<T>(_ body: () async throws -> T) async throws -> T {
    do { return try await body() } catch { throw DomainErrorMapper.map(error) }
}
