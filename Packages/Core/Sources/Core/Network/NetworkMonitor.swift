import Foundation
import Network
import Combine

// MARK: - NetworkMonitor
// App-wide internet reachability via Network.framework (NWPathMonitor). Exposes the current state
// (`isConnected`) and a de-duplicated publisher so ViewModels can auto-refresh when connectivity is
// restored. Resolve through DI (`@Injected(\.networkMonitor)`) — do not reference the singleton in
// feature code directly.

public protocol NetworkMonitoring: Sendable {
    /// Latest known reachability (`true` when a satisfied path is available).
    var isConnected: Bool { get }
    /// Emits the reachability whenever it flips (duplicates removed). Replays the current value.
    var isConnectedPublisher: AnyPublisher<Bool, Never> { get }
}

public final class NetworkMonitor: NetworkMonitoring, @unchecked Sendable {
    public static let shared = NetworkMonitor()

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "com.base.app.core.network-monitor")
    // Optimistically start "connected" so the first launch doesn't flash an offline state.
    private let subject = CurrentValueSubject<Bool, Never>(true)

    public var isConnected: Bool { subject.value }

    public var isConnectedPublisher: AnyPublisher<Bool, Never> {
        subject.removeDuplicates().eraseToAnyPublisher()
    }

    private init() {
        monitor.pathUpdateHandler = { [subject] path in
            subject.send(path.status == .satisfied)
        }
        monitor.start(queue: queue)
    }
}
