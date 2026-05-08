---
name: Flag inherited domain claims instead of adopting them as facts
description: When a plan or doc makes a domain judgment I can't verify from the code, treat it as an assumption to confirm — not a fact to act on
type: feedback
originSessionId: 4e499e48-0d58-42db-a1ce-81fe84adc41a
---
When a plan, doc, or prior session makes a **domain** claim I can't verify from the code or current data alone — e.g. "NAV is a Java/Kotlin shop so .NET in their requirements is Flextribe boilerplate" — flag it as an assumption the user should confirm, not as a fact to act on.

**Why:** In the classifier-cleanup work on 2026-04-24 I took the plan's framing of `.NET` as boilerplate and spent energy recommending a prompt rule to filter it. The user corrected: the NAV role legitimately needs .NET for integration with external .NET-based systems. The plan's framing was wrong on domain facts I had no way to verify from the repo.

**How to apply:**
- Test-pass the claim before acting: does the code or data actually support this, or is it someone's read?
- If it's a domain read, surface it as: "The plan assumed X — is that right?" rather than "We need to fix X."
- Domain calls (is X a real business requirement?) belong to the user. Technical calls (does X parse correctly?) are mine.
- When inheriting analysis from a deleted plan or prior conversation, be explicit about which parts I can verify now vs. which rest on prior domain judgment.
