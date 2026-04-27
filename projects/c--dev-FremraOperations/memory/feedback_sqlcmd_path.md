---
name: Use sqlcmd directly, not full path
description: sqlcmd is on PATH — invoke as `sqlcmd`, not `C:/Program Files/SqlCmd/sqlcmd.exe`
type: feedback
originSessionId: f5e4a5df-65a4-4eef-a42e-032ec2ba295b
---
Call `sqlcmd` directly. Do not use the full path `C:/Program Files/SqlCmd/sqlcmd.exe`.

**Why:** It's already on the user's PATH. Using the full path is noisy and the user explicitly called it out.

**How to apply:** Any time running sqlcmd from Bash on this machine, use the bare command:
```
sqlcmd -S fremra-operations-sql.database.windows.net -d fremra-operations-db --authentication-method ActiveDirectoryDefault -Q "..."
```
