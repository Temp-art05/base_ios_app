import Foundation

/// Id thiết bị ổn định (UUID lưu Keychain, sống qua xoá/cài lại app nếu Keychain còn).
/// Dùng cho đăng nhập ẩn danh / header `x-device-id`.
public enum DeviceIDProvider {
    private static let key = "device_id"

    public static var current: String {
        let keychain = KeychainHelper()
        if let existing = keychain.readString(key) { return existing }
        let id = UUID().uuidString
        keychain.writeString(id, for: key)
        return id
    }
}
