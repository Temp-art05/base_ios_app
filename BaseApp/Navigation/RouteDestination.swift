import SwiftUI
import Core
import FeatureMain

/// Map `Route` → View. Thêm màn mới: thêm case ở `Core/Navigation/Route.swift` rồi map ở đây.
enum RouteDestination {
    @ViewBuilder
    static func view(for route: Route, nav: NavigationRouter) -> some View {
        switch route {
        case .postDetail(let id):
            PostDetailView(postID: id)
        case .settings:
            SettingsView()
        }
    }

    /// View cho sheet / fullScreenCover.
    @ViewBuilder
    static func sheet(for route: Route, nav: NavigationRouter) -> some View {
        NavigationStack {
            view(for: route, nav: nav)
        }
    }
}
