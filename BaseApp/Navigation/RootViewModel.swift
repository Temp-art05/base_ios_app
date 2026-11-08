import Foundation
import Core
import Domain
import Analytics

/// Điều phối khởi động: splash → (policy) → (onboarding) → main. Logic quyết định ở `AppStartupUseCase`.
@MainActor
final class RootViewModel: ObservableObject {
    @Published private(set) var showSplash = true
    @Published private(set) var step: StartupStep = .main

    @Injected(\.appStartupUseCase) private var startup
    @Injected(\.remoteConfigSource) private var remoteConfig
    @Injected(\.analyticsService) private var analytics

    private let splash = SplashViewModel()

    func start() async {
        let remoteConfig = self.remoteConfig
        await splash.run { await remoteConfig.refresh() }
        step = startup.nextStep()
        showSplash = false
    }

    func acceptPolicy() {
        startup.acceptPolicy()
        analytics.log(.policyAccepted)
        step = startup.nextStep()
    }

    func completeOnboarding() {
        startup.completeOnboarding()
        analytics.log(.onboardingCompleted)
        step = startup.nextStep()
    }

    func appDidBecomeActive() {
        guard !showSplash else { return }
        analytics.log(.appForeground)
    }
}
