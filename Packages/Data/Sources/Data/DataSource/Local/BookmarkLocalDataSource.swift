import Foundation
import SwiftData
import Storage

/// Snapshot thuần (Sendable) đi qua ranh giới actor — không để `@Model` lọt ra ngoài.
struct BookmarkRecord: Sendable, Equatable {
    let postID: Int
    let title: String
    let body: String
    let tags: [String]
    let likes: Int
    let views: Int
}

protocol BookmarkLocalDataSource: Sendable {
    func ids() async throws -> Set<Int>
    func all() async throws -> [BookmarkRecord]
    func upsert(_ record: BookmarkRecord) async throws
    func remove(postID: Int) async throws
}

/// DB luôn truy cập qua `@ModelActor` (không chạm `ModelContext` ngoài actor).
@ModelActor
actor BookmarkLocalDataSourceImpl: BookmarkLocalDataSource {
    func ids() throws -> Set<Int> {
        Set(try modelContext.fetch(FetchDescriptor<BookmarkEntity>()).map(\.postID))
    }

    func all() throws -> [BookmarkRecord] {
        var descriptor = FetchDescriptor<BookmarkEntity>(sortBy: [SortDescriptor(\.createdAt, order: .reverse)])
        descriptor.includePendingChanges = true
        return try modelContext.fetch(descriptor).map {
            BookmarkRecord(postID: $0.postID, title: $0.title, body: $0.body, tags: $0.tags, likes: $0.likes, views: $0.views)
        }
    }

    func upsert(_ record: BookmarkRecord) throws {
        let id = record.postID
        let existing = try modelContext.fetch(FetchDescriptor<BookmarkEntity>(predicate: #Predicate { $0.postID == id }))
        guard existing.isEmpty else { return }
        modelContext.insert(BookmarkEntity(
            postID: record.postID, title: record.title, body: record.body,
            tags: record.tags, likes: record.likes, views: record.views
        ))
        try modelContext.save()
    }

    func remove(postID: Int) throws {
        let id = postID
        try modelContext.delete(model: BookmarkEntity.self, where: #Predicate { $0.postID == id })
        try modelContext.save()
    }
}
