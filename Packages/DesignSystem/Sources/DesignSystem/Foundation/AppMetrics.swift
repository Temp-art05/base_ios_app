import SwiftUI

/// Khoảng cách (thang 4pt).
public enum AppSpacing {
    public static let xxs: CGFloat = 2
    public static let xs: CGFloat = 4
    public static let sm: CGFloat = 8
    public static let md: CGFloat = 12
    public static let lg: CGFloat = 16
    public static let xl: CGFloat = 24
    public static let xxl: CGFloat = 32
    public static let xxxl: CGFloat = 48
}

/// Bo góc.
public enum AppRadius {
    public static let sm: CGFloat = 8
    public static let md: CGFloat = 12
    public static let lg: CGFloat = 16
    public static let xl: CGFloat = 24
    public static let pill: CGFloat = 999
}

/// Kích thước cố định của component.
public enum AppSize {
    public static let buttonHeight: CGFloat = 52
    public static let iconSm: CGFloat = 16
    public static let iconMd: CGFloat = 24
    public static let iconLg: CGFloat = 32
    public static let thumbnail: CGFloat = 72
    public static let hairline: CGFloat = 1
}

/// Opacity, thời lượng, animation.
public enum AppOpacity {
    public static let disabled: Double = 0.4
    public static let pressed: Double = 0.85
    public static let overlay: Double = 0.5
}

public enum AppAnimation {
    public static let fast: Animation = .easeOut(duration: 0.15)
    public static let standard: Animation = .easeInOut(duration: 0.25)
}

/// Giao diện sáng/tối do người dùng chọn (mặc định theo hệ thống). Lưu bằng `@AppStorage`.
public enum AppAppearance: String, CaseIterable, Identifiable {
    case system, light, dark

    public static let storageKey = "app_appearance"
    public var id: String { rawValue }

    public var title: String {
        switch self {
        case .system: "System"
        case .light: "Light"
        case .dark: "Dark"
        }
    }

    public var colorScheme: ColorScheme? {
        switch self {
        case .system: nil
        case .light: .light
        case .dark: .dark
        }
    }
}
