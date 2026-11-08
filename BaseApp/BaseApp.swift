import SwiftUI
import Core
import Data
import Analytics
import DesignSystem

@main
struct BaseApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @StateObject private var coordinator: AppCoordinator
    @AppStorage(AppAppearance.storageKey) private var appearance: AppAppearance = .system

    init() {
        let coordinator = AppCoordinator()
        _coordinator = StateObject(wrappedValue: coordinator)

        // Thứ tự quan trọng: font → analytics (Firebase nếu có plist) → DI Data → router.
        DesignSystem.setup()
        AnalyticsBootstrap.configure()
        DataAssembly.registerAll()
        Container.shared.navigationRouter.register { [weak coordinator] in coordinator! }
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(coordinator)
                .preferredColorScheme(appearance.colorScheme)
        }
    }
}
