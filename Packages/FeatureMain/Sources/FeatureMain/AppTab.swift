import Foundation

public enum AppTab: Int, CaseIterable, Hashable {
    case home, feature, profile

    var title: String {
        switch self {
        case .home: "Home"
        case .feature: "Feature"
        case .profile: "Profile"
        }
    }

    var systemImage: String {
        switch self {
        case .home: "house"
        case .feature: "square.grid.2x2"
        case .profile: "person"
        }
    }

    /// Tên màn cho analytics `app_screen_view`.
    var screenName: String {
        switch self {
        case .home: "home"
        case .feature: "feature"
        case .profile: "profile"
        }
    }

    var accessibilityID: String {
        switch self {
        case .home: AccessibilityID.Main.homeTab
        case .feature: AccessibilityID.Main.featureTab
        case .profile: AccessibilityID.Main.profileTab
        }
    }
}
