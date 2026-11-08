import Foundation
import os

/// Logger tập trung. `debug` chỉ phát ra trong DEBUG; `info`/`error` luôn phát ra.
public enum Logger {
    private static let subsystem = Bundle.main.bundleIdentifier ?? "com.base.app"

    /// Subsystem riêng cho analytics để lọc trên Console.app không dính log SDK bên thứ ba.
    private static let analyticsSubsystem = "\(subsystem).analytics"

    public static func analytics(_ message: String, category: String = "Analytics") {
        #if DEBUG
        os.Logger(subsystem: analyticsSubsystem, category: category).debug("\(message)")
        #endif
    }

    public static func debug(_ message: String, category: String = "General") {
        #if DEBUG
        os.Logger(subsystem: subsystem, category: category).debug("\(message)")
        #endif
    }

    public static func info(_ message: String, category: String = "General") {
        os.Logger(subsystem: subsystem, category: category).info("\(message)")
    }

    public static func error(_ message: String, category: String = "General") {
        os.Logger(subsystem: subsystem, category: category).error("\(message)")
    }

    public static func network(_ message: String) {
        debug(message, category: "Network")
    }
}
