# Thêm một API

1. **DTO** (`Data/DataSource/Remote/DTO/XDTO.swift`, `Decodable`) — internal.
2. **RemoteDataSource**: protocol + Impl dùng `Endpoint` + `APIClient` (`Data/DataSource/Remote/`).
3. **Domain model** + **Repository protocol** (`Domain/Model`, `Domain/Repository`).
4. **Mapper** (`Data/Mapper/XMapper.swift`) DTO → model.
5. **RepositoryImpl** (`Data/Repository`), bọc remote bằng `mapping { }`.
6. **UseCase** gộp theo nghiệp vụ (`Domain/UseCase`) — rule nằm ở đây.
7. **DI**: slot + factory ở `Container+Domain.swift`, register impl ở `DataAssembly.registerAll()`.
8. **ViewModel/View** dùng `@Injected(\.xUseCase)`.
9. Test: Mapper, UseCase (stub repository), ViewModel (stub UseCase).

Mã lỗi nghiệp vụ riêng → `docs/rules/error-handling.md`.
