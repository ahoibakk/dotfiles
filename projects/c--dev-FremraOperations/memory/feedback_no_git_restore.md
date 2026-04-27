---
name: git restore on unstaged changes requires permission
description: Never run git restore / git checkout -- on working-tree modifications; the unstaged change is destroyed (not stashed, not in reflog). Treat identically to git reset --hard.
type: feedback
originSessionId: a3dfcdf3-a6ab-44ef-aa5b-9832a6b4a28e
---
Never run `git restore <file>` or `git checkout -- <file>` against an unstaged working-tree modification without explicit user permission. The change is destroyed — not stashed, not in the reflog, not recoverable from the object database.

**Why:** 2026-04-21, I ran `git restore CLAUDE.md` to clean the tree before starting Batch 6 of a multi-batch plan. The user had 8 lines of unstaged edits to CLAUDE.md they were working on. Those edits were permanently lost — only potentially recoverable via VS Code's Timeline local-history feature, which isn't guaranteed.

**How to apply:** when a stray file modification needs to be out of the way for branch work, always prefer `git stash push -u <file>` over `git restore <file>`. Stash is reversible; restore is not. This extends the existing `feedback_no_git_reset` rule from history-rewriting commands to working-tree-destroying commands — same category of "destroys work the user might care about," same rule: ask first.

If the tree is "dirty" at branch-switch time, options in order of preference:
1. Check with the user if the change is intentional WIP they want to keep.
2. `git stash push -u -m "<context>" <file>` to park it.
3. Commit it to the current branch if it belongs there.
4. Only restore/discard after explicit user confirmation.
