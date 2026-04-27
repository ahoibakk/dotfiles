---
name: Never use cd in Bash commands
description: `cd` is denied in .claude/settings.json for this repo — never use it. The Bash tool's working directory is already `c:/dev/FremraOperations`. Also avoid chaining with `&&`.
type: feedback
originSessionId: 17ce5ab8-7858-45c6-ba1a-e23bff1f8ef0
---
Do not use `cd` in Bash commands in this repo. It is actively denied in `.claude/settings.json` (`"Bash(cd:*)"` under `deny`).

**Why:** The Bash tool's working directory is already set to `c:/dev/FremraOperations` on every call. `cd` is never needed. The user explicitly added it to `deny` because I kept forgetting this, and even harmless-looking `cd c:/dev/FremraOperations && git ...` chains were both unnecessary AND caused permission prompts (allowlisted subcommands like `git commit` still prompted when chained with `cd`).

**How to apply:**
- Run `git status`, `git diff`, `git add <file>`, `git commit -m "..."`, `dotnet build ...` etc. bare. The cwd is already correct.
- If a command must run from a subdirectory, pass the path as an argument (`dotnet build FremraOperations.Web/FremraOperations.Web.csproj`), not via `cd`.
- Also avoid chaining commands with `&&`. Claude Code splits on `&&`/`||`/`;`/`|` and checks each subcommand against the allowlist, but edge cases still occasionally prompt. Prefer separate Bash tool calls (in parallel when independent).
- If the user ever asks me to `cd` somewhere, push back — they explicitly blocked it.
