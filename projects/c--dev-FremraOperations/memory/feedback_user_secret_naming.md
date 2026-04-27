---
name: User secret naming — UPPERCASE_SNAKE with orgnum prefix for multi-company
description: User-defined secret keys use UPPERCASE_SNAKE_CASE (env-var style); multi-company apps prefix with Norwegian orgnum (e.g., "919638095:TRIPLETEX_SESSION_TOKEN")
type: feedback
originSessionId: c198b0a8-6fb9-4be6-baff-dd1addf9ae87
---
When defining user secret keys that the user controls (API keys, tokens, webhooks), use UPPERCASE_SNAKE_CASE (env-var style), not PascalCase.

For multi-company/multi-tenant apps, prefix with the company's **Norwegian orgnum** (9 digits), colon-separated:
- `919638095:TRIPLETEX_SESSION_TOKEN`
- `919638095:FOLIO_API_KEY`
- `919638095:DISPLAY_NAME` = "Fremra AS"
- `934842901:TRIPLETEX_SESSION_TOKEN`
- `934842901:DISPLAY_NAME` = "Old Friend AS"

**Why:**
- Matches existing FremraOperations convention (`TRIPLETEX_SESSION_TOKEN`, `SLACK_WEBHOOK_URL`, etc. — same names also work as Azure env vars).
- Orgnum is canonical identifier (no ambiguity with display-name spelling/casing).
- All-digit prefix is valid in both user secrets (colon-separated) and Azure App Settings (becomes `919638095__TRIPLETEX_SESSION_TOKEN` as env var on Linux; .NET reads it fine).
- Avoids spaces in display names (e.g., "Old Friend") which break POSIX env var names.
- Display name stored as its own key under the orgnum, so the UI/app can show "Old Friend AS" even though the config path uses the number.

**How to apply:**
- New user-defined secret keys → UPPERCASE_SNAKE_CASE.
- Framework-reserved keys (`ConnectionStrings:*`, `Authentication:Google:ClientSecret`) keep their standard casing.
- Multi-company → `{orgnum}:KEY_NAME` where orgnum is the 9-digit Norwegian organization number.
- The user corrected this explicitly when I first proposed PascalCase (`Tripletex:Companies:fremra:SessionToken`) and then again picked orgnum over display-name prefix for Azure compatibility.
