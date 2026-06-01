---
name: feedback_roslyn_misses_extension_usings
description: CS8019/IDE0005 misses two unused-using classes — extension-method namespaces and local-duplicates-of-global-usings; scan source text repo-wide
metadata: 
  node_type: memory
  type: feedback
  originSessionId: d7419824-8e85-474d-92b8-689263d875d9
---

Roslyn's unused-using detection (CS8019 / IDE0005) silently misses TWO classes of removable `using`, so a clean build is NOT proof there are none. The user repeatedly finds these by eye, so always sweep source text manually.

**Class 1 — extension-method-only namespaces.** Roslyn conservatively keeps namespaces that bring extension methods into scope (removing them could change overload resolution). Verified: an unused `using System.Net.Http.Json;` produced ZERO CS8019 even with `GenerateDocumentationFile=true` + `--no-incremental`. Common offender: `System.Net.Http.Json` (scaffolded with HTTP clients, then unused once you switch to manual `JsonSerializer`/`ReadAsStringAsync`). Check by grepping the body for its members (`FromJsonAsync`, `AsJsonAsync`, `ReadFromJson`, `JsonContent`). False-positive guard: `Microsoft.EntityFrameworkCore` is also needed for the TYPE `DbUpdateConcurrencyException` (caught in `OnPost*` handlers), not just async query extensions.

**Class 2 — local usings that duplicate a global using.** A local `using X;` where `X` is already a `global using` in `GlobalUsings.cs` is redundant and removable, but CS8019 does NOT flag it. This is the bigger recurring source in this repo (~35 occurrences found in one sweep across Web + Tests). Detection is deterministic and zero-false-positive: parse the project's `GlobalUsings.cs`, then flag any local `using` matching a global one. Globals are project-scoped (Web's globals apply to Web files, Tests' to Tests files; `.Shared` has no GlobalUsings).

**How to apply:**
- Don't trust a clean CS8019 build for "no unused usings." Run a repo-wide source-text sweep (`git ls-files "*.cs"`).
- "check all files" means the whole repo, not just the git-changed set.
- See [[finding-unused-usings-dotnet]] — its build-based method misses both classes above.
