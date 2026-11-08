import Foundation

// MARK: - Navigation Action
// Định nghĩa what navigation operations are có thể có.

public enum NavigationAction: Sendable {
    /// Push a new screen onto the navigation stack
    case push(Route)

    /// Push and remove current screen from backstack
    case pushAndReplace(Route)

    /// Pop back to previous screen
    case pop

    /// Pop to a specific route in the backstack
    case popTo(Route, inclusive: Bool)

    /// Pop to root (clear entire backstack)
    case popToRoot

    /// Pop to root and then push a new route
    case popToRootAndPush(Route)

    /// Switch the selected tab in MainView (0=home, 1=feature, 2=profile)
    case switchTab(Int)

    /// Present a sheet
    case sheet(Route)

    /// Present a fullscreen cover
    case fullScreenCover(Route)

    /// Dismiss the presented sheet/cover
    case dismiss
}
