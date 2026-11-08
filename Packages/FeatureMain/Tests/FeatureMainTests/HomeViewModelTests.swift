import XCTest
import Core
import Domain
@testable import FeatureMain

@MainActor
final class HomeViewModelTests: XCTestCase {
    override func setUp() {
        super.setUp()
        Container.shared.reset()
    }

    override func tearDown() {
        Container.shared.reset()
        super.tearDown()
    }

    func testOnAppearLoadsPosts() async {
        let stub = StubPostUseCase(pages: [Page(items: [Post(id: 1, title: "A", body: "B")], hasMore: true)])
        Container.shared.postUseCase.register { stub }
        let sut = HomeViewModel()

        sut.onAppear()
        await waitUntil { sut.loadState == .loaded }

        XCTAssertEqual(sut.posts.map(\.id), [1])
        XCTAssertTrue(sut.hasMore)
    }

    func testFailureShowsDomainMessage() async {
        let stub = StubPostUseCase(error: DomainError.noConnection)
        Container.shared.postUseCase.register { stub }
        let sut = HomeViewModel()

        sut.onAppear()
        await waitUntil { if case .failed = sut.loadState { true } else { false } }

        XCTAssertEqual(sut.loadState, .failed(DomainError.noConnection.userMessage))
    }

    func testToggleBookmarkUpdatesRow() async {
        let stub = StubPostUseCase(pages: [Page(items: [Post(id: 1, title: "A", body: "B")], hasMore: false)])
        Container.shared.postUseCase.register { stub }
        let sut = HomeViewModel()
        sut.onAppear()
        await waitUntil { sut.loadState == .loaded }

        sut.toggleBookmark(sut.posts[0])
        await waitUntil { sut.posts[0].isBookmarked }

        XCTAssertTrue(sut.posts[0].isBookmarked)
    }

    private func waitUntil(timeout: TimeInterval = 2, _ condition: @MainActor () -> Bool) async {
        let deadline = Date().addingTimeInterval(timeout)
        while !condition(), Date() < deadline {
            try? await Task.sleep(for: .milliseconds(10))
        }
    }
}

private final class StubPostUseCase: PostUseCase, @unchecked Sendable {
    var pages: [Page<Post>]
    var error: Error?

    init(pages: [Page<Post>] = [], error: Error? = nil) {
        self.pages = pages
        self.error = error
    }

    func loadPage(loaded: Int, query: String) async throws -> Page<Post> {
        if let error { throw error }
        return pages.isEmpty ? Page(items: [], hasMore: false) : pages.removeFirst()
    }
    func post(id: Int) async throws -> Post { Post(id: id, title: "", body: "") }
    func toggleBookmark(_ post: Post) async throws -> Post {
        var copy = post
        copy.isBookmarked.toggle()
        return copy
    }
    func bookmarks() async throws -> [Post] { [] }
}
