import Foundation

/// Route type-safe giữa các module. Định nghĩa ở Core để mọi feature tham chiếu mà không import lẫn nhau.
/// Thêm màn mới: thêm case ở đây → map view trong `RouteDestination` (app target).
public enum Route: Hashable, Sendable {
    case postDetail(id: Int)
    case settings
}
