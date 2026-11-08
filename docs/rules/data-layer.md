# Data layer

```
Data/
  DataSource/Remote/   XRemoteDataSource (protocol + Impl), DTO/
  DataSource/Local/    XLocalDataSource (protocol + @ModelActor Impl)
  Mapper/              DTO/entity → domain
  Repository/          XRepositoryImpl
  Error/               DomainErrorMapper + mapping { }
  DI/                  DataAssembly
```

- Luồng: DataSource trả DTO/record → Repository map sang domain (qua `Mapper/`) → UseCase.
- Repository và DataSource đều có protocol + impl. DTO/`@Model` không lọt ra ngoài Data (dùng record `Sendable` qua ranh giới actor).
- Bọc lời gọi remote bằng `mapping { }` để lỗi ra ngoài luôn là `DomainError`; lỗi DB ném `DomainError.storage`.
- DB luôn qua `@ModelActor`; schema gộp ở `Storage/DatabaseContainer.schema`.
- Dedup traffic: `Core.SingleFlight` (data động), `CachedOnce`/`KeyedCachedOnce` (fetch-once, invalidate thủ công) đặt ở repository impl.
- Auth: cài `TokenProvider` + `BearerAuthInterceptor` ở `Container.apiClient`.
