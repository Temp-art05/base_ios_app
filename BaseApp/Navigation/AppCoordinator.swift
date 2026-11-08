import SwiftUI
import Core

/// Sở hữu `NavigationPath` + sheet/fullScreen và là `NavigationRouter` (đăng ký vào Container ở `BaseApp.init`).
/// ViewModel không biết coordinator — View nhận closure (`onPushRoute`, `onBack`…).
@MainActor
final class AppCoordinator: ObservableObject, NavigationRouter {
    @Published var path = NavigationPath()
    @Published var presentedSheet: Route?
    @Published var presentedFullScreen: Route?
    var fullScreenDismissHandler: (@MainActor () -> Void)?

    func perform(_ action: NavigationAction) {
        switch action {
        case .push(let route):
            path.append(route)
        case .pushAndReplace(let route):
            if !path.isEmpty { path.removeLast() }
            path.append(route)
        case .pop:
            guard !path.isEmpty else { return }
            path.removeLast()
        case .popTo, .popToRoot:
            path = NavigationPath()
        case .popToRootAndPush(let route):
            path = NavigationPath()
            path.append(route)
        case .switchTab(let index):
            NotificationCenter.default.post(name: .switchTab, object: nil, userInfo: ["index": index])
        case .sheet(let route):
            presentedSheet = route
        case .fullScreenCover(let route):
            presentedFullScreen = route
        case .dismiss:
            if presentedSheet != nil {
                presentedSheet = nil
            } else if presentedFullScreen != nil {
                presentedFullScreen = nil
                let handler = fullScreenDismissHandler
                fullScreenDismissHandler = nil
                handler?()
            }
        }
    }
}
