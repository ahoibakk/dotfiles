---
name: feedback_no_regenerate_applied_migration
description: "Don't regenerate an EF migration the dev DB already has applied — ID mismatch crashes startup"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 697db6be-1483-4f3f-9b11-aaf8e3cddc8f
---

Regenerating an EF migration (`migrations remove` + `add`) gives it a new timestamp ID. If any
database already has the OLD migration applied (its `__EFMigrationsHistory` row + tables exist),
startup sees the NEW ID as pending and re-runs `CREATE TABLE` → `SqlException: There is already an
object named 'X'`.

**Why:** the budget module's `AddBudgetTables` migration was regenerated across sessions, but the
dev DB still had the old ID applied with the tables present.

**How to apply:** before regenerating a migration, check whether it's applied anywhere
(`SELECT MigrationId FROM __EFMigrationsHistory`). If it is: prefer stacking an additive migration
instead of regenerating; or, if regenerating, drop the affected tables + delete the stale history
row in the dev DB (get go-ahead first — see [[feedback_confirm_destructive_db_ops]]) so the new
migration recreates them cleanly. Prod never had the budget tables, so only dev needed the fix.
Related: [[feedback_migrations_desync_prod]].
