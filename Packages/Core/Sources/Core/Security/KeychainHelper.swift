import Foundation
import Security

/// Wrapper Keychain tối giản (generic password). Dữ liệu nhạy cảm (token, device id) lưu ở đây, không UserDefaults.
public struct KeychainHelper: @unchecked Sendable {
    private let service: String

    public init(service: String = Bundle.main.bundleIdentifier ?? "com.base.app") {
        self.service = service
    }

    public func read(_ key: String) -> Data? {
        var query = baseQuery(key)
        query[kSecReturnData as String] = true
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        var result: AnyObject?
        guard SecItemCopyMatching(query as CFDictionary, &result) == errSecSuccess else { return nil }
        return result as? Data
    }

    @discardableResult
    public func write(_ data: Data, for key: String) -> Bool {
        SecItemDelete(baseQuery(key) as CFDictionary)
        var query = baseQuery(key)
        query[kSecValueData as String] = data
        query[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlock
        return SecItemAdd(query as CFDictionary, nil) == errSecSuccess
    }

    @discardableResult
    public func delete(_ key: String) -> Bool {
        let status = SecItemDelete(baseQuery(key) as CFDictionary)
        return status == errSecSuccess || status == errSecItemNotFound
    }

    public func readString(_ key: String) -> String? {
        read(key).flatMap { String(data: $0, encoding: .utf8) }
    }

    @discardableResult
    public func writeString(_ value: String, for key: String) -> Bool {
        write(Data(value.utf8), for: key)
    }

    private func baseQuery(_ key: String) -> [String: Any] {
        [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
        ]
    }
}
