import Foundation

/// Màn kế tiếp sau splash. Thứ tự: đồng ý policy → onboarding → main.
public enum StartupStep: Equatable, Sendable {
    case policy
    case onboarding
    case main
}

/// Luồng khởi động app (first launch). Mở rộng: login gate, force update, maintenance…
public protocol AppStartupUseCase: Sendable {
    func nextStep() -> StartupStep
    func acceptPolicy()
    func completeOnboarding()
}

public struct DefaultAppStartupUseCase: AppStartupUseCase {
    private let preferences: AppPreferencesRepository

    public init(preferences: AppPreferencesRepository) {
        self.preferences = preferences
    }

    public func nextStep() -> StartupStep {
        if !preferences.hasAcceptedPolicy { return .policy }
        if !preferences.hasCompletedOnboarding { return .onboarding }
        return .main
    }

    public func acceptPolicy() { preferences.setPolicyAccepted() }
    public func completeOnboarding() { preferences.setOnboardingCompleted() }
}
