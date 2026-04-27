---
name: Never reset or rewrite git history without explicit permission
description: Do not use git reset, rebase, or amend on existing commits without asking first — even for local unpushed commits
type: feedback
---

NEVER use `git reset`, `git rebase`, or `git commit --amend` on commits that already exist without explicit user permission. Even if commits are local/unpushed, they may represent the user's in-progress work.

**Why:** User had existing commits that were reset without being asked. This is a destructive action that violates trust, even when the content is preserved via soft reset.

**How to apply:** When tests break after a commit, create a NEW fix commit instead of amending or resetting. If history cleanup is truly needed, describe the plan and ask before touching any existing commits.
