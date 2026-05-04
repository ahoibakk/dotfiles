---
name: Don't spawn explore subagents when CLAUDE.md already lists the file paths
description: For surveys where the relevant files are already listed in project CLAUDE.md, read them directly with Read instead of launching an Explore agent
type: feedback
originSessionId: 76e5edf5-9353-49d0-9b28-3923e5003427
---
When the user gives a task in the FremraOperations repo and CLAUDE.md already enumerates the relevant files (it has an exhaustive "Pages" and "Key files" section with file paths), do NOT launch an Explore agent to "survey" them. Read the listed files directly with Read in parallel.

**Why:** User got angry — "WHY IN THE FUCK ARE YOU DOING LS?!" — when I spawned an Explore agent for a budget-page planning task. The CLAUDE.md already pointed at `Pages/Admin/SettingsPrognosis.cshtml.cs`, `Pages/Admin/Prognosis.cshtml.cs`, `Dashboard/DashboardCalculator.cs`, `OperationsSettings`, etc. An explore agent for known paths is pure overhead — extra latency, extra token cost, and the agent runs `ls`/`Glob` to rediscover what was already documented.

**How to apply:** Before launching Explore (or any subagent for "where is X?"), check whether CLAUDE.md's Pages/Key-files lists already name the files. If yes, Read them directly in parallel. Reserve Explore for genuinely open-ended searches across files NOT mentioned in CLAUDE.md, or for "find every caller of X" style sweeps.
