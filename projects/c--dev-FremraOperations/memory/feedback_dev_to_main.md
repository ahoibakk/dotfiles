---
name: "Take dev to main" means clean fast-forward
description: When user says "take dev to main", fast-forward main to dev — no merge commit, no PR, no extra branches
type: feedback
originSessionId: 1109d175-6555-4e9b-8be5-9b109933851f
---
When the user says "take dev to main" (or similar phrasing like "promote dev", "ship dev", "release dev"), execute a clean fast-forward of `main` to `dev`. No merge commit. No pull request. No intermediate branch.

**Why:** Solo workflow, no PRs, and the user wants `main`'s history to look like a linear extension of `dev` — not a tangle of merge commits. `dev` is always ahead of `main` by commits that are already release-ready, so a fast-forward is lossless and clean.

**How to apply:**
- Procedure: `git checkout main && git merge --ff-only dev && git push` (then switch back to `dev`).
- If fast-forward is not possible (main has commits dev doesn't have), stop and ask the user how to resolve — don't create a merge commit or rebase without permission.
- Never open a PR for this step.
- Don't squash or rewrite; preserve the commit history from `dev` as-is on `main`.
- After the push, deployment to production happens via the existing CI workflow on `main`.
