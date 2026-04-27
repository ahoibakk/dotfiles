---
name: Skip trivial tests
description: Don't write tests for simple fire-and-forget code like webhook notifiers
type: feedback
---

Don't write tests for trivially simple code (e.g. a class that just POSTs to a webhook URL and catches exceptions). User considers these low-quality tests.

**Why:** Tests that only verify that HttpClient.PostAsJsonAsync works or that a null config skips a call add no real value — the behavior is obvious from reading the code.

**How to apply:** Only write tests when the logic has meaningful complexity (parsing, calculation, branching, state management). Skip tests for thin wrappers around external calls with simple graceful degradation.
