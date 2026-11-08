import Foundation
import Combine

// MARK: - Navigation Router Protocol
// Hợp đồng điều hướng.
// Defined in Core so feature modules can request navigation without knowing about each other.

@MainActor
public protocol NavigationRouter: AnyObject {
    func perform(_ action: NavigationAction)
    /// One-shot callback fired when a fullScreenCover is dismissed via `perform(.dismiss)`.
    var fullScreenDismissHandler: (@MainActor () -> Void)? { get set }
}

// MARK: - Convenience extensions
public extension NavigationRouter {
    func push(_ route: Route) {
        perform(.push(route))
    }

    func pop() {
        perform(.pop)
    }

    func popToRoot() {
        perform(.popToRoot)
    }

    func present(_ route: Route) {
        perform(.sheet(route))
    }

    func presentFullScreen(_ route: Route) {
        perform(.fullScreenCover(route))
    }

    func dismiss() {
        perform(.dismiss)
    }

    func switchTab(_ index: Int) {
        perform(.switchTab(index))
    }
}
