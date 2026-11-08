import Foundation
import Core

/// Nơi lưu token. `KeychainTokenStore` là impl mặc định; test dùng bản in-memory.
public protocol TokenStore: TokenProvider {
    func load() -> AuthToken?
    func save(_ token: AuthToken)
    func clear()
}

public final class KeychainTokenStore: TokenStore, @unchecked Sendable {
    private let keychain: KeychainHelper
    private let key = "auth_token"

    public init(keychain: KeychainHelper = KeychainHelper()) {
        self.keychain = keychain
    }

    public func load() -> AuthToken? {
        keychain.read(key).flatMap { try? JSONDecoder().decode(AuthToken.self, from: $0) }
    }

    public func save(_ token: AuthToken) {
        guard let data = try? JSONEncoder().encode(token) else { return }
        keychain.write(data, for: key)
    }

    public func clear() { keychain.delete(key) }

    public func accessToken() async -> String? { load()?.accessToken }
}
