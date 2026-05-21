---
name: feedback_no_blanket_kill_dotnet
description: Never blanket-kill all dotnet.exe / testhost processes; target the specific PID or use the kill skill
metadata:
  type: feedback
---

The user rejected `taskkill //F //IM dotnet.exe`. Killing every `dotnet.exe` (or every `testhost.exe`) is too broad — it can take down the IDE's language server, other concurrently-running agents, and unrelated builds.

**Why:** On this machine multiple dotnet processes run at once (IDE, parallel agents, dev server). A blanket `/IM` kill is collateral damage.

**How to apply:** When a leftover `testhost`/build process locks `bin/` output, kill it by its specific PID (the lock message names it, e.g. `locked by: "testhost (14492)"`) — `taskkill //F //PID <pid>`. For the FremraOperations dev server specifically, use the `kill-fremra-dev-server` skill. Never use `//IM dotnet.exe`. See [[feedback_autonomous_work]].
