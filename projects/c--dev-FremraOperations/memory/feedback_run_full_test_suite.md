---
name: Run full test suite, not just directly-related tests
description: Always run integration tests after a contract change, not just unit tests for the modified service
type: feedback
originSessionId: bdb1858a-6ff9-49da-b355-a5b5822a9b14
---
After changing a service signature or page-handler form keys, run the **entire** test suite — not just unit tests for the modified service. Integration tests submit FormUrlEncodedContent that mirrors browser POSTs, and stale form keys silently keep producing 200 responses (handler binds defaults) instead of the expected 302 redirect.

**Why:** While implementing the AllocationService row-id edit fix, the AllocationServiceTests passed but two PageIntegrationTests still posted the old `originalEmployeeId`/`originalProjectId` keys. They went unnoticed and got committed broken until the next fix's test run surfaced them.

**How to apply:** Before any commit that touches a public method signature or a page-handler parameter list, run `dotnet test` for the whole `FremraOperations.Tests` project (no filter). The full suite is fast (~10s) and is the only way to catch cross-cutting binding mismatches.
