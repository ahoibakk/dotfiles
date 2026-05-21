---
name: don-t-run-playwright-unless-asked
description: Never run Playwright / browser verification on your own initiative; only when the user explicitly asks for it
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 99d02e10-ec3e-4898-89d2-0ee72a799672
---

Never run Playwright tests or browser-level UI verification unless the user explicitly asks for it in the current request. After code changes, stop at `dotnet build` + `dotnet test` — that is "verifying it works".

**Why:** An unprompted Playwright run was disruptive: it needed the dev server, restarting it churned processes, the `dotnet watch` app crashed and orphaned, and the cascade of starts/kills/polls burned the user's time for verification they never asked for. The user: "dont run playwright test unless i say so."

**How to apply:**
- Do not invoke the [[playwright-ui-verify]] skill, run scripts under `.tmp/playwright`, or drive a browser on your own initiative.
- Do not treat an "outstanding: Playwright not run" note in task context as a cue to run it — leave it for the user.
- Only when the user explicitly asks for Playwright / browser verification does [[feedback_run_app_for_tests]] apply (start the dev server yourself then).
