---
name: Branching — dev by default, feature branches for major work, no PRs
description: Regular commits go to dev; feature/* branches only for major tasks; main is production; no pull requests ever
type: feedback
originSessionId: 24c71412-8b34-4dad-8282-156e5a1e9f5d
---

Regular development commits go to `dev`. `main` is production — only release-ready work lands there, via a clean fast-forward from `dev` (see `feedback_dev_to_main.md`). Create a `feature/*` branch only for major tasks (large refactors, risky work, multi-session changes); feature branches merge back into `dev`. No pull requests, ever. When a feature branch is already active, small related changes ride along on that branch rather than getting their own.

**Why:** Solo workflow, no code review overhead wanted. User clarified this after CLAUDE.md had contradictory guidance — the final rule is: `main` = production, `dev` = default working branch, `feature/*` = only for major work, and no PRs.

**How to apply:**
- Default to `dev` for regular commits. If currently on `main`, switch to `dev` before making routine changes (and ask before committing directly to `main`).
- Don't propose a new branch for small fixes, doc tweaks, or isolated changes — just commit to `dev`.
- Don't propose opening a PR — ever. Merges happen locally.
- For a major task (large refactor, risky change, multi-session work), ask once whether it warrants a `feature/*` branch before creating one; such branches merge back into `dev`.
- When a feature branch is already active, keep small related changes on it rather than spawning new branches.
- Production release = fast-forward `main` to `dev` (only when user asks; see `feedback_dev_to_main.md`).
