import Foundation

/// Chuỗi UI dùng chung (Localizable.strings trong `Resources/<lang>.lproj`). Không viết chuỗi thẳng trong View.
/// Thêm ngôn ngữ: thêm `<lang>.lproj/Localizable.strings`. Chuỗi riêng của feature đặt ở package feature đó.
public enum Strings {
    public enum Common {
        public static var retry: String { tr("common_retry") }
        public static var `continue`: String { tr("common_continue") }
        public static var skip: String { tr("common_skip") }
        public static var getStarted: String { tr("common_get_started") }
    }

    public enum Policy {
        public static var title: String { tr("policy_title") }
        public static var message: String { tr("policy_message") }
        public static var terms: String { tr("policy_terms") }
        public static var privacy: String { tr("policy_privacy") }
        public static var agree: String { tr("policy_agree") }
    }

    public enum Onboarding {
        public static func title(_ page: Int) -> String { tr("onboarding_\(page)_title") }
        public static func message(_ page: Int) -> String { tr("onboarding_\(page)_message") }
    }

    private static func tr(_ key: String) -> String {
        NSLocalizedString(key, bundle: .module, comment: "")
    }
}
