---
name: bash-tool-runs-msys-bash-not-powershell-never-write-ps-cmdlets
description: "The Bash tool executes in MSYS2/MinGW bash even though the env header says \"Shell: PowerShell\". Write bash syntax; PowerShell cmdlets (Start-Process, Get-Process, Test-Path, $env:) fail."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 329efba1-579c-499f-b947-0735c2812ac8
---

The environment header says "Shell: PowerShell", but that describes the user's *interactive* terminal. The **Bash tool** actually runs MSYS2/MinGW bash (`uname` → `MINGW64_NT ... Msys`, `SHELL=/bin/bash.exe`). So every Bash tool call must be **bash syntax**, not PowerShell.

PowerShell cmdlets silently fail in the Bash tool: `Start-Process` ("never works"), `Get-Process`, `Stop-Process`, `Test-Path`, `Get-ChildItem`, `Get-Content`, `$env:VAR`, `Select-Object`, etc. The allowlist in `.claude/settings.json` is correctly bash-shaped (`seq`, `sleep`, `curl` are real coreutils here and DO work) — do not "fix" it by adding PowerShell verbs.

**Why:** User noticed I'd "started using a lot of PowerShell commands" and that `Start-Process` "never works". Root cause: I was writing PowerShell into a bash shell. I had even wrongly advised allowlisting `Start-Process` and dropping `seq`/`sleep` as "dead on Windows" — exactly backwards.

**How to apply:**
- Open a file/browser from the Bash tool: `start "" "C:/path/file.html"` or `explorer.exe "C:/path"` or `powershell -NoProfile -Command 'Start-Process "..."'` — NOT a bare `Start-Process`.
- File checks: use the **Read/Glob/Grep tools**, not `Test-Path`/`Get-Content`/`ls`. See [[feedback-no-shell-file-listing]].
- Need PowerShell specifically? Invoke it explicitly: `powershell -NoProfile -Command '...'`.
- `cd` is denied and Bash cwd is already the project root. See [[feedback-no-unnecessary-cd]].
- For `az` calls with `/subscriptions/...` IDs, prefix `MSYS_NO_PATHCONV=1`. See [[feedback-msys-path-conv-for-az]].
