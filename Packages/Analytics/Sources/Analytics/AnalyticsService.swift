import Foundation

/// Cổng analytics duy nhất cho ViewModel/UseCase. Fan-out sang các plugin.
public protocol AnalyticsService: Sendable {
    func log(_ event: AnalyticsEvent)
    func setUserProperty(_ value: String?, for name: String)
}

public struct DefaultAnalyticsService: AnalyticsService {
    private let plugins: [AnalyticsPlugin]

    public init(plugins: [AnalyticsPlugin]) {
        self.plugins = plugins
    }

    public func log(_ event: AnalyticsEvent) {
        plugins.forEach { $0.log(event) }
    }

    public func setUserProperty(_ value: String?, for name: String) {
        plugins.forEach { $0.setUserProperty(value, for: name) }
    }
}

/// Dùng cho test/preview.
public struct NoopAnalyticsService: AnalyticsService {
    public init() {}
    public func log(_ event: AnalyticsEvent) {}
    public func setUserProperty(_ value: String?, for name: String) {}
}
