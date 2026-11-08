import Foundation
import Core

/// Cổng HTTP duy nhất của app. Mọi request đi qua `NetworkLogger` (xem `docs/rules/network-logging.md`).
public protocol APIClient: Sendable {
    func send<T: Decodable & Sendable>(_ endpoint: Endpoint, as type: T.Type) async throws -> T
}

public final class URLSessionAPIClient: APIClient, @unchecked Sendable {
    private let baseURL: URL
    private let session: URLSession
    private let decoder: JSONDecoder
    private let interceptors: [RequestInterceptor]

    public init(
        baseURL: URL,
        session: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder(),
        interceptors: [RequestInterceptor] = []
    ) {
        self.baseURL = baseURL
        self.session = session
        self.decoder = decoder
        self.interceptors = interceptors
    }

    public func send<T: Decodable & Sendable>(_ endpoint: Endpoint, as type: T.Type) async throws -> T {
        var request = try makeRequest(endpoint)
        for interceptor in interceptors {
            request = try await interceptor.adapt(request)
        }
        NetworkLogger.logRequest(request)

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            NetworkLogger.logError(error, for: request)
            throw Self.map(error)
        }

        guard let http = response as? HTTPURLResponse else { throw APIError.unknown("Non-HTTP response") }
        NetworkLogger.logResponse(http, data: data, for: request)

        guard (200..<300).contains(http.statusCode) else {
            throw APIError.http(status: http.statusCode, message: Self.errorMessage(from: data))
        }
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.decoding(String(describing: error))
        }
    }

    // MARK: - Private

    private func makeRequest(_ endpoint: Endpoint) throws -> URLRequest {
        guard var components = URLComponents(
            url: baseURL.appendingPathComponent(endpoint.path),
            resolvingAgainstBaseURL: false
        ) else { throw APIError.invalidURL }
        if !endpoint.query.isEmpty {
            components.queryItems = endpoint.query
                .sorted { $0.key < $1.key }
                .map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        guard let url = components.url else { throw APIError.invalidURL }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        if endpoint.body != nil {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        endpoint.headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        return request
    }

    private static func map(_ error: Error) -> APIError {
        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet, .networkConnectionLost, .dataNotAllowed: return .noConnection
            case .timedOut: return .timeout
            case .cancelled: return .cancelled
            default: return .unknown(urlError.localizedDescription)
            }
        }
        if error is CancellationError { return .cancelled }
        return .unknown(error.localizedDescription)
    }

    /// Body lỗi mặc định `{ "message": "..." }`. Đổi cho khớp BE của project (xem TODO.md).
    private static func errorMessage(from data: Data) -> String? {
        struct Body: Decodable { let message: String? }
        return try? JSONDecoder().decode(Body.self, from: data).message
    }
}
