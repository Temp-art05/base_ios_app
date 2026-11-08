import Foundation
import Core
import FirebaseRemoteConfig

/// Khai key ở đây (kèm default) rồi đọc qua `RemoteConfigSource`. Thiếu Firebase ⇒ luôn trả default.
public enum RemoteConfigKey: String, CaseIterable, Sendable {
    case featureEnabled = "feature_enabled"

    public var defaultValue: String {
        switch self {
        case .featureEnabled: "true"
        }
    }
}

public protocol RemoteConfigSource: Sendable {
    /// Fetch + activate. Lỗi mạng không ném — giữ giá trị đã cache/default.
    func refresh() async
    func string(_ key: RemoteConfigKey) -> String
}

public extension RemoteConfigSource {
    func bool(_ key: RemoteConfigKey) -> Bool { string(key).lowercased() == "true" }
    func int(_ key: RemoteConfigKey) -> Int { Int(string(key)) ?? 0 }
}

public struct DefaultRemoteConfigSource: RemoteConfigSource {
    public init() {}
    public func refresh() async {}
    public func string(_ key: RemoteConfigKey) -> String { key.defaultValue }
}

public final class FirebaseRemoteConfigSource: RemoteConfigSource, @unchecked Sendable {
    private let remoteConfig = RemoteConfig.remoteConfig()

    public init() {
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = AppEnvironment.current.isDebug ? 0 : 3600
        remoteConfig.configSettings = settings
        remoteConfig.setDefaults(Dictionary(uniqueKeysWithValues: RemoteConfigKey.allCases.map { ($0.rawValue, $0.defaultValue as NSObject) }))
    }

    public func refresh() async {
        do {
            _ = try await remoteConfig.fetchAndActivate()
        } catch {
            Logger.error("RemoteConfig fetch failed: \(error)", category: "RemoteConfig")
        }
    }

    public func string(_ key: RemoteConfigKey) -> String {
        remoteConfig.configValue(forKey: key.rawValue).stringValue
    }
}
