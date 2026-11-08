import Foundation

public extension Notification.Name {
    /// Đổi tab của MainView. `userInfo["index"]` là `Int` (rawValue của `AppTab`).
    /// Phát bởi `NavigationRouter.switchTab(_:)`, `MainView` lắng nghe.
    static let switchTab = Notification.Name("base.app.switchTab")
}
