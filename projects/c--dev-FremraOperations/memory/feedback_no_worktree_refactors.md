---
name: No worktree agents for interconnected refactors
description: Don't use worktree agents for multi-step refactoring tasks — use sequential implementation instead
type: feedback
---

Don't use worktree agents for large refactoring tasks where steps are interconnected and touch overlapping files. The merge complexity outweighs any parallelism gains.

**Why:** User rejected the approach when 3 worktree agents were launched for a CrmDbContext->AppDbContext rename + allocation migration. The files are too interdependent.

**How to apply:** For multi-step refactors, implement sequentially in the main repo. Use agents (non-worktree) only for parallel research/file reading, not for parallel code changes.
