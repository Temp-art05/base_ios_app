import Foundation

public extension Collection {
    /// Truy cập an toàn, trả `nil` khi index ngoài phạm vi.
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

public extension String {
    var trimmed: String { trimmingCharacters(in: .whitespacesAndNewlines) }
}
