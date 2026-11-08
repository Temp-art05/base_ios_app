import XCTest
@testable import Domain

final class PostUseCaseTests: XCTestCase {
    func testLoadPageUsesFetchWhenQueryEmpty() async throws {
        let repo = StubPostRepository()
        let sut = DefaultPostUseCase(repository: repo, config: AppConfig(pageSize: 5))

        _ = try await sut.loadPage(loaded: 10, query: "   ")

        XCTAssertEqual(repo.lastFetch?.skip, 10)
        XCTAssertEqual(repo.lastFetch?.limit, 5)
        XCTAssertNil(repo.lastSearch)
    }

    func testLoadPageTrimsQueryAndSearches() async throws {
        let repo = StubPostRepository()
        let sut = DefaultPostUseCase(repository: repo, config: AppConfig(pageSize: 5))

        _ = try await sut.loadPage(loaded: 0, query: "  swift ")

        XCTAssertEqual(repo.lastSearch?.query, "swift")
    }

    func testToggleBookmarkFlipsAndPersists() async throws {
        let repo = StubPostRepository()
        let sut = DefaultPostUseCase(repository: repo, config: AppConfig())
        let post = Post(id: 1, title: "t", body: "b")

        let updated = try await sut.toggleBookmark(post)

        XCTAssertTrue(updated.isBookmarked)
        XCTAssertEqual(repo.bookmarkWrites.first?.1, true)
    }

    func testUserMessageForDomainError() {
        XCTAssertFalse(DomainError.noConnection.userMessage.isEmpty)
        XCTAssertEqual(DomainError.server(message: "boom").userMessage, "boom")
    }
}

final class StubPostRepository: PostRepository, @unchecked Sendable {
    var lastFetch: (skip: Int, limit: Int)?
    var lastSearch: (query: String, skip: Int, limit: Int)?
    var bookmarkWrites: [(Int, Bool)] = []

    func fetchPosts(skip: Int, limit: Int) async throws -> Page<Post> {
        lastFetch = (skip, limit)
        return Page(items: [], hasMore: false)
    }
    func fetchPost(id: Int) async throws -> Post { Post(id: id, title: "", body: "") }
    func search(query: String, skip: Int, limit: Int) async throws -> Page<Post> {
        lastSearch = (query, skip, limit)
        return Page(items: [], hasMore: false)
    }
    func bookmarkedIDs() async throws -> Set<Int> { [] }
    func setBookmarked(_ post: Post, isBookmarked: Bool) async throws { bookmarkWrites.append((post.id, isBookmarked)) }
    func bookmarkedPosts() async throws -> [Post] { [] }
}

final class AppStartupUseCaseTests: XCTestCase {
    func testStepOrderPolicyThenOnboardingThenMain() {
        let prefs = StubPreferences()
        let sut = DefaultAppStartupUseCase(preferences: prefs)

        XCTAssertEqual(sut.nextStep(), .policy)
        sut.acceptPolicy()
        XCTAssertEqual(sut.nextStep(), .onboarding)
        sut.completeOnboarding()
        XCTAssertEqual(sut.nextStep(), .main)
    }
}

private final class StubPreferences: AppPreferencesRepository, @unchecked Sendable {
    var hasAcceptedPolicy = false
    var hasCompletedOnboarding = false
    func setPolicyAccepted() { hasAcceptedPolicy = true }
    func setOnboardingCompleted() { hasCompletedOnboarding = true }
}
