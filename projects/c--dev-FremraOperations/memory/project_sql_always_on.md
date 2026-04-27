---
name: SQL DB always-on (no auto-pause)
description: Azure SQL serverless auto-pause is intentionally disabled because cold-start resume causes exceptions in the app
type: project
originSessionId: 540c4774-5ab5-4bf9-9e82-b61309ae8f42
---
SQL DB `fremra-operations-db` runs with `autoPauseDelay: -1` (auto-pause disabled) intentionally.

**Why:** Cold-start resume on serverless takes ~30-60s, which caused exceptions in the app on the first request after an idle period. Keeping the DB always resumed avoids this.

**How to apply:** Do NOT suggest enabling auto-pause as a cost optimization — it was already tried and rejected. For cost reductions on this DB, instead consider:
- Switching from serverless (`GP_S_Gen5_x`) to a fixed DTU tier like Basic (~5 USD/mo, 2 GB) or Standard S0 (~15 USD/mo, 250 GB) — always-on, predictable price, no cold starts. DB is tiny (~24 MB used) so capacity is not a constraint.
- Lowering max vCores on serverless (e.g. 2 → 1) if staying on that tier.
