---
name: project_ef_execution_strategy
description: AppDbContext uses EnableRetryOnFailure — manual transactions must be wrapped in CreateExecutionStrategy
metadata: 
  node_type: memory
  type: project
  originSessionId: 3e0d0a78-7420-4dab-90df-c5b6ed442ca5
---

`AppDbContext` is configured with `EnableRetryOnFailure()` (transient Azure SQL retries). Any code that calls `db.Database.BeginTransactionAsync()` directly throws at runtime: *"The configured execution strategy 'SqlServerRetryingExecutionStrategy' does not support user-initiated transactions."*

**How to apply:** wrap the whole transaction body in an execution strategy:

```csharp
var strategy = db.Database.CreateExecutionStrategy();
await strategy.ExecuteAsync(async () =>
{
    await using var tx = await db.Database.BeginTransactionAsync();
    // ... work ...
    await db.SaveChangesAsync();
    await tx.CommitAsync();
});
```

Reference pattern: `ShareTransactionService.cs`. This bit both `ContactService.MergeAsync` and `CompanyService.MergeAsync` (fixed 2026-05-18). Unit tests run on SQLite, whose non-retrying strategy tolerates raw transactions — so this class of bug only surfaces against Azure SQL / in a browser, not in `dotnet test`.
