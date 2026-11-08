import Foundation

/// Tên event + param. Catalog event cụ thể nằm ở `AnalyticsEvents.swift`.
public struct AnalyticsEvent: Sendable, Equatable {
    public let name: String
    public let params: [String: String]

    public init(_ name: String, params: [String: String] = [:]) {
        self.name = name
        self.params = params
    }
}

public extension AnalyticsEvent {
    static func screenView(_ screen: String) -> AnalyticsEvent {
        AnalyticsEvent("app_screen_view", params: ["screen": screen])
    }

    static func tap(_ element: String, screen: String) -> AnalyticsEvent {
        AnalyticsEvent("app_tap", params: ["element": element, "screen": screen])
    }
}
