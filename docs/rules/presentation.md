# Presentation (MVVM)

Cấu trúc package feature (theo `FeatureMain`):

```
FeatureMain/Sources/FeatureMain/
  AccessibilityID.swift
  AppTab.swift · MainView.swift · MainViewModel.swift      shell tab (state tab ở MainViewModel)
  Components/                                              view dùng chung trong feature
  Screens/<Màn>/<Màn>View.swift, <Màn>ViewModel.swift, Components/   mỗi màn một folder
  Shared/                                                  model/store dùng chung nhiều màn
```

```swift
@MainActor
final class FooViewModel: ObservableObject {
    enum LoadState: Equatable { case idle, loading, loaded, failed(String) }

    @Published private(set) var loadState: LoadState = .idle
    @Published var query = "" { didSet { ... } }          // binding hai chiều với View

    @Injected(\.fooUseCase) private var useCase

    func onAppear() { ... }                                // View gọi hàm trực tiếp
    func retry() { ... }
}

struct FooView: View {
    @StateObject private var viewModel = FooViewModel()
    let onOpenBar: (Int) -> Void                           // điều hướng = callback
}
```

- `@Published private(set)` cho state; chỉ field cần binding ngược mới để `var` công khai.
- ViewModel chỉ: map state, debounce/animation, analytics, quản lý `Task` (hủy ở `deinit`/khi tạo lượt mới).
  Rule nghiệp vụ ở UseCase.
- Không fetch trong `init`; View `.onAppear { viewModel.onAppear() }`, VM tự chống gọi lặp.
- Bỏ kết quả nếu `Task.isCancelled` hoặc query đã đổi. `CancellationError` không hiện lỗi.
- Lỗi cả màn → `loadState = .failed(error.userMessage)` + `ErrorStateView`; lỗi hành động nhỏ → `@Published toast`.
- Không biết navigation: View nhận closure (`onPushRoute`, `onBack`…); đổi tab qua `NavigationRouter.switchTab` (Notification `.switchTab`).
- Mỗi View có accessibility ID; component dùng chung có `#Preview`.
- Test ViewModel: `Container.shared.xUseCase.register { stub }` rồi tạo VM.
