---
name: Solution file is .slnx, not .sln
description: This repo uses the XML-based FremraOperations.slnx solution file instead of the legacy .sln format
type: project
originSessionId: 77b13f31-cab0-43ce-b7f4-848ac196aa44
---
The FremraOperations repo uses `FremraOperations.slnx` (XML-based solution format) at the repo root — not the legacy `.sln`.

**Why:** Easy to assume `dotnet build`/`dotnet test`/`dotnet sln` commands need a `.sln`, glob for `*.sln`, or otherwise miss the file when checking solution structure.

**How to apply:** When referencing the solution file, looking for it via Glob, or running `dotnet sln` commands, target `FremraOperations.slnx`. Modern `dotnet` CLI handles `.slnx` natively, so no special flags are needed.
