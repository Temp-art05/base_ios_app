import Foundation

/// Đọc payload JWT (KHÔNG verify chữ ký — chỉ để biết hạn dùng phía client).
public enum JWTDecoder {
    public static func payload(of jwt: String) -> [String: Any]? {
        let parts = jwt.split(separator: ".")
        guard parts.count >= 2 else { return nil }
        var base64 = String(parts[1]).replacingOccurrences(of: "-", with: "+").replacingOccurrences(of: "_", with: "/")
        while base64.count % 4 != 0 { base64 += "=" }
        guard let data = Data(base64Encoded: base64) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data)) as? [String: Any]
    }

    public static func expiration(of jwt: String) -> Date? {
        guard let exp = payload(of: jwt)?["exp"] as? TimeInterval else { return nil }
        return Date(timeIntervalSince1970: exp)
    }
}
