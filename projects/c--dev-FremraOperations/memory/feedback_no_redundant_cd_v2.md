---
name: feedback_no_redundant_cd_v2
description: NEVER prefix bash commands with cd to project root — CWD is already c:\dev\FremraOperations
type: feedback
---

NEVER use `cd c:/dev/FremraOperations &&` or any variant before bash commands. The working directory is already set to the project root.

**Why:** User has corrected this multiple times. It's unnecessary noise and wastes time.

**How to apply:** Just run commands directly (e.g., `git status`, `dotnet test`). The CWD is always correct.
