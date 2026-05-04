---
name: Don't apply dev migrations to prod DB before main is deployed
description: Running the dev branch locally against the prod Azure SQL DB auto-applies new migrations on startup, desyncing schema vs the deployed (main) code and crashing prod
type: feedback
originSessionId: d25d332e-c914-41d5-86ea-ef705116d080
---
When `dev` has new EF migrations that haven't been released to `main` yet, do not run the local dev app against the prod connection string. Migrations auto-apply on startup, so the prod DB jumps ahead of the deployed code and any page that reads the affected table 500s.

**Why:** This actually happened on 2026-04-27. Dev migrations had dropped `PlatformRequests.Scope` and added `WorkloadPercent`/`ExtensionMonths`/`SourceUrl`/`IsContinuation`. The prod DB had all of these but `main` still mapped `Scope`, so EF threw on every PlatformRequests query. `/Activities` and `/Requests` were both dead until we fast-forwarded `main` to `dev` and redeployed.

**How to apply:**
- Before the user runs the dev app locally, if I just added a migration that drops or renames a column, warn them: "this migration will fire against whatever DB your local connection string points at — if that's prod, deployed `main` will crash on the dropped column."
- Safest release order when a migration is destructive: ship `dev` → `main` first (so prod code already matches the new schema), then let migrations apply.
- If the user reports a sudden "production dead" on a page that reads a recently-migrated table, check `git diff main..dev -- Migrations/` and `INFORMATION_SCHEMA.COLUMNS` against the prod DB before chasing other causes.
