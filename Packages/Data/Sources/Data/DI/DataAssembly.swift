import Foundation
import SwiftData
import Core
import Domain
import Networking
import Storage

/// Đăng ký impl của Data/Storage vào slot Domain. Gọi MỘT lần ở `BaseApp.init` (trước khi dựng UI).
public enum DataAssembly {
    public static func registerAll(container: Container = .shared) {
        container.appPreferencesRepository.register { AppPreferencesRepositoryImpl() }
        container.postRepository.register {
            PostRepositoryImpl(
                remote: PostRemoteDataSourceImpl(client: container.apiClient()),
                local: BookmarkLocalDataSourceImpl(modelContainer: DatabaseContainer.shared)
            )
        }
    }
}

extension Container {
    /// Một `APIClient` dùng chung. Thêm interceptor (Bearer…) ở `DataAssembly` khi project có auth.
    var apiClient: Factory<APIClient> {
        self {
            URLSessionAPIClient(baseURL: URL(string: Environment.baseURL) ?? URL(string: "https://dummyjson.com")!)
        }.singleton
    }
}
