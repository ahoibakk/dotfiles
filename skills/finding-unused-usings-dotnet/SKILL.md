---
name: finding-unused-usings-dotnet
description: Use when removing unused or redundant using directives from C#/.NET source files, especially when `dotnet format` reports zero changes or the running dev server is locking bin/ output and blocking a normal build
---

# Finding Unused Usings in .NET

## Overview

C# compilers suppress unused-using warnings (CS8019 / IDE0005) by default, and `dotnet format` silently misses them unless the right properties are set. On top of that, a running dev server locks `bin/*.dll`, which causes `dotnet build` to fail with MSB3027 before any warnings are emitted. This skill gives you a working path through those three traps.

## When to Use

- User asks to remove unused/redundant using directives
- `dotnet format analyzers --diagnostics=IDE0005` reports `Formatted 0 of N files` even though you suspect unused usings
- `dotnet build` fails with `MSB3027 Could not copy ... file is locked by: "<app> (<pid>)"`
- A file has a `GlobalUsings.cs` and you need to spot redundant local `using` lines

**Not for:** pure formatting (`dotnet format whitespace`), unused locals/fields (different analyzers).

## Quick Reference

| Situation | Command |
|---|---|
| Try the analyzer first | `dotnet format analyzers --diagnostics=IDE0005 --severity=info --verify-no-changes` |
| Dev server is running, need warnings | `dotnet build <proj>.csproj -t:Compile -p:GenerateDocumentationFile=true` |
| Force re-analysis when incremental skips compile | add `--no-incremental` or touch the file |
| Apply the fix automatically | `dotnet format analyzers --diagnostics=IDE0005 --severity=info` (omit `--verify-no-changes`) |
| Noise reduction | `-p:NoWarn=CS1591` (suppresses the missing-XML-doc flood that comes with `GenerateDocumentationFile`) |

## Step-by-Step Procedure

1. **Try `dotnet format` first.** It's the cleanest tool when it works:
   ```bash
   dotnet format analyzers --diagnostics=IDE0005 --severity=info --verify-no-changes --verbosity=diagnostic
   ```
   If it reports `Formatted 0 of N files` but you know there are unused usings, IDE0005 is disabled because the project lacks `<GenerateDocumentationFile>`. Move to step 2.

2. **Compile-only build with doc generation.** The `-t:Compile` target skips the copy-to-output step that causes file-lock failures when the dev server is running:
   ```bash
   dotnet build <path/to/Project.csproj> -t:Compile -p:GenerateDocumentationFile=true -p:NoWarn=CS1591 2>&1 | grep -E "CS8019|warning " | head -100
   ```
   CS8019 is the unused-using diagnostic. `-p:NoWarn=CS1591` suppresses the missing-XML-comment flood that comes with doc generation.

3. **If incremental build skips compile**, either touch the file (`type nul >> Program.cs` on Windows) or re-run with `--no-incremental`. A fresh `dotnet build -t:Rebuild` will still fail on file locks — stay with `-t:Compile`.

4. **Manual fallback when no build is possible at all.** For small files, resolve each using by hand:
   - Read `GlobalUsings.cs` in the project. Any local `using X;` that duplicates a `global using X;` is **redundant** (not flagged by CS8019 but still removable).
   - For each remaining namespace, grep for the types it defines:
     ```
     Grep pattern: ^(public |internal )?(class|interface|record|struct|enum) \w+
     Path: <namespace folder>
     ```
   - Then grep the target file for any of those type names. Zero references = unused using.
   - Watch for types with the same simple name in multiple namespaces — verify with `namespace X` grep which one the file actually needs.

5. **Verify.** After edits, re-run step 2 (should have no CS8019) or `dotnet build -t:Compile` (must succeed with 0 warnings/errors).

## Common Mistakes

- **Running `dotnet build` (default target) while the dev server is up.** The copy step will fail with MSB3027. Always use `-t:Compile` in that situation.
- **Assuming `dotnet format analyzers` with IDE0005 catches everything.** It silently skips projects without `<GenerateDocumentationFile>true</GenerateDocumentationFile>`. Either enable the property project-wide or use the build-based approach above.
- **Forgetting global usings.** A local `using` that looks redundant because it duplicates a global using is technically not flagged by CS8019 as unused — but is still safe to remove. Always `Read` `GlobalUsings.cs` before reporting "all usings are needed."
- **Relying on a single namespace match.** A namespace can be re-exported by a global using or brought in transitively by another using. Confirm by actually removing the suspected line and re-compiling with `-t:Compile`.
- **Treating `0 Warning(s)` from an incremental build as proof.** If nothing recompiled, no diagnostic ran. Force with `--no-incremental` or a file touch.

## Rationale Notes

- **`-t:Compile` vs `-t:Build`**: `Build` includes `CopyFilesToOutputDirectory` which is what fails under file locks. `Compile` stops right after the compiler runs — warnings are still emitted, nothing is copied.
- **`GenerateDocumentationFile=true`**: Unlocks CS1591 (missing docs) AND CS8019 (unused using) and IDE0005. CS1591 is almost always noise; suppress it with `NoWarn=CS1591` unless you actually want doc coverage.
- **Why manual fallback is sometimes faster**: for a single file with ~25 usings, the namespace-grep-and-check approach takes under a minute and works even with zero build tooling available.
