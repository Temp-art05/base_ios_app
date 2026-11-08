import Foundation

/// Accessibility identifier cho XCUITest. Naming: `snake_case` dạng `{screen}_{element}_{type}`.
/// Thêm View mới ⇒ thêm ID vào đây (hoặc `AccessibilityID` của package đó) TRƯỚC, rồi gán trong View.
public enum DSAccessibilityID {
    public enum State {
        public static let loading = "state_loading_view"
        public static let error = "state_error_view"
        public static let retryButton = "state_retry_button"
        public static let empty = "state_empty_view"
    }

    public enum Button {
        public static let primary = "button_primary"
    }
}
