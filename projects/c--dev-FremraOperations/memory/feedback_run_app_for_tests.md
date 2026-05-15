---
name: Run the web app for tests
description: Start the FremraOperations dev server with .\run.ps1 (dotnet watch) when needed for Playwright e2e tests; don't ask the user to do it
type: feedback
originSessionId: ed332fb5-24f6-457a-855c-75da70fcebe7
---
When Playwright e2e tests need a live dev server and one isn't already running on `https://localhost:5000`, start it yourself with `.\run.ps1` (which runs `dotnet watch --project FremraOperations.Web run`) in the background. Do not bounce the request back to the user.

**Why:** The user reversed the previous "never start the app" rule mid-session: "but you need to run it, not me." The friction of asking for a manual restart for every test run is more annoying than the lock-conflict risk that the original rule was protecting against — and `dotnet watch` makes the server resilient to file changes anyway.

**How to apply:**
- Before running Playwright, check `https://localhost:5000` is up. If not, launch `.\run.ps1` via Bash with `run_in_background: true` and poll until it responds.
- **If YOU started the dev server, YOU must kill it once the tests are done** — run the [[kill-fremra-dev-server]] skill at the end of the task. Don't leave a server you spawned running; it locks DLLs for the next build and duplicates the user's own instance. (If the server was already up when you arrived, leave it — the user owns that one.)
- Also use [[kill-fremra-dev-server]] if a build/test fails with `MSB3027`/`MSB3021` DLL locks.
- Don't start it for ad-hoc verification the user could do faster in a browser. Start it specifically when YOU need to drive the page programmatically.
