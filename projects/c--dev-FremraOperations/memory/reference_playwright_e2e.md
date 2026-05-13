---
name: playwright-e2e
description: "Playwright is installed in tests/e2e/ for mobile-viewport verification — Pixel 7 viewport, Google-OAuth via storageState.json"
metadata: 
  node_type: memory
  type: reference
  originSessionId: 32cc1a1e-3401-4352-b8ee-28a25a71d099
---

Playwright 1.60 lives in [tests/e2e/](tests/e2e/) with `@playwright/test` as a devDependency. Config at `tests/e2e/playwright.config.ts`, mobile spec at `tests/e2e/mobile.spec.ts`. Chromium binary at `C:\Users\ahoibakk\AppData\Local\ms-playwright\chromium-1223\chrome-win64\chrome.exe`.

**Run from repo root** (Bash cwd):
```
tests/e2e/node_modules/.bin/playwright.cmd test --config tests/e2e/playwright.config.ts
```

Add `-g "<pattern>"` to grep tests. Don't use a pipe `|` in the grep pattern — the Bash tool interprets it as a shell pipe.

**Auth (one-time, requires user to interact):**
```
npx playwright codegen --save-storage=tests/e2e/storageState.json --ignore-https-errors https://localhost:5000
```
User logs in via Google, closes the window. `storageState.json` is gitignored.

**Prereq:** dev server must be running on `https://localhost:5000` (user starts it; per [[feedback_never_run_app]] Claude doesn't). Screenshots land in `test-results/` at the repo root (gitignored).

Supersedes the old "no playwright" memory.
