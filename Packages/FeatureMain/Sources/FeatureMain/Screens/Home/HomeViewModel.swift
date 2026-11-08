import Foundation
import Core
import Domain
import Analytics

/// Màn mẫu: danh sách post phân trang + tìm kiếm + bookmark. Đọc `docs/guides/sample-flow.md`.
@MainActor
final class HomeViewModel: ObservableObject {

    enum LoadState: Equatable {
        case idle
        case loading
        case loaded
        case failed(String)
    }

    @Published private(set) var loadState: LoadState = .idle
    @Published private(set) var posts: [Post] = []
    @Published private(set) var hasMore = false
    @Published private(set) var isLoadingMore = false
    /// Thông báo ngắn (lỗi hành động) — View hiển thị toast rồi gọi `dismissToast()`.
    @Published private(set) var toast: String?
    @Published var query: String = "" {
        didSet { guard query != oldValue else { return }; scheduleSearch() }
    }

    @Injected(\.postUseCase) private var useCase
    @Injected(\.analyticsService) private var analytics

    private let debounce: Duration = .milliseconds(350)
    private var loadTask: Task<Void, Never>?
    private var searchTask: Task<Void, Never>?

    deinit {
        loadTask?.cancel()
        searchTask?.cancel()
    }

    // MARK: - Lifecycle

    func onAppear() {
        guard loadState == .idle else { return }
        analytics.log(.screenView("home"))
        reload()
    }

    func refresh() { reload() }
    func retry() { reload() }
    func dismissToast() { toast = nil }

    // MARK: - Actions

    func loadMoreIfNeeded(currentIndex: Int) {
        guard currentIndex >= posts.count - 3 else { return }
        loadMore()
    }

    func toggleBookmark(_ post: Post) {
        Task { [weak self] in
            guard let self else { return }
            do {
                let updated = try await useCase.toggleBookmark(post)
                if let index = posts.firstIndex(where: { $0.id == updated.id }) {
                    posts[index] = updated
                }
                analytics.log(.tap("bookmark", screen: "home"))
            } catch {
                toast = error.userMessage
            }
        }
    }

    // MARK: - Private

    /// Debounce là nhịp UI nên nằm ở ViewModel (rule nghiệp vụ nằm ở UseCase).
    private func scheduleSearch() {
        searchTask?.cancel()
        searchTask = Task { [weak self] in
            try? await Task.sleep(for: self?.debounce ?? .milliseconds(350))
            guard !Task.isCancelled else { return }
            self?.reload()
        }
    }

    private func reload() {
        loadTask?.cancel()
        let query = self.query
        loadState = .loading
        isLoadingMore = false
        loadTask = Task { [weak self] in
            guard let self else { return }
            do {
                let page = try await useCase.loadPage(loaded: 0, query: query)
                guard !Task.isCancelled else { return }
                posts = page.items
                hasMore = page.hasMore
                loadState = .loaded
            } catch is CancellationError {
                return
            } catch {
                guard !Task.isCancelled else { return }
                loadState = .failed(error.userMessage)
            }
        }
    }

    private func loadMore() {
        guard loadState == .loaded, hasMore, !isLoadingMore else { return }
        let query = self.query
        let loaded = posts.count
        isLoadingMore = true
        loadTask = Task { [weak self] in
            guard let self else { return }
            defer { isLoadingMore = false }
            do {
                let page = try await useCase.loadPage(loaded: loaded, query: query)
                guard !Task.isCancelled, query == self.query else { return }
                let known = Set(posts.map(\.id))
                posts += page.items.filter { !known.contains($0.id) }
                hasMore = page.hasMore
            } catch is CancellationError {
                return
            } catch {
                toast = error.userMessage
            }
        }
    }
}
