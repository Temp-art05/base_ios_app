import Foundation

/// Catalog event của app — MỌI event khai ở đây (một chỗ duy nhất), call-site chỉ gọi hàm.
/// Quy ước: `snake_case`, ≤ 40 ký tự, tiền tố app, không trùng tên Firebase reserved
/// (`first_open`, `screen_view`, `session_start`, `app_open`…). Thêm event: khai ở đây + ghi vào `docs/rules/analytics.md`.
public extension AnalyticsEvent {
    // MARK: Lifecycle
    static var appForeground: AnalyticsEvent { AnalyticsEvent("app_foreground") }

    // MARK: Startup flow
    static var policyAccepted: AnalyticsEvent { AnalyticsEvent("policy_accepted") }
    static func onboardingPage(_ index: Int) -> AnalyticsEvent {
        AnalyticsEvent("onboarding_page_view", params: ["index": "\(index)"])
    }
    static var onboardingCompleted: AnalyticsEvent { AnalyticsEvent("onboarding_completed") }
}
