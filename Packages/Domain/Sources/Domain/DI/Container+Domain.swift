import Core

/// DI của Domain.
/// - **Slot** (repository): Domain khai, `Data` đăng ký impl lúc launch (`DataAssembly.registerAll()`).
/// - **UseCase**: factory ngay ở Domain, ghép từ slot.
///
/// Thêm dependency mới: ① slot ở đây → ② impl ở Data/Storage → ③ register trong Assembly →
/// ④ (use case) factory ở đây → ⑤ ViewModel `@Injected(\.xUseCase)`.
public extension Container {
    // MARK: Config
    var appConfig: Factory<AppConfig> {
        self { AppConfig() }.singleton
    }

    // MARK: Repository slots
    var appPreferencesRepository: Factory<AppPreferencesRepository> {
        self { fatalError("Register AppPreferencesRepository: call DataAssembly.registerAll() in BaseApp.init") }
            .singleton
    }

    var postRepository: Factory<PostRepository> {
        self { fatalError("Register PostRepository: call DataAssembly.registerAll() in BaseApp.init") }
            .singleton
    }

    // MARK: Use cases
    var appStartupUseCase: Factory<AppStartupUseCase> {
        self { DefaultAppStartupUseCase(preferences: self.appPreferencesRepository()) }
    }

    var postUseCase: Factory<PostUseCase> {
        self { DefaultPostUseCase(repository: self.postRepository(), config: self.appConfig()) }
    }
}
