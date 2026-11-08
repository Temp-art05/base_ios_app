import Foundation
import Core
import Analytics

@MainActor
final class OnboardingViewModel: ObservableObject {
    static let pageCount = 3

    @Published var page = 1 {
        didSet { if page != oldValue { analytics.log(.onboardingPage(page)) } }
    }

    @Injected(\.analyticsService) private var analytics

    var isLastPage: Bool { page == Self.pageCount }

    func onAppear() { analytics.log(.onboardingPage(page)) }

    /// Trả `true` khi đã ở trang cuối (caller kết thúc onboarding).
    func advance() -> Bool {
        guard !isLastPage else { return true }
        page += 1
        return false
    }
}
