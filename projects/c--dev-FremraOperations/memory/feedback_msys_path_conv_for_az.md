---
name: ""
metadata: 
  node_type: memory
  originSessionId: 10f41e4a-2d3c-4381-a429-b1920dc4c9da
---

When passing an Azure resource ID (`/subscriptions/.../resourceGroups/...`) as an `az` CLI argument from the Bash tool on Windows, prefix the command with `MSYS_NO_PATHCONV=1`. Otherwise Git Bash's MSYS layer rewrites the leading `/` into `C:/Program Files/Git/subscriptions/...` and the call fails with errors like `LinkedInvalidPropertyId` or `usage error: --resource ID ...`.

**Why:** Git Bash auto-converts POSIX paths to Windows paths when passing arguments to non-MSYS programs (like `az.cmd`). Azure resource IDs look like POSIX paths but must be passed through verbatim.

**How to apply:**
- Any `az` command where an arg starts with `/subscriptions/...` — `az monitor diagnostic-settings`, `az sql server audit-policy --lawri`, `az resource ... --parent`, etc.
- Not needed for commands that use named flags only (e.g. `--name X --resource-group Y`).
- Inside `setup-infra.sh` (run on Linux/macOS in real use), `MSYS_NO_PATHCONV` is harmless — the shell ignores unknown env vars on POSIX. So even the committed script can carry it if needed, though normal usage on Linux doesn't require it.
