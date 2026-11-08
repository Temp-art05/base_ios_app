# Base iOS App

Template app iOS: **Clean Architecture + MVVM + SwiftUI**, modular Swift Package Manager.
Clone về là chạy được ngay — kể cả khi chưa cấu hình Firebase.

## Tech stack

| Mảng | Chọn |
|---|---|
| Nền tảng | iOS 17+ · Swift 5 mode · Xcode 26+ |
| UI | SwiftUI, `ObservableObject`/`@StateObject`, Dynamic Type, light/dark/system |
| DI | [Factory](https://github.com/hmlongco/Factory) (`@Injected`) |
| Network | `URLSession` async/await qua `Networking.APIClient`, log qua `Core.NetworkLogger` |
| Database | SwiftData (`@ModelActor`) |
| Firebase | Analytics · Crashlytics · Remote Config — sau interface, **no-op nếu thiếu `GoogleService-Info.plist`** |
| Navigation | `Route` enum + `AppCoordinator` + callback |
| Test | XCTest theo từng package |

## Cấu trúc

```
BaseApp.xcodeproj      4 config / scheme: DevDebug · DevRelease · ProdDebug · ProdRelease
BaseApp/               App/AppDelegate, BaseApp, Navigation/{AppCoordinator,RootView,RootViewModel,RouteDestination},
                       Splash, Policy (đồng ý điều khoản), Onboarding (mẫu 3 trang)
Configurations/        DevDebug / DevRelease / ProdDebug / ProdRelease .xcconfig + Info.plist
Packages/
  Core                 Logger, NetworkLogger, Environment, Constants, Route/Router, AsyncCache, Keychain, DeviceID
  Domain               model, repository protocol, UseCase, DomainError, DI slot
  Data                 remote/local DataSource, DTO, Mapper, Repository impl, DataAssembly
  Networking           APIClient, Endpoint, APIError, Auth/{TokenStore, AuthToken, JWTDecoder, Interceptor}
  Storage              SwiftData entity, DatabaseContainer, UserDefaultsStorage
  Analytics            AnalyticsService + plugin, CrashReporter, RemoteConfigSource (Firebase optional)
  DesignSystem         token màu/font/spacing/radius/size, Strings + Localizable (en, vi), component chung, font Outfit
  FeatureMain          MainView/MainViewModel + Screens/{Home,Feature,Profile,Settings,PostDetail} + Components + Shared
```

```
App            → mọi package
Feature*       → Core, Domain, DesignSystem, Analytics   (KHÔNG Data/Networking/Storage, KHÔNG feature khác)
Data           → Core, Domain, Networking, Storage
Domain         → Core
Networking, Storage, Analytics, DesignSystem → Core
```

Feature giao tiếp nhau qua `Route` (điều hướng) hoặc protocol đặt ở `Core` (bridge) — không import lẫn nhau.

## Build configuration

| Config / Scheme | Môi trường (`APP_ENV`) | Bundle ID | `DEBUG` |
|---|---|---|---|
| `DevDebug` | dev | `com.base.app.dev` | có |
| `DevRelease` | dev | `com.base.app.dev` | không |
| `ProdDebug` | prod | `com.base.app` | có |
| `ProdRelease` | prod | `com.base.app` | không |

Mỗi config có **một file xcconfig độc lập** (`Configurations/DevDebug.xcconfig`…), không include file khác.
Biến có sẵn: `APP_ENV`, `APP_BUNDLE_ID`, `APP_DISPLAY_NAME`, `BASE_URL`, `ASSET_BASE_URL`, `API_KEY`, `API_BUNDLE_ID`
→ map qua `Configurations/Info.plist` → đọc bằng `Core.Environment` (`name`, `isDev`, `baseURL`, `assetBaseURL`, `apiKey`, `apiBundleID`).
Thêm biến mới: khai ở **cả 4 file** + `Info.plist` + getter ở `Environment.swift`. `MARKETING_VERSION`/`CURRENT_PROJECT_VERSION` ở target settings.
## Luồng mẫu

Tab **Home** chạy thật đủ tầng: `dummyjson.com/posts` → `PostRemoteDataSource` → `PostRepositoryImpl` → `PostUseCase` →
`HomeViewModel` (phân trang, tìm kiếm debounce, bookmark lưu SwiftData). Đọc `docs/guides/sample-flow.md`.

## Bắt đầu

```bash
git clone <repo-url> my-new-app && cd my-new-app
xcodebuild -project BaseApp.xcodeproj -scheme "BaseApp DevDebug" \
  -destination 'platform=iOS Simulator,name=iPhone 17' build
# test từng package
cd Packages/Domain && xcodebuild test -scheme Domain -destination 'platform=iOS Simulator,name=iPhone 17'
```

Không cần `GoogleService-Info.plist`. Sau đó theo **[TODO.md](TODO.md)** để đổi tên/brand/API.

## Tài liệu

`CLAUDE.md` (quy ước cho AI agent) · `docs/rules/*` (rule code) · `docs/guides/*` (cách làm).
