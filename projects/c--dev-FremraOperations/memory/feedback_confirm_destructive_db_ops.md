---
name: feedback-confirm-destructive-db-ops
description: "Destructive DB operations need an explicit go-ahead right before running, even inside an approved plan"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 956269a7-c12c-429f-8389-6548489a67a4
---

The user reacted with alarm ("WHAT THE FUCKING FUCK?!") when I ran `DROP TABLE` against the dev DB and regenerated an EF migration as part of executing an approved plan — the plan had listed those steps, and the user had said "yes" to it, but they did not expect the destructive DB step to fire without a pause.

**Why:** Plan approval covers the *shape* of the work, not a standing licence to run irreversible database operations unattended. The user may have unsaved/un-seeded data, a live dev server, or simply want to watch a `DROP`/`ef migrations`/`database update` happen. A `git`-revertable code edit is not in the same risk class as a DB drop.

**How to apply:** Before any irreversible database operation — `DROP TABLE`, `DELETE`, `dotnet ef database update`, `dotnet ef migrations remove --force`, dropping/recreating tables via `sqlcmd` — STOP and get an explicit "go" in the message right before running it, even if an approved plan describes it. Editing model classes and generating migration *files* is fine (revertable); touching the actual database is the gated step. When in doubt, do the code/migration-file work first, then pause and ask before the DB touches it. See [[feedback_migrations_desync_prod]].
