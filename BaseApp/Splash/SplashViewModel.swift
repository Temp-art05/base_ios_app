import Foundation
import Core

/// Điều khiển splash: giữ tối thiểu `Constants.Timing.minSplash` giây trong khi bootstrap chạy song song.
@MainActor
final class SplashViewModel {
    /// Chạy `bootstrap` (remote config, kiểm tra phiên bản…) song song với thời gian tối thiểu của splash.
    func run(bootstrap: @escaping @Sendable () async -> Void) async {
        async let work: Void = bootstrap()
        try? await Task.sleep(for: .seconds(Constants.Timing.minSplash))
        await work
    }
}
