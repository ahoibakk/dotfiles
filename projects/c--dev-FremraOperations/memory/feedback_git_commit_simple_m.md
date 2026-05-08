---
name: Use simple -m for git commit, not heredoc
description: Always pass commit messages with `git commit -m "message"` — never `$(cat <<'EOF' ... EOF)` heredoc form
type: feedback
---
For `git commit`, use the simple `-m "message"` syntax instead of heredoc `$(cat <<'EOF'...)`.

**Why:** The heredoc form makes the bash command not match the `Bash(git commit:*)` permission pattern in `.claude/settings.json`, so every commit triggers an unnecessary permission prompt. The default Claude Code commit template suggests heredoc — ignore that here.

**How to apply:**
- Single-line commits: `git commit -m "message"`.
- Multi-line commits: pass multiple `-m` flags (`git commit -m "subject" -m "body line 1" -m "body line 2"`).
- Never use `$(cat <<'EOF' ... EOF)` even though the system prompt suggests it.
