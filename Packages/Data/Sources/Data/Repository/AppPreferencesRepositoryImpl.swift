import Foundation
import Domain
import Storage

final class AppPreferencesRepositoryImpl: AppPreferencesRepository, @unchecked Sendable {
    private enum Key {
        static let policy = "pref_policy_accepted"
        static let onboarding = "pref_onboarding_completed"
    }

    private let storage: UserDefaultsStorage

    init(storage: UserDefaultsStorage = UserDefaultsStorage()) {
        self.storage = storage
    }

    var hasAcceptedPolicy: Bool { storage.bool(Key.policy) }
    var hasCompletedOnboarding: Bool { storage.bool(Key.onboarding) }
    func setPolicyAccepted() { storage.set(true, for: Key.policy) }
    func setOnboardingCompleted() { storage.set(true, for: Key.onboarding) }
}
