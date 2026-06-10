---
name: re-seed-dev-db-from-prod-az-bacpac-free-tier-preserved
description: Exact az/sqlpackage steps to copy prod→dev while keeping the free-tier limit flag
metadata: 
  node_type: memory
  type: reference
  originSessionId: a45ef0a2-b93f-4a3c-be4c-d71176a5cc57
---

Re-seeding `fremra-operations-db-dev` from prod while keeping the **free-tier** (free-limit) flag.

Key fact: `--use-free-limit` is **CREATE-time only**. `az sql db update --use-free-limit` and `az sql db copy` both fail with `ProvisioningDisabled: Cannot update paid database to free database`. `az sql db copy` also forces the dest to match the source edition (prod is Basic), so copy can NEVER yield a free-tier dev DB. The correct flow:

1. Export prod → local bacpac (prefix `MSYS_NO_PATHCONV=1` — sqlpackage's `/Action:` `/TargetFile:` args get mangled by MSYS otherwise; see [[feedback_msys_path_conv_for_az]]):
   ```
   MSYS_NO_PATHCONV=1 sqlpackage /Action:Export \
     /SourceConnectionString:"Server=tcp:fremra-operations-sql.database.windows.net,1433;Database=fremra-operations-db;Authentication=Active Directory Default;Encrypt=True;" \
     /TargetFile:".tmp/prod-export.bacpac" /OverwriteFiles:True
   ```
2. Drop dev: `az sql db delete -g fremra-operations-rg -s fremra-operations-sql -n fremra-operations-db-dev --yes`
3. Create a fresh **free-limit** empty DB (this is the step that restores free-tier):
   ```
   az sql db create -n fremra-operations-db-dev -s fremra-operations-sql -g fremra-operations-rg \
     --edition GeneralPurpose --family Gen5 --capacity 2 --compute-model Serverless \
     --auto-pause-delay 60 --min-capacity 0.5 \
     --use-free-limit --free-limit-exhaustion-behavior AutoPause --max-size 32GB
   ```
4. Import into the empty DB: `MSYS_NO_PATHCONV=1 sqlpackage /Action:Import /TargetConnectionString:"...Database=fremra-operations-db-dev;Authentication=Active Directory Default;Encrypt=True;" /SourceFile:".tmp/prod-export.bacpac"` (works because the az-created DB is empty).

Verify with a sqlcmd query against dev. `scripts/setup-infra.sh` now carries the free-limit flags + a comment warning against `az sql db copy`. The earlier belief that free-tier was "portal-only, not settable via CLI" was wrong — create-time `--use-free-limit` works. See [[reference_dev_tools]], [[project_dev_db]], [[project_sql_always_on]].
