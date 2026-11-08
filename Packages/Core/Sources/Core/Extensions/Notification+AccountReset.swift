import Foundation

public extension Notification.Name {
    /// Phát khi phiên người dùng bị reset (logout/xoá tài khoản). Coordinator đóng hết màn, cache xoá dữ liệu.
    static let accountDidReset = Notification.Name("base.app.accountDidReset")
}
