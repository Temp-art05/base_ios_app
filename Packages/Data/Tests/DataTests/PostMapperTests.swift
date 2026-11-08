import XCTest
import Domain
import Networking
@testable import Data

final class PostMapperTests: XCTestCase {
    func testMapsListAndHasMore() throws {
        let json = """
        {"posts":[{"id":1,"title":"A","body":"B","tags":["x"],"views":3,"reactions":{"likes":2,"dislikes":0}}],
         "total":5,"skip":0,"limit":1}
        """.data(using: .utf8)!
        let dto = try JSONDecoder().decode(PostListDTO.self, from: json)

        let page = PostMapper.map(dto, bookmarkedIDs: [1])

        XCTAssertEqual(page.items.first?.likes, 2)
        XCTAssertEqual(page.items.first?.isBookmarked, true)
        XCTAssertTrue(page.hasMore)
    }

    func testLastPageHasNoMore() throws {
        let dto = PostListDTO(posts: [PostDTO(id: 1, title: "", body: "", tags: nil, views: nil, reactions: nil)], total: 1, skip: 0, limit: 1)
        XCTAssertFalse(PostMapper.map(dto, bookmarkedIDs: []).hasMore)
    }

    func testErrorMapping() {
        XCTAssertEqual(DomainErrorMapper.map(APIError.noConnection) as? DomainError, .noConnection)
        XCTAssertEqual(DomainErrorMapper.map(APIError.http(status: 404, message: nil)) as? DomainError, .notFound)
        XCTAssertEqual(DomainErrorMapper.map(APIError.http(status: 500, message: "x")) as? DomainError, .server(message: "x"))
    }
}
