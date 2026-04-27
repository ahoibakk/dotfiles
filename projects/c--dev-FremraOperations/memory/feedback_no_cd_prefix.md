---
name: No cd prefix in bash commands
description: NEVER prefix bash commands with cd to project root - CWD is already set correctly
type: feedback
---

NEVER prefix bash commands with `cd c:/dev/FremraOperations &&` or any cd to the project root. The CWD is already set.

**Why:** User has corrected this multiple times. The existing memory `feedback_no_redundant_cd.md` was not followed — reinforcing with stronger emphasis.

**How to apply:** Every single bash command should run without a cd prefix. The working directory is already the project root. This applies to ALL bash commands: build, test, git, dotnet ef, everything.
