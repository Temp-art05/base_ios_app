# Luồng mẫu: Posts

```
HomeView → HomeViewModel (hàm public)
  → PostUseCase.loadPage(loaded:query:)            Domain/UseCase/PostUseCase.swift
  → PostRepository (protocol)                      Domain/Repository
  → PostRepositoryImpl                             Data/Repository
      ├ PostRemoteDataSource → APIClient (dummyjson) Data/DataSource/Remote
      └ BookmarkLocalDataSource (@ModelActor)        Data/DataSource/Local → Storage.BookmarkEntity
  Mapper: PostDTO/BookmarkRecord → Post             Data/Mapper/PostMapper.swift
```

Có sẵn: phân trang (`Page.hasMore`), tìm kiếm debounce 350ms, bookmark (SwiftData), lỗi (`ErrorStateView`/toast), test
ở `Domain`, `Data`, `FeatureMain`.

## Xoá khi làm project thật
1. `FeatureMain`: `Screens/Home/`, `Screens/PostDetail/`, bookmark list trong `Screens/Profile/`, ID tương ứng trong `AccessibilityID.swift`; `Route.postDetail`.
2. `Domain`: `Model/Post.swift`, `Repository/PostRepository.swift`, `UseCase/PostUseCase.swift`, slot/factory trong `Container+Domain.swift`, test.
3. `Data`: `PostDTO`, `PostRemoteDataSource`, `BookmarkLocalDataSource`, `PostMapper`, `PostRepositoryImpl`, đăng ký trong `DataAssembly`, test.
4. `Storage`: `BookmarkEntity` + bỏ khỏi `DatabaseContainer.schema`.
5. `RouteDestination` + `BASE_URL`.
