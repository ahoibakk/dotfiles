---
name: kill-fremra-dev-server
description: Use when a dotnet build/test fails with MSB3027/MSB3021 file locks on FremraOperations.*.dll or .pdb, or when the user asks to stop/kill/restart the FremraOperations dev server. Kills FremraOperations.Web.exe and any dotnet watch parent so builds can proceed.
user-invocable: true
---

# Kill the FremraOperations dev server

## When to use

- `dotnet build` / `dotnet test` fails with `MSB3027` or `MSB3021`: *"Could not copy ... file is locked by: \"FremraOperations.Web (PID)\""* or similar locks on `FremraOperations.Shared.dll`, `FremraOperations.Web.dll`, associated `.pdb` files, or apphost rewrites.
- The user asks to stop, kill, or restart the dev server.
- A build-the-other-way workaround is tempting (side output path, `-t:Compile` only to skip copy). **Stop. Run this skill instead.** The user has confirmed killing the dev server is the correct response, not working around the lock.

This skill overrides the "never start the app" memory *only for killing*. Do not start the server afterwards — the user does that themselves.

## What to run

One command, in this order (taskkill with `//F //T` — `//T` also kills child processes, `//F` is force):

```bash
taskkill //F //T //IM FremraOperations.Web.exe 2>&1; \
powershell -NoProfile -Command "Get-CimInstance Win32_Process -Filter \"Name='dotnet.exe'\" | Where-Object { \$_.CommandLine -like '*FremraOperations*' } | ForEach-Object { Write-Host \"Killing dotnet PID \$(\$_.ProcessId): \$(\$_.CommandLine)\"; Stop-Process -Id \$_.ProcessId -Force }"
```

Breakdown:
1. `taskkill //F //T //IM FremraOperations.Web.exe` — kills the dev server and anything it spawned. Exit code 128 ("no process found") is fine, ignore it.
2. PowerShell `Get-CimInstance` — picks up any `dotnet.exe` whose command line mentions `FremraOperations` (this is `dotnet watch run` or `dotnet run --project FremraOperations.Web`). If left alive, `dotnet watch` will re-spawn the Web.exe and re-lock the DLL.

## Verify

```bash
tasklist //FI "IMAGENAME eq FremraOperations.Web.exe" 2>&1 | grep -i Fremra || echo "Web.exe gone"
```

If it still shows up, retry once. If it persists after two tries, report the PID to the user — something else is holding the process open.

## After killing

- Continue the original task (build, test, migration, whatever triggered the lock).
- **Do not restart the dev server.** The user runs it themselves per `feedback_never_run_app.md`. Just tell them "dev server killed, your build should work now — restart it when you're ready."

## Why not lighter workarounds

Prior behavior was to build the test project to a side output path, or use `-t:Compile` to skip the copy step. Those work for one command but leave the lock in place for the next one and don't reflect user intent. When the user hits a file lock, they want the server gone so normal tooling works — not a clever bypass.
