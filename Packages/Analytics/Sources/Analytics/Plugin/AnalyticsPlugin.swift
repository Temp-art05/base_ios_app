import Foundation

/// Một đích nhận event (Firebase, console, MMP…). Thêm SDK mới = thêm plugin, không sửa call-site.
public protocol AnalyticsPlugin: Sendable {
    func log(_ event: AnalyticsEvent)
    func setUserProperty(_ value: String?, for name: String)
}
