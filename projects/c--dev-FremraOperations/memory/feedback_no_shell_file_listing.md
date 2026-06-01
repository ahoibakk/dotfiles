---
name: Never use ls (or shell file-listing); use Glob/Read directly
description: No `ls`, `dir`, `Get-ChildItem`, or other shell directory listings — use Glob for patterns and Read for known paths. Also forbids spawning agents that will do this.
type: feedback
originSessionId: 76e5edf5-9353-49d0-9b28-3923e5003427
---
Never run `ls`, `dir`, `Get-ChildItem`, `tree`, or any shell command whose purpose is to list directory contents. Use **Glob** for pattern-based discovery and **Read** for known paths. Glob takes any absolute path and works **outside** the project folder too (`~/.claude/plans`, the memory dir, etc.) with no prompt — there is never a reason to shell out to list a folder.

Do NOT use `git -C <path> ls-files` as a workaround for listing other folders. It only shows tracked files (misses untracked/gitignored), it still triggers a permission prompt, and Glob already does the job better. Reaching for `git -C` to list a directory is the same mistake wearing a disguise.

This rule extends to subagents: do NOT spawn an Explore (or any) agent for "look around the repo" tasks when the file paths are already known (e.g. listed in CLAUDE.md). The agent will run `ls`/`Glob` internally and the user sees that as wasted work.

**Why:** User reacted angrily — "WHY IN THE FUCK ARE YOU DOING LS?!" — when I dispatched an Explore agent for a task where CLAUDE.md already enumerated the relevant files. The user has a strong, repeated preference for internal tools over shell file-listing, and treats agent-driven `ls` the same as me running it myself. Global CLAUDE.md already says "Prefer Read over cat/head/tail, Grep over grep/rg"; this is the same principle for directory listing.

**How to apply:**
- Need a specific file? → `Read` it directly.
- Need to find files matching a pattern? → `Glob` (e.g. `**/*.cshtml.cs`).
- Need content search? → `Grep`.
- The CLAUDE.md "Pages" / "Key files" sections list paths — trust them, don't rediscover.
- Only spawn Explore for genuinely open-ended questions across files NOT documented in CLAUDE.md, and even then never for "list what's in this folder."
