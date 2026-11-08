# UseCase

Gộp theo **năng lực nghiệp vụ** (`PostUseCase`, `CheckoutUseCase`), không mỗi hàm repository một class.
Protocol (để mock) + `DefaultXxxUseCase` đều ở `Domain/UseCase/`; nhận repository qua init.

- Rule nằm ở UseCase: gate, ngưỡng, kích thước trang, trim/validate, khử trùng lặp, ghép nhiều repo.
- Paging trả `Page<T>(items, hasMore)`; ViewModel không so `count >= pageSize`.
- Remote Config / Analytics: Domain không thấy package Analytics ⇒ ViewModel đọc giá trị rồi truyền vào UseCase.
- Constructor quá nhiều tham số = chưa gộp đúng; cấm struct "Deps" để né.
- ViewModel chỉ được inject thẳng (không qua UseCase): cổng hạ tầng (`AnalyticsService`, `CrashReporter`),
  preference hiển thị của chính màn đó, nguồn cấu hình. Còn lại phải qua UseCase.
- Factory đăng ký ở `Domain/DI/Container+Domain.swift`; `.singleton` chỉ khi UseCase giữ state in-memory có chủ đích (ghi comment).
