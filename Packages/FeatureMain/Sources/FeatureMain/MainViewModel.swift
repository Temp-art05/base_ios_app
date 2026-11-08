import Foundation
import Core
import Analytics

/// Chỉ giữ state tab. Logic từng tab nằm ở ViewModel của tab đó.
@MainActor
public final class MainViewModel: ObservableObject {
    @Published public var selectedTab: AppTab

    @Injected(\.analyticsService) private var analytics

    public init(initialTab: AppTab = .home) {
        selectedTab = initialTab
    }

    func onAppear() {
        analytics.log(.screenView(selectedTab.screenName))
    }

    func switchTab(_ tab: AppTab) {
        guard tab != selectedTab else { return }
        selectedTab = tab
        analytics.log(.screenView(tab.screenName))
    }

    /// Nhận yêu cầu đổi tab từ `NavigationRouter.switchTab(_:)`.
    func handleSwitchTab(_ notification: Notification) {
        guard let index = notification.userInfo?["index"] as? Int, let tab = AppTab(rawValue: index) else { return }
        switchTab(tab)
    }
}
