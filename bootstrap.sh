#!/usr/bin/env bash
# Bootstrap ~/.claude to point at this dotfiles repo (macOS / Linux).
#
# Idempotent: takes a one-time backup of any existing real files/dirs that
# would be replaced (under ~/.claude/backups/bootstrap-<timestamp>/), then
# installs:
#   - hardlinks for CLAUDE.md and settings.json
#   - symlinks for hooks/, skills/, and the FremraOperations memory dir
#
# Hardlinks require the repo and ~/.claude to live on the same filesystem.

set -euo pipefail

REPO_ROOT="${1:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"
CLAUDE_ROOT="${2:-$HOME/.claude}"

info() { printf '[bootstrap] %s\n' "$*"; }

[ -d "$REPO_ROOT" ] || { echo "RepoRoot not found: $REPO_ROOT" >&2; exit 1; }
if [ ! -d "$CLAUDE_ROOT" ]; then
  info "Creating $CLAUDE_ROOT"
  mkdir -p "$CLAUDE_ROOT"
fi

TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_ROOT="$CLAUDE_ROOT/backups/bootstrap-$TIMESTAMP"

# plan entries: "<kind>|<target>|<source>"
#   kind = hardlink | symlink
PLAN=(
  "hardlink|$CLAUDE_ROOT/CLAUDE.md|$REPO_ROOT/CLAUDE.md"
  "hardlink|$CLAUDE_ROOT/settings.json|$REPO_ROOT/settings.json"
  "symlink|$CLAUDE_ROOT/hooks|$REPO_ROOT/hooks"
  "symlink|$CLAUDE_ROOT/skills|$REPO_ROOT/skills"
  "symlink|$CLAUDE_ROOT/projects/-Users-ahoibakk-projects-FremraOperations/memory|$REPO_ROOT/projects/c--dev-FremraOperations/memory"
)

abspath() { python3 -c 'import os,sys;print(os.path.realpath(sys.argv[1]))' "$1" 2>/dev/null || (cd "$(dirname "$1")" && printf '%s/%s\n' "$(pwd)" "$(basename "$1")"); }

backup_existing() {
  local target="$1"
  local rel="${target#$CLAUDE_ROOT/}"
  local dest="$BACKUP_ROOT/$rel"
  mkdir -p "$(dirname "$dest")"
  info "BACKUP   $target  ->  $dest"
  mv "$target" "$dest"
}

for entry in "${PLAN[@]}"; do
  IFS='|' read -r kind target source <<<"$entry"

  [ -e "$source" ] || { echo "Source missing in repo: $source" >&2; exit 1; }

  mkdir -p "$(dirname "$target")"

  if [ -L "$target" ]; then
    current="$(readlink "$target")"
    expected="$source"
    # readlink may return a relative path on some setups; compare resolved forms too
    if [ "$current" = "$expected" ] || [ "$(abspath "$target")" = "$(abspath "$source")" ]; then
      info "OK       $target  (already symlink to repo)"
      continue
    fi
    info "REPLACE  $target  (symlink retargeting)"
    rm "$target"
  elif [ -e "$target" ]; then
    if [ "$kind" = "hardlink" ] && [ ! -d "$target" ]; then
      src_ino="$(stat -f %i "$source" 2>/dev/null || stat -c %i "$source")"
      tgt_ino="$(stat -f %i "$target" 2>/dev/null || stat -c %i "$target")"
      if [ "$src_ino" = "$tgt_ino" ]; then
        info "OK       $target  (already hardlink to repo)"
        continue
      fi
    fi
    backup_existing "$target"
  fi

  case "$kind" in
    hardlink)
      info "LINK     $target  =hardlink=>  $source"
      ln "$source" "$target"
      ;;
    symlink)
      info "LINK     $target  =symlink=>   $source"
      ln -s "$source" "$target"
      ;;
  esac
done

# Route git hooks at the tracked githooks/ dir so post-merge re-links automatically.
if [ -d "$REPO_ROOT/githooks" ]; then
  git -C "$REPO_ROOT" config core.hooksPath githooks
  info "git core.hooksPath -> githooks"
fi

info "Done."
if [ -d "$BACKUP_ROOT" ]; then
  info "Pre-existing files were moved to: $BACKUP_ROOT"
fi
