import Foundation
import Core
import FirebaseCrashlytics

public protocol CrashReporter: Sendable {
    func record(_ error: Error)
    func log(_ message: String)
    func setUserID(_ id: String?)
}

public struct NoopCrashReporter: CrashReporter {
    public init() {}
    public func record(_ error: Error) { Logger.error("non-fatal: \(error)", category: "Crash") }
    public func log(_ message: String) {}
    public func setUserID(_ id: String?) {}
}

public struct FirebaseCrashReporter: CrashReporter {
    public init() {}
    public func record(_ error: Error) { Crashlytics.crashlytics().record(error: error) }
    public func log(_ message: String) { Crashlytics.crashlytics().log(message) }
    public func setUserID(_ id: String?) { Crashlytics.crashlytics().setUserID(id) }
}
