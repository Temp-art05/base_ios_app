# CLAUDE.md

Hướng dẫn cho Claude Code trong repo **Base iOS App** (template). iOS 17+, SwiftUI + Swift Concurrency, MVVM, SPM modular.

## Đọc gì khi nào

| Task | Đọc |
|---|---|
| Layer, dependency graph, thêm package/feature | `docs/rules/architecture.md` |
| ViewModel (MVVM), cấu trúc Screens/Components, View | `docs/rules/presentation.md` |
| UseCase | `docs/rules/usecase.md` |
| API, DataSource, Repository, SwiftData | `docs/rules/data-layer.md` |
| Lỗi | `docs/rules/error-handling.md` |
| Token màu/chữ/spacing, accessibility ID | `docs/rules/design-system.md` |
| Network logging | `docs/rules/network-logging.md` |
| Build config, biến môi trường, startup flow, auth skeleton | `docs/rules/config-and-startup.md` |
| Analytics event | `docs/rules/analytics.md` |
| Build config, biến môi trường, startup flow | `docs/rules/config-and-startup.md` |
| Luồng mẫu / thêm API / thêm feature | `docs/guides/*` |
| Đổi tên, brand, cấu hình project mới | `TODO.md` |

## Quy tắc bắt buộc

- **Plan trước, code sau** cho task lớn: `docs/plans/<feature>.md` (đã gitignore). Task nhỏ làm thẳng.
- Layer: `View → ViewModel → UseCase (Domain) → Repository protocol (Domain) ← Repository impl (Data) → DataSource`.
  Domain không import Data/Networking/Storage. Feature package không import Data/Networking/Storage hay feature khác.
- ViewModel: `@MainActor final class XxxViewModel: ObservableObject` (`@Published` state, hàm public cho View gọi),
  dependency chỉ qua `@Injected(\.xUseCase)`. View giữ bằng `@StateObject`. Không chạm repository, không biết navigation (callback).
- UseCase gộp theo năng lực nghiệp vụ, impl ở Domain. Rule nghiệp vụ nằm ở UseCase, không ở ViewModel.
- Lỗi: `APIError → DomainError → userMessage`. Presentation chỉ thấy `DomainError`.
- Mọi request qua `Core.NetworkLogger` (đã làm sẵn trong `URLSessionAPIClient`); không `print` header/body.
- **Không hardcode** màu/font/spacing/radius/size — dùng `AppColor`/`AppFont`/`AppSpacing`/`AppRadius`/`AppSize`.
  Thiếu token → thêm vào `DesignSystem/Foundation` trước.
- Mọi View mới có `.accessibilityIdentifier` (`{screen}_{element}_{type}`), khai trong `AccessibilityID.swift` của package.
- Firebase/SDK ngoài luôn sau interface, phải chạy no-op khi thiếu cấu hình.
- Không commit secret; key prod thật do CI ghi đè biến xcconfig (`API_KEY=...`), trong repo chỉ để placeholder.
- Đổi kiến trúc/luồng ⇒ cập nhật `docs/rules/*` cùng commit.

## Build / test

```bash
xcodebuild -project BaseApp.xcodeproj -scheme "BaseApp DevDebug" -destination 'platform=iOS Simulator,name=iPhone 17' build
cd Packages/<Name> && xcodebuild test -scheme <Name> -destination 'platform=iOS Simulator,name=iPhone 17'
```

4 scheme = 4 build config: `BaseApp DevDebug|DevRelease|ProdDebug|ProdRelease` (xcconfig ở `Configurations/`).
Dự án là `.xcodeproj` (không phải SPM thuần — `swift build` chọn nhầm macOS). Lỗi `No such module` từ SourceKit là nhiễu index; lấy kết quả `xcodebuild`.
