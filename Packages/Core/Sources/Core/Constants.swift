import Foundation
import UIKit

/// Hằng số dùng chung. Giá trị phụ thuộc môi trường → `Environment` (xcconfig), KHÔNG để ở đây.
public enum Constants {
    public enum Links {
        // TODO: thay bằng URL thật trước khi release.
        public static let privacyPolicy = URL(string: "https://example.com/privacy")!
        public static let termsOfUse = URL(string: "https://example.com/terms")!
        public static let support = URL(string: "mailto:support@example.com")!
    }

    public enum Device {
        /// iOS 26+ dùng TabView native (Liquid Glass); thấp hơn có thể dùng tab bar tuỳ biến.
        public static var isSupportLiquidGlass: Bool {
            if #available(iOS 26, *) { return true }
            return false
        }
    }

    public enum Timing {
        /// Thời gian splash tối thiểu (giây).
        public static let minSplash: Double = 0.6
    }
}
