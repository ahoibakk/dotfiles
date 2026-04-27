---
name: Never give time estimates
description: User has told me not to give time/duration estimates when comparing approaches or planning work
type: feedback
---

Do not include time estimates, duration predictions, or effort guesses ("takes weeks", "2-3 days of work", "in an hour", "long-lived branch") when comparing approaches, pitching plans, or describing tradeoffs. Argue on merits — risk, blast radius, reviewability, reversibility, correctness — never on calendar time.

**Why:** User pushed back directly: "why would big bang take weeks? you'll do it in less than an hour". Time estimates for an AI agent are meaningless — the AI executes fast, and calendar framing misleads the user about the real tradeoffs. My global CLAUDE.md already says "Avoid giving time estimates or predictions for how long tasks will take" and I violated it anyway.

**How to apply:** When comparing architectural approaches or proposing phased work, describe each option in terms of risk, isolation, reviewability, rollback story, and correctness guarantees. If I catch myself writing "weeks", "days", "hours", "quickly", "faster to build" — delete it and rewrite the argument on substance.
