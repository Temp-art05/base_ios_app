import Foundation
import Core

/// In event ra console (chỉ DEBUG). Luôn bật, nên app thiếu Firebase vẫn thấy event để kiểm tra.
public struct ConsoleAnalyticsPlugin: AnalyticsPlugin {
    public init() {}

    public func log(_ event: AnalyticsEvent) {
        Logger.analytics("\(event.name) \(event.params)")
    }

    public func setUserProperty(_ value: String?, for name: String) {
        Logger.analytics("user_property \(name)=\(value ?? "nil")")
    }
}
