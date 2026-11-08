import Foundation

/// Preference cấp app (cờ lần đầu mở). Impl ở `Data` (UserDefaults).
public protocol AppPreferencesRepository: Sendable {
    var hasAcceptedPolicy: Bool { get }
    var hasCompletedOnboarding: Bool { get }
    func setPolicyAccepted()
    func setOnboardingCompleted()
}
