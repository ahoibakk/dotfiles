---
name: feedback_ef_migrations_remove_concurrent
description: "Never run `ef migrations remove` blind — it deletes the LAST migration, which may be a coworker's untracked WIP, not yours"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 66af74b4-eaed-41a3-8943-e3e1468479bb
---

`dotnet ef migrations remove` deletes the **last** migration by model order, NOT the one you just added. In this repo the user often has a *different project's* uncommitted work in the same tree (e.g. an untracked `AddPrognosisScenarios` migration). I ran `migrations remove` to undo my own empty migration and it deleted **their** untracked migration files instead — unrecoverable via git because they were never committed.

**Why:** the empty migration I wanted to undo was caused by EF *tools* being a major version behind the *runtime* (9.0.2 tool vs 10.0.7 runtime) — the diff engine silently produced an empty `Up()` while still writing the snapshot. The real fix was `dotnet tool update --global dotnet-ef --version "10.*"`, not removing anything.

**How to apply:**
- If `migrations add` yields an empty `Up()`/`Down()`, suspect a **tool/runtime version skew** first. Update `dotnet-ef` to match the runtime, delete the empty migration *files by hand* (they're yours and untracked), and re-add.
- Before EVER running `migrations remove`: confirm the last migration is actually yours. `git ls-files --others --exclude-standard FremraOperations.Web/Migrations/` shows untracked (coworker WIP) migrations — if any exist, do NOT remove; delete your own files manually instead.
- To split two new entities into separate migrations, temporarily drop one from the model: comment out its `DbSet` + `modelBuilder.Entity<T>()` and point feature code at `db.Set<T>()` so it still compiles, generate the first migration, then restore and generate the second.
- Check `__EFMigrationsHistory` in the dev DB (`sqlcmd ... ActiveDirectoryDefault`) to know what's actually applied before worrying about timestamps — if a migration was never applied, regenerating it with a fresh ID is harmless. See [[feedback_no_regenerate_applied_migration]] and [[feedback_no_dotnet_tool_probe]].
