import SwiftUI
import Core
import DesignSystem

/// Shell 3 tab. Điều hướng đi qua callback `onPushRoute` (ViewModel không biết navigation).
public struct MainView: View {
    @StateObject private var viewModel: MainViewModel
    private let onPushRoute: (Route) -> Void

    public init(initialTab: AppTab = .home, onPushRoute: @escaping (Route) -> Void) {
        _viewModel = StateObject(wrappedValue: MainViewModel(initialTab: initialTab))
        self.onPushRoute = onPushRoute
    }

    public var body: some View {
        TabView(selection: Binding(get: { viewModel.selectedTab }, set: { viewModel.switchTab($0) })) {
            HomeView(onOpenPost: { onPushRoute(.postDetail(id: $0)) })
                .tabItem { Label(AppTab.home.title, systemImage: AppTab.home.systemImage) }
                .tag(AppTab.home)
                .accessibilityIdentifier(AppTab.home.accessibilityID)

            FeatureView()
                .tabItem { Label(AppTab.feature.title, systemImage: AppTab.feature.systemImage) }
                .tag(AppTab.feature)
                .accessibilityIdentifier(AppTab.feature.accessibilityID)

            ProfileView(
                onOpenSettings: { onPushRoute(.settings) },
                onOpenPost: { onPushRoute(.postDetail(id: $0)) }
            )
            .tabItem { Label(AppTab.profile.title, systemImage: AppTab.profile.systemImage) }
            .tag(AppTab.profile)
            .accessibilityIdentifier(AppTab.profile.accessibilityID)
        }
        .tint(AppColor.primary)
        .accessibilityIdentifier(AccessibilityID.Main.tabBar)
        .onAppear { viewModel.onAppear() }
        .onReceive(NotificationCenter.default.publisher(for: .switchTab)) { viewModel.handleSwitchTab($0) }
    }
}
