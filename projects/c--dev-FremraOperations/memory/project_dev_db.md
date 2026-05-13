---
name: Dev SQL database
description: Local dev hits fremra-operations-db-dev (free-tier GP serverless) on the same server as prod; prod DB untouched. Free slot is reclaimable.
type: project
originSessionId: 2c346fda-63de-4efc-abb6-e730c58be485
---
A separate dev database `fremra-operations-db-dev` exists on the same server (`fremra-operations-sql`). Local dev's user-secret `ConnectionStrings:AppDb` points at it. Prod (`fremra-operations-db`) is untouched.

**Current config (2026-05-12):** GP serverless `GP_S_Gen5_2`, `useFreeLimit=true`, `freeLimitExhaustionBehavior=AutoPause`, 32 GB, Local backup. First request after idle waits ~30–60s while DB resumes from auto-pause — expected.

**Free-tier slot semantics (verified 2026-05-12):**
The Azure SQL free DB offer is **one free DB per subscription at a time**, NOT one-shot per subscription lifetime. When the existing free DB is dropped, the slot reopens and a new DB can claim `useFreeLimit=true`. `az sql db copy` does **not** carry over `useFreeLimit` — the destination always lands on the source's billable SKU. So copy-based refresh of dev burns the free flag; only sqlpackage-based refresh (which keeps the DB shell intact) or drop-and-recreate-with-`--use-free-limit` preserves it.

**Why dev exists at all:** Removes the migration-desync risk where running a dev branch locally would auto-apply migrations to prod and break the deployed app (see `feedback_migrations_desync_prod.md`).

**How to apply:**
- Don't switch the local connection string back to `fremra-operations-db` for any reason; that re-opens the desync risk.
- The DB was provisioned via `az sql db create`, not Pulumi. Pulumi has substantial drift on this server already — reconciling it (including declaring this dev DB) is tracked as a separate task. Until then, don't run `pulumi up`.

**Re-syncing prod data into dev — two paths:**

*A. Drop + create + sqlpackage (preserves free-tier flag):*
1. `az sql db delete --resource-group fremra-operations-rg --server fremra-operations-sql --name fremra-operations-db-dev --yes`
2. `az sql db create --resource-group fremra-operations-rg --server fremra-operations-sql --name fremra-operations-db-dev --tier GeneralPurpose --family Gen5 --capacity 2 --compute-model Serverless --max-size 32GB --use-free-limit --free-limit-exhaustion-behavior AutoPause --backup-storage-redundancy Local`
3. Export prod: `MSYS_NO_PATHCONV=1 sqlpackage /Action:Export /SourceConnectionString:"Server=fremra-operations-sql.database.windows.net;Database=fremra-operations-db;Authentication=Active Directory Default;" /TargetFile:.tmp/fremra-prod.bacpac /OverwriteFiles:True`
4. Import: `MSYS_NO_PATHCONV=1 sqlpackage /Action:Import /SourceFile:.tmp/fremra-prod.bacpac /TargetConnectionString:"Server=fremra-operations-sql.database.windows.net;Database=fremra-operations-db-dev;Authentication=Active Directory Default;"`
5. Verify: `az sql db show ... --query "{useFreeLimit:useFreeLimit}"` returns `true`.
6. Delete bacpac (PII).

*B. In-place sqlpackage (no DB drop, keeps free flag without any risk):*
1. Export prod (same as A.3).
2. Drop schema in dev (sqlpackage Import refuses targets with user objects): a single sqlcmd batch that drops all FKs then all tables. Don't drop the DB itself.
3. Import (same as A.4).

`sqlpackage` is installed as a global dotnet tool (`microsoft.sqlpackage`). BACPAC contains all PII; keep it in `.tmp/` (gitignored) or delete after import.
