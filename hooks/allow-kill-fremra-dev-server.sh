#!/usr/bin/env bash
# PreToolUse hook: auto-allow taskkill / tasklist / Stop-Process commands
# scoped to FremraOperations only when the kill-fremra-dev-server skill is
# active in the current transcript. Silent no-op for all other calls so the
# normal permission flow proceeds unchanged.

set -u

input=$(cat)

tool_name=$(printf '%s' "$input" | jq -r '.tool_name // empty')
if [ "$tool_name" != "Bash" ]; then
  exit 0
fi

cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // empty')
transcript=$(printf '%s' "$input" | jq -r '.transcript_path // empty')

if ! printf '%s' "$cmd" | grep -q 'FremraOperations'; then
  exit 0
fi
if ! printf '%s' "$cmd" | grep -qE '(taskkill|tasklist|Stop-Process)'; then
  exit 0
fi

if [ -z "$transcript" ] || [ ! -f "$transcript" ]; then
  exit 0
fi

recent=$(tail -n 400 "$transcript")
active=0
if printf '%s\n' "$recent" | grep -F '"name":"Skill"' | grep -qF '"skill":"kill-fremra-dev-server"'; then
  active=1
elif printf '%s\n' "$recent" | grep -qF '"commandName":"kill-fremra-dev-server"'; then
  active=1
fi

if [ "$active" = "1" ]; then
  printf '%s\n' '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"allow","permissionDecisionReason":"kill-fremra-dev-server skill active"}}'
fi

exit 0
