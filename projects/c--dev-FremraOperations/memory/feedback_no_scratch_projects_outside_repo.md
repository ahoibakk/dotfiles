---
name: Never create scratch projects outside the repo
description: Don't build throwaway sanity-check projects under /tmp or AppData\Local\Temp — every file op there triggers a permission prompt and the work is usually unnecessary anyway
type: feedback
originSessionId: 0222292a-6146-402c-8377-a189b988fa3f
---
Never create throwaway projects or files outside `c:\dev\FremraOperations\` for sanity checks, debugging, or one-off scripts.

**Why:** `/tmp` on Windows resolves to `C:\Users\<user>\AppData\Local\Temp` which is NOT in the project's allow-listed paths. Every `Edit`, `Write`, `Bash`, `Read` there triggers a permission prompt. User called this out as extremely frustrating after I built a scratch `dotnet` project under `/tmp/compact-test/` to eyeball CvCompacter output on Lars's real CV.

**How to apply:**
- If unit tests already cover the logic, DO NOT additionally run real-data "just to see it" checks — trust the tests.
- If a quick one-off verification is truly needed, add a temporary `[Fact]` (or `[Fact(Skip="scratch")]` and run with filter) in the existing `FremraOperations.Tests` project — it already has the dependencies wired and lives under the allowed root.
- If a small console exploration is needed, reuse `FremraOperations.CreateToken` or a new `.cs` file under an existing project in the repo.
- `/tmp/*.json` data dumps for inspection via jq are fine (read-only pipeline, no project files). The rule is about *creating project structure* outside the repo.
