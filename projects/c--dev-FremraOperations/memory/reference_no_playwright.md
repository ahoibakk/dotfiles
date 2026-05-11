---
name: Playwright not installed
description: This PC has no Playwright; skip browser verification or ask before installing
type: reference
originSessionId: 7fb2bb17-172a-4a8b-a9bc-adc02b482068
---
Playwright is not installed on this machine and not present as a global skill folder. `npx playwright` would auto-download into the npm cache but `npm` itself is missing the user prefix dir (`C:\Users\ahoibakk\AppData\Roaming\npm`).

The `playwright-ui-verify` skill is available in the skills list, but invoking it would fail without an install. Don't run it unguarded — ask the user before installing Playwright, and otherwise verify UI changes by reading the code path or asking the user to smoke-test.
