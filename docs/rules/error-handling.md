# Lỗi

`APIError` (Networking) → `DomainErrorMapper` (Data) → `DomainError` (Domain) → `error.userMessage` (View).

- Chỉ Data/Networking thấy `APIError`. Presentation chỉ thấy `DomainError`.
- Lỗi nghiệp vụ riêng: thêm case vào `DomainError` + chuỗi trong `errorDescription` + nhánh trong `DomainErrorMapper`.
- `CancellationError` đi xuyên suốt, ViewModel bỏ qua, không hiện lỗi.
- Hiển thị: lỗi cả màn → `ErrorStateView` (có Retry); lỗi hành động nhỏ → `Event.message` (toast).
- Non-fatal cần theo dõi: `CrashReporter.record(error)`.
