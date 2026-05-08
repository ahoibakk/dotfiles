---
name: sqlcmd location + Azure SQL query pattern
description: How to query the production Azure SQL database directly from this repo
type: reference
originSessionId: 4e499e48-0d58-42db-a1ce-81fe84adc41a
---
`sqlcmd` (Go-based v1.9, installed via `winget install Microsoft.Sqlcmd`) is on the user's PATH as of 2026-04-24. Just call `sqlcmd` — no absolute path. Using the full path `C:\Program Files\sqlcmd\sqlcmd.exe` causes a permission prompt every invocation (doesn't match the `Bash(sqlcmd*)` pattern in `.claude/settings.json`).

If Claude Code's bash subprocess was started before the PATH update and can't find `sqlcmd`, restart Claude Code rather than falling back to the full path.

Azure SQL connection (from `CLAUDE.md`):
- Server: `fremra-operations-sql.database.windows.net`
- DB: `fremra-operations-db`
- Auth: `--authentication-method ActiveDirectoryDefault` (uses logged-in Azure identity — no password needed)

Standard invocation:

```bash
sqlcmd -S fremra-operations-sql.database.windows.net \
       -d fremra-operations-db \
       --authentication-method ActiveDirectoryDefault \
       -i query.sql -W -s "|"
```

Gotcha: bash interprets `$` in inline `-Q` queries. Put SQL in a file (`-i`) to avoid escape hell. Scratch queries go in `.tmp/` (gitignored).

For the `PlatformRequests.RawJson` column: Flextribe payloads have `files` at the JSON root, not under `$.data`. Use:

```sql
CROSS APPLY OPENJSON(
    COALESCE(JSON_QUERY(pr.RawJson, '$.files'), JSON_QUERY(pr.RawJson, '$.data.files'))
) AS f
```
