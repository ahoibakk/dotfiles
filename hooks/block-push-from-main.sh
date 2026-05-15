#!/usr/bin/env bash
# PreToolUse hook: deny `git push` when the current branch is main/master.
# The user runs the fast-forward locally and pushes main themselves; the agent
# must never push main. Catches all argument forms (bare `git push`,
# `git push origin`, `git push -u origin HEAD`, etc.) by inspecting the
# checked-out branch instead of trying to enumerate command shapes.

set -u

input=$(cat)

tool_name=$(printf '%s' "$input" | jq -r '.tool_name // empty')
if [ "$tool_name" != "Bash" ]; then
  exit 0
fi

cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // empty')

# Only intercept commands that contain a `git push` invocation.
if ! printf '%s' "$cmd" | grep -qE '(^|[[:space:];&|()])git[[:space:]]+push([[:space:]]|$)'; then
  exit 0
fi

cwd=$(printf '%s' "$input" | jq -r '.cwd // empty')
if [ -z "$cwd" ]; then
  cwd=$(pwd)
fi

branch=$(git -C "$cwd" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "")

if [ "$branch" = "main" ] || [ "$branch" = "master" ]; then
  printf '%s\n' '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"Refusing to push while checked out on main/master. The user pushes main themselves after a local fast-forward."}}'
  exit 0
fi

exit 0
