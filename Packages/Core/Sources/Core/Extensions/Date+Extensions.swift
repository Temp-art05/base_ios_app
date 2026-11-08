import Foundation

public extension Date {
    /// `true` nếu cùng ngày (theo calendar hiện tại) với `other`.
    func isSameDay(as other: Date) -> Bool {
        Calendar.current.isDate(self, inSameDayAs: other)
    }
}
