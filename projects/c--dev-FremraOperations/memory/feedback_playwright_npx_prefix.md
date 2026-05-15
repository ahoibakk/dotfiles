---
name: feedback-playwright-npx-prefix
description: "Playwright lives in tests/e2e/node_modules; invoke via `npx --prefix tests/e2e playwright ...`, and the matching settings.json allow pattern is `Bash(npx --prefix tests/e2e playwright:*)`"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: d1eaff7c-bfb9-4e82-bd61-9bc7ef0cc32c
---

Playwright is installed in `tests/e2e/node_modules` (own package.json), not the repo root. Always invoke it as:

```
npx --prefix tests/e2e playwright test --config tests/e2e/playwright.config.ts <spec> --reporter=list
```

**Why:** Running plain `npx playwright …` from the repo root either re-downloads playwright or fails to find the local install. The `--prefix tests/e2e` flag points npx at the right node_modules. `cd tests/e2e && …` is not an option because `cd` is denied in settings.

**How to apply:** The project allowlist must include `Bash(npx --prefix tests/e2e playwright:*)` alongside `Bash(npx playwright:*)` — the latter does NOT cover the `--prefix` form because permission patterns are prefix-matched against the literal command string. If a new Playwright command path comes up (different prefix dir, different binary), add a matching allow entry rather than silently falling back to plain `npx playwright`.
