---
name: Free-tier dev SQL database
description: Local dev hits fremra-operations-db-dev (free tier, auto-pause), not the prod DB; provisioned out-of-band via az CLI on 2026-04-30
type: project
originSessionId: 2c346fda-63de-4efc-abb6-e730c58be485
---
A separate dev database `fremra-operations-db-dev` exists on the same server (`fremra-operations-sql`). Local dev's user-secret `ConnectionStrings:AppDb` now points at it. Prod (`fremra-operations-db`) is untouched.

**Config:** GP serverless `GP_S_Gen5_2`, `useFreeLimit=true`, `freeLimitExhaustionBehavior=AutoPause`, 32 GB, Local backup redundancy. One free Azure SQL DB per subscription — this is it.

**Why:** Removes the migration-desync risk where running dev branch locally would auto-apply migrations to prod and break the deployed app (see `feedback_migrations_desync_prod.md`). Free tier is fine for dev because cold-start delays don't affect prod users.

**How to apply:**
- Don't switch the local connection string back to `fremra-operations-db` for any reason; that re-opens the desync risk.
- First request after idle waits ~30–60s while DB resumes from auto-pause — expected, not a bug.
- The DB was provisioned via `az sql db create`, not Pulumi. Pulumi has substantial drift on this server already — reconciling it (including declaring this dev DB) is tracked as a separate task. Until then, don't run `pulumi up`.

**Re-syncing prod data into dev (BACPAC):**
1. Export: `MSYS_NO_PATHCONV=1 sqlpackage /Action:Export /SourceConnectionString:"...Database=fremra-operations-db;Authentication=Active Directory Default;..." /TargetFile:.tmp/fremra-prod.bacpac /OverwriteFiles:True`
2. Drop schema in dev (sqlpackage Import refuses targets with user objects): a single sqlcmd batch that drops all FKs then all tables. Don't drop the DB itself — that loses the free-tier flag.
3. Import: same sqlpackage call with `/Action:Import` against `Database=fremra-operations-db-dev`.
4. Verify free-tier flag intact via `az sql db show ... --query "{useFreeLimit:useFreeLimit}"`.
- `sqlpackage` is installed as a global dotnet tool (`microsoft.sqlpackage`).
- BACPAC contains all PII; keep it in `.tmp/` (gitignored) or delete after import.
