import Foundation

// MARK: - SingleFlight
// Collapses CONCURRENT calls into ONE in-flight execution: callers that arrive while a run is in
// progress await the SAME result instead of each firing their own request. It does NOT cache across
// time — once the run finishes, the next call starts fresh. Use for DYNAMIC data where every call
// must reach the network, but simultaneous duplicates (e.g. several refresh triggers — auth flip +
// connectivity restore + pull-to-refresh — firing at once) should be deduped. No TTL by design.
public actor SingleFlight<Value: Sendable> {
    private var inFlight: Task<Value, Error>?

    public init() {}

    public func run(_ operation: @Sendable @escaping () async throws -> Value) async throws -> Value {
        if let inFlight { return try await inFlight.value }
        let task = Task { try await operation() }
        inFlight = task
        defer { inFlight = nil }
        return try await task.value
    }
}

// MARK: - CachedOnce
// Fetch-once memoization with NO time-based expiry. The first call runs `fetch` and keeps the result
// for the lifetime of the process (or until `invalidate()`); later calls return the cached value
// without touching the network. Concurrent first-callers are collapsed (single-flight) so a launch
// burst triggers ONE fetch. Use for NEAR-STATIC data (the BE config snapshot, the /auth/me identity)
// that only changes on an explicit event (login/logout, a manual refresh) — call `invalidate()` on
// that event, or pass `force: true` to bypass the cache for one call. No TTL by design.
public actor CachedOnce<Value: Sendable> {
    private var cached: Value?
    private var inFlight: Task<Value, Error>?

    public init() {}

    public func value(
        force: Bool = false,
        fetch: @Sendable @escaping () async throws -> Value
    ) async throws -> Value {
        if !force, let cached { return cached }
        if let inFlight { return try await inFlight.value }   // collapse a concurrent first-fetch
        let task = Task { try await fetch() }
        inFlight = task
        defer { inFlight = nil }
        let value = try await task.value
        cached = value   // cache only on success; a thrown error leaves the slot empty so we retry
        return value
    }

    public func invalidate() { cached = nil }
}

// MARK: - KeyedCachedOnce
// Per-key variant of `CachedOnce`: memoizes a value for each distinct key (e.g. avatar styles per
// gender), with the same fetch-once / single-flight / no-TTL semantics. `invalidate(nil)` clears
// every key; `invalidate(key)` clears one.
public actor KeyedCachedOnce<Key: Hashable & Sendable, Value: Sendable> {
    private var cached: [Key: Value] = [:]
    private var inFlight: [Key: Task<Value, Error>] = [:]

    public init() {}

    public func value(
        _ key: Key,
        force: Bool = false,
        fetch: @Sendable @escaping () async throws -> Value
    ) async throws -> Value {
        if !force, let value = cached[key] { return value }
        if let task = inFlight[key] { return try await task.value }
        let task = Task { try await fetch() }
        inFlight[key] = task
        defer { inFlight[key] = nil }
        let value = try await task.value
        cached[key] = value
        return value
    }

    public func invalidate(_ key: Key? = nil) {
        if let key { cached[key] = nil } else { cached.removeAll() }
    }
}
