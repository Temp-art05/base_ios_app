# Design System & Accessibility

**Không hardcode** hex, `Font.custom`/`.system(size:)`, magic number spacing/radius/size trong View.

- Màu → `AppColor` (+ `AppPrimary` thang brand) · Chữ → `.textStyle(.body)` (`AppFont`) · Khoảng cách → `AppSpacing`
  · Bo góc → `AppRadius` · Kích thước → `AppSize` · Opacity/animation → `AppOpacity`/`AppAnimation`.
- Thiếu token → bổ sung vào `DesignSystem/Foundation` TRƯỚC rồi mới dùng.
- Component dùng chung: `PrimaryButton`, `LoadingStateView`, `ErrorStateView`, `EmptyStateView`, `AppAsyncImage`.
- Theme: `AppAppearance` (system/light/dark) lưu `@AppStorage`, áp ở `BaseApp` bằng `.preferredColorScheme`.

## Accessibility identifier

Mọi View mới có `.accessibilityIdentifier(...)`, `snake_case` dạng `{screen}_{element}_{type}`
(vd `home_bookmark_button`). Mỗi package có `AccessibilityID.swift` (enum lồng theo màn, `static let`).

- Strategy A (interactive): nhận `accessibilityID` ở `init` với default từ `AccessibilityID`.
- Strategy B (container/display): gán thẳng vào outermost view trong `body`.
- Đặt SAU `.background()`/`.buttonStyle(.plain)`, TRƯỚC `.task`/`.sheet`.
- List động: `"\(AccessibilityID.Home.postRow)_\(index)"`.
