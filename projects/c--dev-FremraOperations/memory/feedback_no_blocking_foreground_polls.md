---
name: feedback_no_blocking_foreground_polls
description: "Don't run long foreground poll/wait loops; use run_in_background so the user isn't stuck"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 3ad99e9b-3f61-4167-9e0b-526408e4f8e1
---

When waiting on something (dev server coming up, CI, a long retry loop), never
run a long-running poll loop as a foreground Bash command — the user is stuck
staring at it and ends up interrupting it.

**Why:** A 90–140s foreground `for … curl … sleep` loop blocks the turn; the
user got visibly frustrated and killed it repeatedly.

**How to apply:** Run poll/wait loops with `run_in_background: true`. The loop
exits the moment its condition is met and the harness re-invokes you then —
you stay free meanwhile. Also: `pwsh` is NOT on the Bash tool's PATH (git-bash);
to start the dev server run `dotnet watch` directly, not `run.ps1`. See the
[[check-fremra-dev-server]] skill, which encodes this.
