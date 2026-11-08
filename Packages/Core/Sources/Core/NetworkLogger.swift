import Foundation

// MARK: - NetworkLogger
// Centralized logging for ALL outgoing internet requests (cURL + response).
//
// SECURITY RULE — archive-safe:
//   • Emission is compiled out entirely in non-DEBUG builds (`#if DEBUG`), so a
//     Release/Archive (App Store / TestFlight) build logs NOTHING about network
//     traffic — no URLs, headers, bodies, or responses can leak.
//   • Even in DEBUG, sensitive header values (Authorization, signatures, api keys,
//     cookies…) and sensitive JSON body keys (tokens, passwords, secrets…) are
//     masked, so shared debug logs / screenshots never expose credentials.
//
// Usage: call `NetworkLogger.logRequest(_:)` right before sending and
// `NetworkLogger.logResponse(_:data:for:)` (or `logError`) when it returns.

public enum NetworkLogger {

    /// Header names whose values must never be printed (compared case-insensitively).
    private static let sensitiveHeaders: Set<String> = [
        "authorization",
        "x-api-key",
        "x-api-token",
        "x-device-id",
        "cookie",
        "set-cookie",
        "proxy-authorization"
    ]

    /// JSON body keys whose values must be masked (compared case-insensitively).
    private static let sensitiveBodyKeys: Set<String> = [
        "accesstoken", "refreshtoken", "token", "idtoken",
        "apikey", "api_key", "password", "secret", "signature", "authorization"
    ]

    private static let redacted = "***REDACTED***"
    private static let maxBodyChars = 4000

    /// DEBUG-only escape hatch: when `true`, sensitive header/body values are printed UNMASKED so the
    /// logged cURL is runnable (paste straight into Postman / a terminal). Default `false` — keep
    /// secrets masked so shared debug logs / screenshots never leak credentials. Has NO effect in
    /// Release (all emission is compiled out). Flip it from the app's DEBUG startup.
    public static var unmaskSecrets = false

    // MARK: - Public API

    /// Log an outgoing request as a copy-pasteable cURL command on a SINGLE line (sensitive values
    /// masked). One line so filtering the console by "curl" surfaces the whole command, not just
    /// the first row.
    public static func logRequest(_ request: URLRequest, category: String? = nil) {
        #if DEBUG
        let method = request.httpMethod ?? "GET"
        let url = request.url?.absoluteString ?? "<no url>"
        let corr = correlation(request)
        let tag = category.map { " [\($0)]" } ?? ""

        var lines = ["curl -X \(method)"]
        for (key, value) in (request.allHTTPHeaderFields ?? [:]).sorted(by: { $0.key < $1.key }) {
            lines.append("-H \"\(key): \(shouldMask(headerKey: key) ? redacted : value)\"")
        }
        if let body = request.httpBody, !body.isEmpty {
            lines.append(isBinaryUpload(request)
                ? "--data-binary @<file>   # \(body.count) bytes"
                : "--data '\(shellSingleQuoteEscaped(maskedBody(body, pretty: false)))'")
        }
        lines.append("\"\(url)\"")
        let curl = lines.joined(separator: " \\\n  ")

        Logger.debug("┌─ 🌐\(tag) REQUEST \(corr) ─ \(method) \(url)\n\(curl)", category: "Net")
        #endif
    }

    /// Log a response (correlation + status + headers + masked/truncated body) as a clean block.
    public static func logResponse(_ response: HTTPURLResponse, data: Data, for request: URLRequest? = nil, category: String? = nil) {
        #if DEBUG
        let method = request?.httpMethod ?? ""
        let url = request?.url?.absoluteString ?? response.url?.absoluteString ?? ""
        let icon = (200...299).contains(response.statusCode) ? "✅" : "⚠️"
        let corr = request.map(correlation) ?? ""
        let tag = category.map { " [\($0)]" } ?? ""
        let body = data.isEmpty ? "<empty>" : maskedBody(data)
        Logger.debug("└─ 🌐\(tag) RESPONSE \(corr) ─ \(icon) [\(response.statusCode)] \(method) \(url)\n\(responseHeaders(response))📦 \(body)", category: "Net")
        #endif
    }

    /// Log the opening of an SSE / streaming response.
    public static func logStreamOpen(_ status: Int, for request: URLRequest? = nil) {
        #if DEBUG
        let url = request?.url?.absoluteString ?? ""
        let icon = (200...299).contains(status) ? "✅" : "⚠️"
        log("⬇️ SSE OPEN [\(status)] \(icon) \(url)")
        #endif
    }

    /// Log one streamed line/frame (truncated). Call per `data:` frame.
    public static func logStreamLine(_ line: String) {
        #if DEBUG
        log("⬇️ SSE \(truncate(line))")
        #endif
    }

    /// Log the close of a stream (optionally with a reason: completed / error).
    public static func logStreamClose(_ reason: String = "completed", for request: URLRequest? = nil) {
        #if DEBUG
        log("⬇️ SSE CLOSE (\(reason)) \(request?.url?.absoluteString ?? "")")
        #endif
    }

    /// Log a transport error for a request.
    public static func logError(_ error: Error, for request: URLRequest? = nil, category: String? = nil) {
        #if DEBUG
        let corr = request.map(correlation) ?? ""
        let tag = category.map { "[\($0)] " } ?? ""
        let url = request?.url?.absoluteString ?? ""
        log("❌ \(tag)ERROR \(corr) \(url)\n\(error.localizedDescription)")
        #endif
    }

    // MARK: - Private

    #if DEBUG
    /// Short tag from the request's `correlation-id` (last 6 chars) so a request and its
    /// response can be matched in interleaved async logs. Empty when the header is absent.
    private static func correlation(_ request: URLRequest) -> String {
        guard let id = request.value(forHTTPHeaderField: "correlation-id"), !id.isEmpty else { return "" }
        return "[#\(String(id.suffix(6)))]"
    }

    /// Make a string safe inside a shell single-quoted literal (`'...'`). A literal `'` cannot
    /// appear between single quotes, so each one is rewritten as `'\''` (close quote, an escaped
    /// quote, reopen quote) — keeps the emitted cURL copy-pasteable when the body contains `'`.
    private static func shellSingleQuoteEscaped(_ value: String) -> String {
        value.replacingOccurrences(of: "'", with: "'\\''")
    }

    /// True when the request body is raw bytes we shouldn't dump (e.g. an image upload PUT).
    private static func isBinaryUpload(_ request: URLRequest) -> Bool {
        let ct = (request.value(forHTTPHeaderField: "Content-Type") ?? "").lowercased()
        return ct.hasPrefix("image/") || ct.contains("octet-stream") || ct.contains("multipart/")
    }

    /// Response headers as masked `key: value` lines (sensitive values redacted), trailing newline.
    private static func responseHeaders(_ response: HTTPURLResponse) -> String {
        let pairs = response.allHeaderFields
            .map { (String(describing: $0.key), String(describing: $0.value)) }
            .sorted { $0.0.lowercased() < $1.0.lowercased() }
        guard !pairs.isEmpty else { return "" }
        let lines = pairs.map { key, value in
            "  \(key): \(shouldMask(headerKey: key) ? redacted : value)"
        }
        return lines.joined(separator: "\n") + "\n"
    }

    private static func log(_ message: String) {
        Logger.debug("🌐 \(message)", category: "Net")
    }

    private static func isSensitiveHeader(_ name: String) -> Bool {
        sensitiveHeaders.contains(name.lowercased())
    }

    /// Whether a header/body value must be redacted — sensitive AND the unmask escape hatch is off.
    private static func shouldMask(headerKey: String) -> Bool {
        !unmaskSecrets && isSensitiveHeader(headerKey)
    }

    /// Mask sensitive keys inside a JSON body; fall back to a truncated raw string.
    /// `pretty == false` → compact single-line (for the cURL request body).
    private static func maskedBody(_ data: Data, pretty: Bool = true) -> String {
        let options: JSONSerialization.WritingOptions = pretty ? [.prettyPrinted, .sortedKeys] : [.sortedKeys]
        if let json = try? JSONSerialization.jsonObject(with: data),
           let masked = mask(json) as Any?,
           let out = try? JSONSerialization.data(withJSONObject: masked, options: options),
           let str = String(data: out, encoding: .utf8) {
            return truncate(str)
        }
        var raw = String(data: data, encoding: .utf8) ?? "<\(data.count) bytes binary>"
        if !pretty { raw = raw.replacingOccurrences(of: "\n", with: " ") }
        return truncate(raw)
    }

    /// Recursively mask sensitive keys in a decoded JSON structure.
    private static func mask(_ value: Any) -> Any {
        if unmaskSecrets { return value }
        if let dict = value as? [String: Any] {
            var result: [String: Any] = [:]
            for (key, val) in dict {
                result[key] = sensitiveBodyKeys.contains(key.lowercased()) ? redacted : mask(val)
            }
            return result
        }
        if let array = value as? [Any] {
            return array.map { mask($0) }
        }
        return value
    }

    private static func truncate(_ s: String) -> String {
        s.count > maxBodyChars ? String(s.prefix(maxBodyChars)) + "… (truncated)" : s
    }
    #endif
}
