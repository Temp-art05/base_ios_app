import Foundation

/// Accessibility ID của app target. Quy ước `{screen}_{element}_{type}` (snake_case).
enum AccessibilityID {
    enum Root {
        static let container = "root_container"
    }

    enum Splash {
        static let screen = "splash_screen"
    }

    enum Policy {
        static let screen = "policy_screen"
        static let agreeButton = "policy_agree_button"
    }

    enum Onboarding {
        static let screen = "onboarding_screen"
        static let page = "onboarding_page"
        static let nextButton = "onboarding_next_button"
        static let skipButton = "onboarding_skip_button"
    }
}
