# Kiến trúc

`presentation → domain ← data`. **Domain là tâm**, chỉ phụ thuộc `Core`.

| Package | Chứa |
|---|---|
| `Core` | Logger, NetworkLogger, Environment, Route/NavigationRouter, AsyncCache, DI export (Factory) |
| `Domain` | `Model/`, `Repository/` (protocol), `UseCase/`, `Error/DomainError`, `Config/`, `DI/` (slot + factory) |
| `Data` | `DataSource/Remote` (DTO, endpoint call), `DataSource/Local` (SwiftData `@ModelActor`), `Mapper/`, `Repository/` impl, `Error/`, `DI/DataAssembly` |
| `Networking` | `APIClient`, `Endpoint`, `APIError`, `RequestInterceptor` — không biết domain |
| `Storage` | `@Model` entity, `DatabaseContainer` (1 schema gộp), `UserDefaultsStorage` |
| `Analytics` | `AnalyticsService` + plugin, `CrashReporter`, `RemoteConfigSource`; Firebase chỉ bật khi có plist |
| `DesignSystem` | token + component dùng chung |
| `Feature*` | Presentation (MVVM) của một nhóm màn: `MainView`/`MainViewModel`, `Screens/<Màn>/`, `Components/`, `Shared/` |

## Dependency

```
App → tất cả                       Feature* → Core, Domain, DesignSystem, Analytics
Data → Core, Domain, Networking, Storage     Domain → Core
```

Cứng: Domain không import Data/Networking/Storage/SwiftData UI; Feature không import Data/Networking/Storage và không import feature khác.
Feature cần chức năng của feature khác: điều hướng qua `Route`; gọi chức năng qua protocol đặt ở `Core` (impl ở feature kia, đăng ký vào Container ở app).

## DI (Factory)

- **Slot** repository khai ở `Domain/DI/Container+Domain.swift` (mặc định `fatalError` nếu chưa register).
- Impl đăng ký trong `DataAssembly.registerAll()` (gọi ở `BaseApp.init`).
- UseCase = factory ở Domain. ViewModel: `@Injected(\.postUseCase)`.
- Thêm dependency: slot → impl → register → (use case factory) → `@Injected`.
- Test: `Container.shared.xUseCase.register { stub }`, `Container.shared.reset()` ở setUp/tearDown.

## Feature riêng dữ liệu

Dữ liệu chỉ một feature dùng vẫn đặt ở Domain/Data (giữ ranh giới package). Tách package mới (`FeatureFoo`) khi feature đủ lớn:
copy `FeatureMain/Package.swift`, thêm package vào project (Frameworks + package reference), thêm `AccessibilityID.swift`.

## Điều hướng

`Route` (Core) → `AppCoordinator` (path/sheet/fullScreen, là `NavigationRouter`) → `RouteDestination` map Route→View.
View nhận closure (`onPushRoute`, `onBack`); ViewModel không biết navigation.
