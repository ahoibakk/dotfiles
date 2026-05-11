---
name: Razor compile-on-build cannot be disabled without runtime compilation
description: Setting RazorCompileOnBuild=false in ASP.NET Core breaks routing unless AddRazorRuntimeCompilation is wired up
type: feedback
originSessionId: cb119ff6-2f98-4e23-8330-02ca1c9bb46c
---
Do NOT suggest `-p:RazorCompileOnBuild=false` (or `<RazorCompileOnBuild>false</RazorCompileOnBuild>`) as a build-speed optimization for FremraOperations.Web without also adding the `Microsoft.AspNetCore.Mvc.Razor.RuntimeCompilation` NuGet package and calling `builder.Services.AddRazorRuntimeCompilation()` in Program.cs.

ASP.NET Core 6+ removed runtime Razor compilation from the default pipeline. With `RazorCompileOnBuild=false` and no runtime compilation registered, Razor Pages are never discovered → every route returns 404 ("Request reached the end of the middleware pipeline without being handled").

**Why:** I confidently suggested this as a speedup in run.ps1, claiming "views compile on first request." They don't — the user got 404 on every page and had to debug a broken app.

**How to apply:** When asked to speed up FremraOperations builds, stick to: `<ProduceReferenceAssembly>true</ProduceReferenceAssembly>` on .Shared, `DOTNET_CLI_USE_MSBUILD_SERVER=1`, Defender exclusions, and `--no-dependencies` when only one project changed. Skip the Razor flag unless explicitly wiring up runtime compilation alongside it.
