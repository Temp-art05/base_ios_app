import SwiftUI
import Core
import FeatureMain

struct RootView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    @StateObject private var viewModel = RootViewModel()
    @SwiftUI.Environment(\.scenePhase) private var scenePhase

    var body: some View {
        ZStack {
            // Splash che toàn bộ: nội dung (Home…) chỉ dựng sau khi biết bước khởi động tiếp theo.
            if !viewModel.showSplash {
                NavigationStack(path: $coordinator.path) {
                    Group {
                        if viewModel.step == .onboarding {
                            OnboardingFlowView(onFinish: { viewModel.completeOnboarding() })
                        } else {
                            MainView(onPushRoute: { coordinator.push($0) })
                        }
                    }
                    .navigationDestination(for: Route.self) { route in
                        RouteDestination.view(for: route, nav: coordinator)
                    }
                }
                .sheet(item: $coordinator.presentedSheet) { RouteDestination.sheet(for: $0, nav: coordinator) }
                .fullScreenCover(item: $coordinator.presentedFullScreen) { RouteDestination.sheet(for: $0, nav: coordinator) }
                .transition(.opacity)
            }

            if viewModel.showSplash {
                SplashView()
                    .transition(.opacity)
                    .zIndex(1)
            }

            // Policy nằm trên cùng, chặn tương tác tới khi đồng ý.
            if !viewModel.showSplash, viewModel.step == .policy {
                PolicyConsentView(onAgree: { viewModel.acceptPolicy() })
                    .transition(.opacity)
                    .zIndex(2)
            }
        }
        .animation(.easeOut(duration: 0.25), value: viewModel.showSplash)
        .task { await viewModel.start() }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active { viewModel.appDidBecomeActive() }
        }
        .accessibilityIdentifier(AccessibilityID.Root.container)
    }
}

extension Route: Identifiable {
    public var id: Int { hashValue }
}
