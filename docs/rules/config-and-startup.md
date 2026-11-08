# Build config & startup flow

## 4 build configuration
`DevDebug · DevRelease · ProdDebug · ProdRelease` = scheme `BaseApp <config>`. Mỗi config một xcconfig độc lập trong `Configurations/`.

| Biến | Dùng cho | Đọc bằng |
|---|---|---|
| `APP_ENV` (`dev`/`prod`) | môi trường backend | `Environment.name` / `isDev` |
| `APP_BUNDLE_ID`, `APP_DISPLAY_NAME` | định danh app (Dev có hậu tố `.dev`) | build setting |
| `BASE_URL`, `ASSET_BASE_URL` | API / CDN | `Environment.baseURL`, `assetBaseURL` |
| `API_KEY`, `API_BUNDLE_ID` | khoá/ID gửi lên BE | `Environment.apiKey`, `apiBundleID` |

`DEBUG` chỉ có ở `*Debug` (xcconfig `SWIFT_ACTIVE_COMPILATION_CONDITIONS`); Release không log mạng.
Thêm biến: 4 file xcconfig → `Info.plist` → getter trong `Core/Environment.swift`. Không đọc `Bundle.main` rải rác.

## Startup flow
`BaseApp.init` (DI: font → Firebase nếu có plist → `DataAssembly` → router) → `RootView`:
splash (`SplashViewModel`, song song `remoteConfig.refresh()`) → `AppStartupUseCase.nextStep()` →
`policy` (overlay chặn) → `onboarding` (stack root) → `main`. Cờ lưu qua `AppPreferencesRepository` (UserDefaults).
Thêm bước (login gate, force update): thêm case `StartupStep` + rule trong `DefaultAppStartupUseCase` + view ở `RootView`.

## Auth skeleton
`Networking/Auth`: `AuthToken`, `JWTDecoder`, `TokenStore` (`KeychainTokenStore`), `BearerAuthInterceptor`.
Gắn vào `Container.apiClient` khi project có đăng nhập. `Core.DeviceIDProvider` cho đăng nhập ẩn danh.
