# Checklist tạo project mới từ base

## 1. Đổi định danh
- [ ] Đổi tên project/target/scheme `BaseApp` → tên app (Xcode: Rename project; đổi thư mục `BaseApp/`, 4 file `.xcscheme`)
- [ ] 4 file `Configurations/{Dev,Prod}{Debug,Release}.xcconfig` → `APP_BUNDLE_ID`, `APP_DISPLAY_NAME` (hiện `com.base.app.dev` / `com.base.app`)
- [ ] `MARKETING_VERSION` / `CURRENT_PROJECT_VERSION`: target settings trong Xcode
- [ ] Xcode → Signing & Capabilities: chọn Team (project không commit `DEVELOPMENT_TEAM`)
- [ ] App icon: `BaseApp/Assets.xcassets/AppIcon.appiconset` (đang là placeholder trơn) + `SplashView`
- [ ] `Core/Logger.swift`: fallback subsystem `com.base.app`

## 2. Brand
- [ ] `DesignSystem/Foundation/AppColor.swift` → thang `AppPrimary` (placeholder indigo, giữ tên p50…p950) và `AppColor`
- [ ] Font Outfit trong `DesignSystem/Resources/` — đổi thì sửa `DesignSystem.swift` (danh sách file) và `AppFont.family`
- [ ] `BaseApp/Assets.xcassets/AccentColor`

## 3. API
- [ ] `BASE_URL`, `ASSET_BASE_URL`, `API_KEY`, `API_BUNDLE_ID` trong 4 file xcconfig (hiện `dummyjson.com` + placeholder)
- [ ] Body lỗi của BE: `Networking/APIClient.swift` → `errorMessage(from:)`
- [ ] Mã lỗi nghiệp vụ: thêm case `DomainError` + map trong `Data/Error/DomainErrorMapper.swift`
- [ ] Auth: cài `TokenProvider`, thêm `BearerAuthInterceptor` vào `Container.apiClient` (`Data/DI/DataAssembly.swift`)
- [ ] Mỗi API mới: `docs/guides/new-api.md`

## 4. Firebase (tuỳ chọn)
- [ ] Tạo Firebase project, đăng ký `com.base.app` và `com.base.app.dev`
- [ ] Thêm `GoogleService-Info.plist` vào target `BaseApp` (đang gitignore — muốn commit thì bỏ dòng trong `.gitignore`)
- [ ] Crashlytics: thêm Run Script upload dSYM theo hướng dẫn Firebase
- [ ] Khai Remote Config key ở `Analytics/RemoteConfig/RemoteConfigSource.swift` → `RemoteConfigKey`
- [ ] Push (FCM) chưa có sẵn: thêm `FirebaseMessaging`, capability Push Notifications, AppDelegate adaptor

## 5. Secrets
- [ ] `API_KEY` trong xcconfig đang là placeholder. Key thật của prod: CI ghi đè (`xcodebuild API_KEY=...`), không commit.

## 6. Ngôn ngữ
- [ ] Chuỗi dùng chung ở `DesignSystem/Strings.swift` + `Resources/{en,vi}.lproj`; thêm ngôn ngữ = thêm `<lang>.lproj`. Chuỗi trong `FeatureMain` còn viết thẳng tiếng Anh — chuyển dần sang `Strings`

## 7. Thay phần mẫu
- [ ] `Core/Constants.swift` → `Links` (privacy/terms/support) thật
- [ ] `Onboarding/` (3 trang mẫu) + `Policy/PolicyConsentView` + nội dung `Localizable.strings`
- [ ] Xoá luồng Posts theo `docs/guides/sample-flow.md` (mục "Xoá khi làm project thật")
- [ ] `FeatureMain`: Home / Feature / Profile là màn mẫu — thay bằng màn thật (giữ `MainView` + `AppTab`)

## 8. Nên làm sớm
- [ ] CI (Xcode Cloud/GitHub Actions): build 2 scheme + test từng package; commit lại `Package.resolved` mỗi khi đổi dependency
- [ ] Thay `DatabaseContainer` fallback bằng `VersionedSchema` + migration trước khi release
- [ ] Cân nhắc Swift 6 language mode khi code thật ổn định
