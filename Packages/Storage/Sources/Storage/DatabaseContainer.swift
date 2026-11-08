import Foundation
import SwiftData
import Core

/// Một `ModelContainer` duy nhất cho toàn app (schema gộp). Thêm `@Model` mới → thêm vào `schema`.
public enum DatabaseContainer {
    public static let schema = Schema([
        BookmarkEntity.self,
    ])

    /// - Parameter inMemory: dùng cho test/preview.
    public static func make(inMemory: Bool = false) -> ModelContainer {
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: inMemory)
        do {
            return try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            // Schema đổi không migrate được: base chọn xoá store và tạo lại thay vì crash.
            // Project thật nên thay bằng VersionedSchema + MigrationPlan trước khi release.
            Logger.error("ModelContainer failed: \(error). Recreating in-memory fallback.", category: "Storage")
            let fallback = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
            // swiftlint:disable:next force_try
            return try! ModelContainer(for: schema, configurations: [fallback])
        }
    }

    public static let shared: ModelContainer = make()
}
