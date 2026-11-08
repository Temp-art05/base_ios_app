# Network logging

Mọi request internet phải log qua `Core.NetworkLogger` (`logRequest`/`logResponse`/`logError`; stream: `logStream*`).
`URLSessionAPIClient` đã làm sẵn — dùng `APIClient`, không tạo `URLSession` riêng. Không `print` header/body.

- Chỉ phát log trong `#if DEBUG`; Release không log gì.
- Header/body nhạy cảm (Authorization, token, password…) được mask; thêm key mới vào `sensitiveHeaders`/`sensitiveBodyKeys`.
- `NetworkLogger.unmaskSecrets = true` (DEBUG) để copy cURL chạy được.
