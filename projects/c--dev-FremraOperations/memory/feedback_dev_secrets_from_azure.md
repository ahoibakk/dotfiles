---
name: feedback_dev_secrets_from_azure
description: "Don't generate random values for missing dev secrets that are mirrored from Azure (e.g. SHARED_PASSWORDS_ENCRYPTION_KEY); pull the real value"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 37014a4e-c96c-4644-a9b6-0b44170790f8
---

When a local dev user-secret is missing (e.g. `SHARED_PASSWORDS_ENCRYPTION_KEY` causing a 500), do NOT generate a fresh random value. `scripts/setup-dev-env.sh` mirrors the real values from Azure App Service into user-secrets — run it (idempotent), or pull the single key with `az webapp config appsettings list`.

**Why:** The dev DB shares the SQL server and is typically seeded from prod, so existing rows are encrypted under the *prod* key. A random key makes pages render but reveal/decrypt fails on every existing row, and key rotation isn't supported. The value must match prod.

**How to apply:** Missing dev secret → check `scripts/setup-dev-env.sh`'s `SECRET_KEYS` allowlist first; if it's there, the canonical source is Azure, not a generated value. Only generate when the secret is genuinely local-only and not in that list.
