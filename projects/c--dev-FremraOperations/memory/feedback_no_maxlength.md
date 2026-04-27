---
name: No HasMaxLength on EF Core string properties
description: Never add HasMaxLength constraints to EF Core fluent config — use nvarchar(max) by default
type: feedback
---

Do NOT add `HasMaxLength()` to string properties in EF Core fluent configuration. All string columns should be `nvarchar(max)` (the EF Core default for SQL Server).

**Why:** User previously ran a migration specifically to remove max length constraints (`AddCustomerNameAndRemoveMaxLengths`). Adding them back triggered a strong correction. The project intentionally avoids artificial string length limits.

**How to apply:** When configuring entities in `AppDbContext.OnModelCreating`, only use `.IsRequired()` for non-nullable strings. Never add `.HasMaxLength()`. If you see existing `HasMaxLength` in the DbContext, that's legacy — don't propagate the pattern to new entities.
