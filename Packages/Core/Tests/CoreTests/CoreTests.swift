import XCTest
@testable import Core

final class CoreTests: XCTestCase {
    func testSafeSubscript() {
        let values = [1, 2, 3]
        XCTAssertEqual(values[safe: 1], 2)
        XCTAssertNil(values[safe: 9])
    }

    func testTrimmed() {
        XCTAssertEqual("  hi \n".trimmed, "hi")
    }

    func testCachedOnceReturnsSameValue() async throws {
        let cache = CachedOnce<Int>()
        let calls = Counter()
        let first = try await cache.value { calls.increment(); return 7 }
        let second = try await cache.value { calls.increment(); return 8 }
        XCTAssertEqual(first, 7)
        XCTAssertEqual(second, 7)
        XCTAssertEqual(calls.count, 1)
    }
}

private final class Counter: @unchecked Sendable {
    private let lock = NSLock()
    private var value = 0
    var count: Int { lock.lock(); defer { lock.unlock() }; return value }
    func increment() { lock.lock(); value += 1; lock.unlock() }
}

final class EnvironmentTests: XCTestCase {
    func testEnvironmentFallbacks() {
        XCTAssertEqual(Environment.baseURL, "https://dummyjson.com")
        XCTAssertEqual(Environment.assetBaseURL, Environment.baseURL)
    }
}
