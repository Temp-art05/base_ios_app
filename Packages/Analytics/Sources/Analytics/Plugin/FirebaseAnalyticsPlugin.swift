import Foundation
import FirebaseAnalytics

public struct FirebaseAnalyticsPlugin: AnalyticsPlugin {
    public init() {}

    public func log(_ event: AnalyticsEvent) {
        FirebaseAnalytics.Analytics.logEvent(event.name, parameters: event.params)
    }

    public func setUserProperty(_ value: String?, for name: String) {
        FirebaseAnalytics.Analytics.setUserProperty(value, forName: name)
    }
}
