---
name: Don't grep system / framework install folders
description: When a namespace or type lookup fails, fix via known .NET conventions or error message, not by grepping dotnet install directories
type: feedback
originSessionId: 3ce94e9a-4eb5-4222-871b-3fd06bb50bd1
---
When a compile error reports a missing namespace/type (e.g. `TempDataAttribute` not found), do NOT grep `C:\Program Files\dotnet\` or other framework install folders to find it. That's a wasteful shotgun search through thousands of XML docs and assemblies.

**Why:** The user called this out explicitly — it's noise, slow, and almost never the right move. Standard .NET types live in well-known namespaces that I should know or quickly look up in official docs. Grepping the SDK install tree signals desperation, not competence.

**How to apply:**
- For missing types: rely on what I know about .NET (`TempDataAttribute` → `Microsoft.AspNetCore.Mvc`, not `ViewFeatures`).
- If I genuinely don't know, check official Microsoft docs via WebFetch, or look at how the type is used elsewhere in the user's own codebase (Grep inside `c:\dev\...`).
- Never grep `c:\Program Files\...`, `C:\Users\...\.nuget\packages\`, or similar system-level paths to resolve an API question.
