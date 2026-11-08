import Foundation

/// Accessibility ID của FeatureMain. Quy ước: `{screen}_{element}_{type}` (snake_case).
/// Dynamic list: append index — `"\(AccessibilityID.Home.postRow)_\(index)"`.
enum AccessibilityID {
    enum Main {
        static let tabBar = "main_tab_bar"
        static let homeTab = "main_home_tab"
        static let featureTab = "main_feature_tab"
        static let profileTab = "main_profile_tab"
    }

    enum Home {
        static let screen = "home_screen"
        static let list = "home_post_list"
        static let postRow = "home_post_row"
        static let bookmarkButton = "home_bookmark_button"
        static let searchField = "home_search_field"
        static let loadMoreIndicator = "home_load_more_indicator"
    }

    enum Feature {
        static let screen = "feature_screen"
        static let sampleButton = "feature_sample_button"
    }

    enum Profile {
        static let screen = "profile_screen"
        static let settingsButton = "profile_settings_button"
        static let bookmarkRow = "profile_bookmark_row"
    }

    enum Settings {
        static let screen = "settings_screen"
        static let appearancePicker = "settings_appearance_picker"
        static let versionLabel = "settings_version_label"
    }

    enum PostDetail {
        static let screen = "post_detail_screen"
        static let bookmarkButton = "post_detail_bookmark_button"
    }
}
