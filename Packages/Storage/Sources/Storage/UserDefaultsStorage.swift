import Foundation

/// Wrapper mỏng cho preference nhỏ. Dữ liệu nhạy cảm → Keychain, dữ liệu quan hệ → SwiftData.
public struct UserDefaultsStorage: @unchecked Sendable {
    private let defaults: UserDefaults

    public init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    public func string(_ key: String) -> String? { defaults.string(forKey: key) }
    public func bool(_ key: String) -> Bool { defaults.bool(forKey: key) }
    public func set(_ value: Any?, for key: String) { defaults.set(value, forKey: key) }
    public func remove(_ key: String) { defaults.removeObject(forKey: key) }
}
