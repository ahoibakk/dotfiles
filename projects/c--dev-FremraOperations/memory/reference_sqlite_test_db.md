---
name: SQLite is the test database
description: SQLite is intentionally used by the test project; do not remove SQLite branches from AppDbContext or FillRowVersionInterceptor
type: reference
originSessionId: da50c8e5-f7df-44ae-ada3-5a6c383630cb
---
`FremraOperations.Tests` uses SQLite via `Microsoft.EntityFrameworkCore.Sqlite` for in-memory integration tests against `AppDbContext`. The Azure SQL prod database is *not* mocked at the EF level — SQLite is the test substitute.

Wiring:
- `TestWebAppFactory` swaps the registered `AppDbContext` to `UseSqlite("DataSource=:memory:")` (or similar)
- `FillRowVersionInterceptor` and the `isSqlite` branches in `AppDbContext.OnModelCreating` exist because SQLite has no native `rowversion`; the interceptor mimics the behavior

**How to apply:** Do not propose deleting SQLite/`isSqlite` branches in DB-cleanup refactors. They are load-bearing for the test suite. If the project ever switches to Testcontainers-with-SQL-Server or LocalDB, revisit — until then, keep them.
