# Thêm feature / màn mới

**Màn trong package có sẵn:** thêm folder `Screens/Foo/` (`FooViewModel`, `FooView`, `Components/`), ID vào `AccessibilityID.swift`,
`Route` case ở `Core/Navigation/Route.swift`, map ở `BaseApp/Navigation/RouteDestination.swift`, push bằng `onPushRoute`.

**Package feature mới (`FeatureFoo`):**
1. Copy `Packages/FeatureMain` → đổi tên (Package.swift, Sources, Tests).
2. Xcode: thêm local package vào project, link library `FeatureFoo` vào target app.
3. Chỉ phụ thuộc Core/Domain/DesignSystem/Analytics.
4. Expose `public` đúng một View gốc + init nhận closure điều hướng.
