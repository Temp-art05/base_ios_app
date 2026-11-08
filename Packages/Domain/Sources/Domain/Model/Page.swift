import Foundation

/// Một trang kết quả phân trang. ViewModel không tự so `count >= pageSize` — dùng `hasMore`.
public struct Page<Item: Sendable>: Sendable {
    public let items: [Item]
    public let hasMore: Bool

    public init(items: [Item], hasMore: Bool) {
        self.items = items
        self.hasMore = hasMore
    }
}
