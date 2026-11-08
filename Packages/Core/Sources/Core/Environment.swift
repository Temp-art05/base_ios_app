import Foundation

public enum AppEnvironment {
    case debug
    case release

    public static var current: AppEnvironment {
        #if DEBUG
        return .debug
        #else
        return .release
        #endif
    }

    public var isDebug: Bool { self == .debug }
}

/// Giá trị cấu hình build-time: `Configurations/*.xcconfig` → `Info.plist` → đọc ở đây.
/// Thêm field mới: khai trong xcconfig, map vào Info.plist (`INFOPLIST_KEY_*` hoặc `Info.plist`), thêm getter.
public enum Environment {
    /// Môi trường backend: `dev` | `prod` (từ xcconfig `APP_ENV`). Độc lập với Debug/Release.
    public static var name: String { info(for: "APP_ENV", fallback: "prod") }
    public static var isDev: Bool { name == "dev" }

    /// Base URL của API. Mặc định trỏ dummyjson.com để luồng mẫu (Posts) chạy được ngay.
    public static var baseURL: String {
        info(for: "BASE_URL", fallback: "https://dummyjson.com")
    }

    /// Base host cho asset/ảnh (CDN). Mặc định trùng `baseURL`.
    public static var assetBaseURL: String { info(for: "ASSET_BASE_URL", fallback: baseURL) }

    // MARK: Keys (xcconfig → Info.plist)
    public static var apiKey: String { info(for: "ApiKey") }
    /// Bundle id gửi lên BE (header kiểu `x-api-bundleid`) — tách theo môi trường, KHÔNG nhất thiết bằng bundle id app.
    public static var apiBundleID: String { info(for: "ApiBundleId", fallback: Bundle.main.bundleIdentifier ?? "") }

    /// Có `GoogleService-Info.plist` trong bundle hay không. Thiếu ⇒ mọi thứ Firebase rơi về no-op.
    public static var hasFirebaseConfig: Bool {
        Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") != nil
    }

    private static func info(for key: String, fallback: String = "") -> String {
        let value = Bundle.main.object(forInfoDictionaryKey: key) as? String ?? ""
        return value.isEmpty ? fallback : value
    }
}
