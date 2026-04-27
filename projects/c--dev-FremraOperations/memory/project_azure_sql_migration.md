---
name: Azure SQL migration
description: Database migrated from SQLite to Azure SQL — don't reference SQLite as the database
type: project
---

Database has been migrated from SQLite to Azure SQL Database (commit e2b209d).

**Why:** Production infrastructure change — SQLite replaced with Azure SQL.

**How to apply:** Never refer to "SQLite" when describing the database layer. AppDbContext and EF Core are still used, but the backing store is Azure SQL. CLAUDE.md may still reference SQLite — trust this memory over stale docs.
