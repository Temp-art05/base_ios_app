import SwiftUI
import UIKit

// Token màu. KHÔNG hardcode hex ngoài file này. Đổi brand = sửa thang `Primary` (giữ tên p50…p950).

extension Color {
    /// Màu động light/dark từ hai hex.
    fileprivate static func dynamic(light: UInt32, dark: UInt32) -> Color {
        Color(UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: dark) : UIColor(hex: light) })
    }

    fileprivate init(hex: UInt32) { self.init(UIColor(hex: hex)) }
}

extension UIColor {
    fileprivate convenience init(hex: UInt32) {
        self.init(
            red: CGFloat((hex >> 16) & 0xFF) / 255,
            green: CGFloat((hex >> 8) & 0xFF) / 255,
            blue: CGFloat(hex & 0xFF) / 255,
            alpha: 1
        )
    }
}

/// Thang màu brand — PLACEHOLDER (indigo). Thay khi có brand thật.
public enum AppPrimary {
    public static let p50 = Color(hex: 0xEEF2FF)
    public static let p100 = Color(hex: 0xE0E7FF)
    public static let p200 = Color(hex: 0xC7D2FE)
    public static let p300 = Color(hex: 0xA5B4FC)
    public static let p400 = Color(hex: 0x818CF8)
    public static let p500 = Color(hex: 0x6366F1)
    public static let p600 = Color(hex: 0x4F46E5)
    public static let p700 = Color(hex: 0x4338CA)
    public static let p800 = Color(hex: 0x3730A3)
    public static let p900 = Color(hex: 0x312E81)
    public static let p950 = Color(hex: 0x1E1B4B)
}

public enum AppColor {
    // Nền
    public static let background = Color.dynamic(light: 0xFFFFFF, dark: 0x0B0B0F)
    public static let surface = Color.dynamic(light: 0xF4F4F7, dark: 0x16161D)
    public static let surfaceElevated = Color.dynamic(light: 0xFFFFFF, dark: 0x1F1F29)

    // Chữ
    public static let textPrimary = Color.dynamic(light: 0x0B0B0F, dark: 0xF5F5F7)
    public static let textSecondary = Color.dynamic(light: 0x5C5C6B, dark: 0xA0A0B0)
    public static let textOnPrimary = Color(hex: 0xFFFFFF)

    // Nhấn
    public static let primary = Color.dynamic(light: 0x4F46E5, dark: 0x818CF8)
    public static let primaryPressed = Color.dynamic(light: 0x4338CA, dark: 0x6366F1)
    public static let separator = Color.dynamic(light: 0xE4E4EC, dark: 0x2A2A36)

    // Ngữ nghĩa
    public static let success = Color(hex: 0x16A34A)
    public static let warning = Color(hex: 0xF59E0B)
    public static let error = Color(hex: 0xDC2626)
}
