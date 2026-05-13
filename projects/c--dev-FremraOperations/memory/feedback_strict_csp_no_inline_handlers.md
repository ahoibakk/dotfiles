---
name: Strict CSP blocks inline event handlers — use nonce'd scripts
description: Project CSP is `script-src 'self' 'nonce-{nonce}'` (no `'unsafe-inline'`). Inline `onchange=`/`onclick=`/`onsubmit=` HTML attributes are silently blocked.
type: feedback
originSessionId: e354ed69-1afd-4469-96fc-9172eb95884c
---
The FremraOperations CSP set in [Program.cs](FremraOperations.Web/Program.cs) is strict: `script-src 'self' 'nonce-{nonce}'`. There is no `'unsafe-inline'`. This means:

- Inline event handler attributes (`onchange="..."`, `onclick="..."`, `onsubmit="..."`, etc.) are **blocked**. The handler never runs; nothing appears in the network tab; the user sees no feedback.
- The browser logs a `Refused to execute inline event handler...` console warning, but that's the only signal.

**Why:** This has bitten the user multiple times — they've "lost count." It looks like the feature is broken (form doesn't submit, button does nothing) when really the handler was just CSP-blocked.

**How to apply:**
- Never write `onchange="..."`, `onclick="..."`, `onsubmit="..."`, etc. on HTML elements in any `.cshtml`.
- Replace with a `data-*` attribute (e.g., `data-auto-submit`, `data-confirm="..."`) and a small wire-up in `@section Scripts { <script nonce="@(ViewContext.HttpContext.Items["CspNonce"])"> ... </script> }`.
- Example: `<input ... data-auto-submit />` plus `document.querySelectorAll('[data-auto-submit]').forEach(el => el.addEventListener('change', () => el.form?.submit()))`.
- When reviewing or writing a page that does any client-side interaction, scan for inline event handlers *before* declaring the work done — they will silently fail.
