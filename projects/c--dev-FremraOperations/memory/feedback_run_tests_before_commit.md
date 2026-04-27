---
name: Always run tests before committing
description: Run dotnet test before every commit to catch broken tests — never commit without verifying
type: feedback
---

Always run `dotnet test` BEFORE creating a commit, not after. Committing broken tests is unacceptable.

**Why:** Committed dashboard changes that broke a test assertion (was checking for removed "Inntekt hittil" string). Should have caught this before committing.

**How to apply:** After staging files and before `git commit`, always run `dotnet test` and verify all tests pass. If tests fail, fix them first and include the fix in the same commit.
