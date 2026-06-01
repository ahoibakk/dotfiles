---
name: sweep-redundant-usings-dotnet
description: Repo-wide source-text sweep for unused/redundant C# using directives that the Roslyn compiler (CS8019 / IDE0005) silently misses — namely local usings that duplicate a global using, and extension-method-only namespaces. Use when asked to find/remove unused usings "across all files" or when a clean build still leaves redundant usings behind.
---

# Sweep Redundant Usings (.NET)

## Why this skill exists

`dotnet build` / `dotnet format` (CS8019, IDE0005) is the obvious tool, but it
**silently misses two whole classes** of removable `using`. A clean build is NOT
proof there are none. This skill finds them by scanning source text instead of
trusting the compiler.

Companion skill `finding-unused-usings-dotnet` covers the build-based path and the
dev-server file-lock traps. Use this one when the compiler comes back clean but
removable usings clearly remain, or when the ask is an "all files" sweep.

## The two classes Roslyn misses

1. **Local using that duplicates a `global using`.** If `GlobalUsings.cs` has
   `global using FremraOperations.Shared.Allocations;`, then a local
   `using FremraOperations.Shared.Allocations;` in any file of that project is
   redundant — but CS8019 does **not** flag it. Detection is deterministic and
   zero-false-positive: parse `GlobalUsings.cs`, flag matching local usings.
   Global usings are **project-scoped** (a project's globals apply only to that
   project's files). This is usually the biggest source.

2. **Extension-method-only namespaces.** Roslyn conservatively keeps any namespace
   that brings extension methods into scope (removing it could change overload
   resolution), so genuinely-unused ones slip through *even with*
   `GenerateDocumentationFile=true`. Verified offender: `System.Net.Http.Json`
   (scaffolded with HTTP clients, then unused once code switches to manual
   `JsonSerializer` / `ReadAsStringAsync`). This class needs a member-usage
   heuristic + human verification — it is NOT auto-removed.

   **False-positive guard:** `Microsoft.EntityFrameworkCore` is also needed for the
   *type* `DbUpdateConcurrencyException` (caught in many `OnPost*` handlers), not
   just async query extensions — verify before removing.

## Procedure

1. **Run the sweep** from the repo root:
   ```bash
   node "<skill-dir>/scripts/sweep-redundant-usings.mjs"
   ```
   It prints two sections: `[REDUNDANT]` (global-duplicate, safe to auto-remove)
   and `[VERIFY]` (extension-namespace candidates, check by hand).

2. **Auto-remove the deterministic class:**
   ```bash
   node "<skill-dir>/scripts/sweep-redundant-usings.mjs" --fix
   ```
   This strips only the `[REDUNDANT]` lines. It never touches `[VERIFY]` lines.

3. **Verify each `[VERIFY]` candidate by hand.** Read the file; grep the body for
   the namespace's extension members (for `System.Net.Http.Json`: `FromJsonAsync`,
   `AsJsonAsync`, `ReadFromJson`, `JsonContent`). Remove only if none are used and
   no *type* from the namespace is referenced either.

4. **Build + test** to prove nothing broke:
   ```bash
   dotnet build <solution>.slnx -t:Compile --no-incremental
   dotnet test  <solution>.slnx
   ```
   (`-t:Compile` avoids the bin/ copy step that fails under a running dev server —
   see `finding-unused-usings-dotnet`.)

## Notes

- The script auto-discovers every `GlobalUsings.cs` via `git ls-files` and scopes
  each file to the **longest-prefix** project root — no hardcoded paths, works in
  any repo.
- It skips `global using static` and alias usings; only plain `global using X;`
  participate in duplicate detection.
- Extend the `EXT` map in the script with more extension-method namespaces
  (`System.Linq`, `System.Linq.Expressions`, etc.) as you encounter them.
