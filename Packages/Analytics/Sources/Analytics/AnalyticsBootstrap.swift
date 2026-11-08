import Foundation
import Core
import FirebaseCore

/// Dựng analytics theo môi trường. Gọi MỘT lần ở `BaseApp.init`.
/// Có `GoogleService-Info.plist` ⇒ bật Firebase; thiếu ⇒ chỉ Console + no-op, app vẫn chạy bình thường.
public enum AnalyticsBootstrap {
    public static func configure(container: Container = .shared) {
        if Environment.hasFirebaseConfig {
            FirebaseApp.configure()
            container.analyticsService.register {
                DefaultAnalyticsService(plugins: [ConsoleAnalyticsPlugin(), FirebaseAnalyticsPlugin()])
            }
            container.crashReporter.register { FirebaseCrashReporter() }
            container.remoteConfigSource.register { FirebaseRemoteConfigSource() }
        } else {
            Logger.info("GoogleService-Info.plist not found — Firebase disabled (no-op).", category: "Analytics")
        }
    }
}

public extension Container {
    var analyticsService: Factory<AnalyticsService> {
        self { DefaultAnalyticsService(plugins: [ConsoleAnalyticsPlugin()]) }.singleton
    }

    var crashReporter: Factory<CrashReporter> {
        self { NoopCrashReporter() }.singleton
    }

    var remoteConfigSource: Factory<RemoteConfigSource> {
        self { DefaultRemoteConfigSource() }.singleton
    }
}
