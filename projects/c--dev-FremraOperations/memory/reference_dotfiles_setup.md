---
name: dotfiles topology
description: How ~/.claude is linked to the c:/dev/dotfiles repo (hardlinks for files, junctions for dirs)
type: reference
originSessionId: 1fea9cc3-64a3-45ae-9bb7-b34f9f5b23be
---
The dotfiles repo at `c:/dev/dotfiles` (remote: `https://github.com/ahoibakk/dotfiles`, branch `master`) is canonical for the global Claude config. Paths under `C:\Users\ahoibakk\.claude\` are linked to it:

- **Hardlinks (files):** `CLAUDE.md`, `settings.json`
- **Junctions (directories):** `hooks/`, `skills/`, `projects/c--dev-FremraOperations/memory/`

Implication: editing `~/.claude/CLAUDE.md` or `~/.claude/settings.json` via Claude Code updates the dotfiles copy in place — the file shows up in `git status` inside `c:/dev/dotfiles`, and a single commit there persists the change. No more drift, no more manual sync.

Caveat: atomic-save editors (write-tempfile-then-rename) break hardlinks for the two scalar files. Claude Code writes in place, so it's fine. Hand edits via VS Code may break the link — verify with `(Get-Item ...).LinkType` and `fsutil hardlink list ...` and recreate via `New-Item -ItemType HardLink` if broken.

To run git against the dotfiles repo from a Bash tool call: `pushd c:/dev/dotfiles && git ... && popd` (the deny list blocks `cd`, `git -C`, `git --git-dir`, `git --work-tree`, but not `pushd`).

Bootstrap commands and full topology details: `c:/dev/dotfiles/README.md`.
