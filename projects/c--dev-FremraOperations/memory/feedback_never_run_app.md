---
name: Never run the web app
description: Do not start the FremraOperations web app via dotnet run; the user runs it themselves
type: feedback
originSessionId: ed332fb5-24f6-457a-855c-75da70fcebe7
---
Never run the FremraOperations web app (e.g. `dotnet run --project FremraOperations.Web`). The user runs it themselves in their own terminal/IDE.

**Why:** The user explicitly told me "Oh never run the app for me" after I started it in the background following a code change. Running it creates DLL lock conflicts on the next build and duplicates what the user is already doing.

**How to apply:** After code changes that affect the web app, just tell the user to restart/reload. Do not invoke `dotnet run`, `dotnet watch`, or any command that launches FremraOperations.Web — not in the foreground, not in the background. `dotnet build` and `dotnet test` are fine.

**Killing is different from starting.** If a build/test fails with `MSB3027`/`MSB3021` DLL locks, use the `kill-fremra-dev-server` skill to stop the server — do not work around locks with side output paths or `-t:Compile` tricks. After killing, still let the user restart it themselves.
