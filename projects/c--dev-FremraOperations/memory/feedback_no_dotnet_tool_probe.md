---
name: Don't probe dotnet tool installations
description: Call dotnet ef / sqlpackage directly without first running `dotnet tool list` — the tools are installed and documented in reference_dev_tools.md
type: feedback
originSessionId: 1e025cfc-436b-40a1-a4ab-9821d6ee7f47
---
Don't run `dotnet tool list` / `dotnet tool list -g` to "verify" that ef tools are available. Just call `dotnet ef migrations add ...` directly.

**Why:** The user has already told me which tools are installed (see reference_dev_tools.md). Probing wastes tool calls and triggers permission prompts for nothing. The user gets frustrated when I don't trust their setup.

**How to apply:** When the task needs `dotnet ef`, `sqlpackage`, `gh`, `az`, `sqlcmd`, or `node` — just run the command. If it errors, then debug. Don't pre-flight check.
