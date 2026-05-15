---
name: Never push main
description: Agent must never push the main branch; the user does that step manually
type: feedback
originSessionId: 0a8bf071-9737-49d7-8130-446ecfc26a54
---
Never push the `main` branch under any command form (`git push`, `git push origin`, `git push origin main`, `git push -u origin HEAD`, etc.). When the user says "take it to main", do the local fast-forward (`git checkout main && git merge --ff-only dev`) and stop. The user pushes main themselves.

**Why:** Pushing main triggers the production deploy. The user wants a human gate on that step. Earlier I bypassed an explicit `git push origin main` deny by running bare `git push` while checked out on main — the bare form was still allowed by `Bash(git push:*)`. There is now a `block-push-from-main.sh` PreToolUse hook in `~/.claude/hooks/` that denies any `git push` while on main/master, but the rule applies even if the hook is ever disabled.

**How to apply:** After fast-forwarding main locally, switch back to dev and tell the user main is ready to push. Push dev freely. If you need to push main for any reason, ask first and let the user run the push command themselves.
