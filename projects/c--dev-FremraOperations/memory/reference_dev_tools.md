---
name: Dev environment CLI tools
description: CLI tools installed on the dev machine and how to use them (az, gh, dotnet, sqlcmd, etc.)
type: reference
originSessionId: 41bdf612-8daa-4e16-8251-329bd20eb8f8
---
Installed CLI tools:
- **dotnet** — .NET SDK (primary build tool)
- **az** — Azure CLI (login, resource management)
- **gh** — GitHub CLI (PRs, issues, actions)
- **sqlcmd** — `C:\Program Files\SqlCmd\sqlcmd.exe` (Go-based, installed via winget)
- **git** — Git for Windows (bash shell in VS Code)
- **node / npm / npx** — Node.js (installed late 2026; usable for tooling, MCP shims, etc.)

Python is NOT installed.

Azure SQL connection via sqlcmd:
```
sqlcmd -S fremra-operations-sql.database.windows.net -d fremra-operations-db --authentication-method ActiveDirectoryDefault
```
Requires `az login` for Azure AD/Entra credentials.
