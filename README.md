# dotfiles

Canonical store for the global Claude Code config under `%USERPROFILE%\.claude`.

## Topology

The repo is the source of truth. Paths under `~/.claude` are linked back to it:

| Path in `~/.claude`                                  | Type     | Target in this repo                                  |
| ---------------------------------------------------- | -------- | ---------------------------------------------------- |
| `CLAUDE.md`                                          | hardlink | `CLAUDE.md`                                          |
| `settings.json`                                      | hardlink | `settings.json`                                      |
| `hooks/`                                             | junction | `hooks/`                                             |
| `skills/`                                            | junction | `skills/`                                            |
| `projects/c--dev-FremraOperations/memory/`           | junction | `projects/c--dev-FremraOperations/memory/`           |

Edits via either path are reflected at the other — hardlinks share the inode, junctions resolve to the same directory.

## Bootstrap on a fresh machine

```powershell
git clone https://github.com/ahoibakk/dotfiles C:\dev\dotfiles
C:\dev\dotfiles\bootstrap.ps1
```

`bootstrap.ps1` is idempotent: it backs up any pre-existing real files in `~/.claude` to `~/.claude/backups/bootstrap-<timestamp>/` and then installs the hardlinks (files) and junctions (dirs) listed in the topology table. No admin or Developer Mode required (same NTFS volume only).

## Verifying a link

```powershell
(Get-Item "$env:USERPROFILE\.claude\CLAUDE.md").LinkType        # -> HardLink
fsutil hardlink list "$env:USERPROFILE\.claude\CLAUDE.md"       # both paths listed
(Get-Item "$env:USERPROFILE\.claude\hooks").LinkType            # -> Junction
```

## Caveats

- **Hardlinks need same NTFS volume.** All paths above are on `C:`.
- **Atomic-save editors break hardlinks.** Some editors save a file by writing to a temp file and renaming it over the original — that produces a new inode and severs the hardlink to the dotfiles copy. Claude Code itself writes in place, so editing via Claude Code is safe. For hand edits, prefer editors with in-place save, or re-create the hardlink afterwards.
- **Junctions are immune** to atomic-save (they resolve at the directory level), so memory/hooks/skills are robust regardless of how files inside them are written.
- **What is _not_ linked in:** `~/.claude/todos/`, per-session `~/.claude/projects/<session-id>/...` runtime state, and memory for projects other than FremraOperations. These intentionally stay local.

## Working with this repo from Claude Code

`settings.json` denies `cd:*`, `git -C:*`, `git --git-dir:*`, and `git --work-tree:*`. To run git inside this repo from a Claude Code Bash call, use `pushd`:

```bash
pushd c:/dev/dotfiles && git status && popd
```
