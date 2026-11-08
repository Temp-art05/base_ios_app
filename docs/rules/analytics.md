# Analytics

- Mọi event khai trong `Analytics/AnalyticsEvents.swift` (một catalog duy nhất); call-site chỉ `analytics.log(.xxx)`.
- Đặt tên `snake_case`, ≤ 40 ký tự, KHÔNG trùng Firebase reserved (`first_open`, `screen_view`, `session_start`, `app_open`…).
- ViewModel inject `@Injected(\.analyticsService)`. SDK mới = thêm `AnalyticsPlugin`, không sửa call-site.
- Thiếu `GoogleService-Info.plist` → chỉ plugin Console (DEBUG) chạy; không crash.
- `screen_view`: `.screenView("<tên>")` ở `onAppear` của màn / `MainViewModel.switchTab`.
