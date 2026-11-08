import XCTest
@testable import Analytics

final class AnalyticsServiceTests: XCTestCase {
    func testFansOutToAllPlugins() {
        let a = SpyPlugin(), b = SpyPlugin()
        let sut = DefaultAnalyticsService(plugins: [a, b])

        sut.log(.screenView("home"))

        XCTAssertEqual(a.events, [.screenView("home")])
        XCTAssertEqual(b.events, [.screenView("home")])
    }

    func testRemoteConfigDefaultsWithoutFirebase() {
        let source = DefaultRemoteConfigSource()
        XCTAssertTrue(source.bool(.featureEnabled))
    }
}

private final class SpyPlugin: AnalyticsPlugin, @unchecked Sendable {
    var events: [AnalyticsEvent] = []
    func log(_ event: AnalyticsEvent) { events.append(event) }
    func setUserProperty(_ value: String?, for name: String) {}
}
