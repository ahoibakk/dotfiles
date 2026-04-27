---
name: Plans should be self-contained for new sessions
description: Write plans with enough context to be picked up by a fresh session without conversation history
type: feedback
originSessionId: 957a6591-b458-4338-9aa0-be984c5c04be
---
Plans should be written as if they'll be read in a new session without conversation history.

**Why:** Plans that reference "the user's prompt" or "the current code" without including the actual content are useless in a new session. The plan becomes a handoff document that needs to stand alone.

**How to apply:** When writing plan files, include:
- Full file paths with line numbers for every change point
- Current code snippets showing what exists (not just "replace X")
- The actual content to use (e.g., the full prompt text, not "the user's new prompt")
- Rationale for key design decisions
- Think of it as handing off to another developer who has no context

**Before finalizing a plan, audit it with these checks:**
1. **No dangling references.** Every term like "the docs", "the response shape", "the pattern from X" must either include the content or point to a specific file/line the reader can open. "Per what the user pasted earlier" is a failure mode.
2. **No indecision leftovers.** If you explored two options mid-plan, delete the losing one. Text like "Decision A — Actually, pick B" is confusing; only the final call should appear. The code/snippets in the plan must match the text's final decision.
3. **API sample bodies included inline.** If a plan describes parsing field `foo.bar.baz`, the reader shouldn't need to go find the docs to know that's valid JSON — paste the minimum sample response.
4. **Dependencies surfaced at point of use.** If a class signature changes between sections (e.g., adds a constructor arg), update every occurrence in the plan, not just the DI registration section.

Run this audit as the last step before declaring the plan done. This is a pattern-level failure that's easy to regress on if rushed.
