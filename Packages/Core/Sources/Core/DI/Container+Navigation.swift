import Factory

public extension Container {
    /// Đăng ký trong `BaseApp.init` (AppCoordinator). Truy cập trước khi đăng ký ⇒ lỗi lập trình.
    var navigationRouter: Factory<NavigationRouter> {
        self { fatalError("Register NavigationRouter in BaseApp.init") }
            .singleton
    }
}
