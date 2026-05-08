---
name: Dedupe obvious duplicate code between live sites
description: When two or more sites already contain the same logic, extract a shared helper rather than tolerating the duplication
type: feedback
originSessionId: 4e499e48-0d58-42db-a1ce-81fe84adc41a
---
When you find yourself writing the same ~30+ line block in a second live site, extract a shared helper **as part of the same change** — don't ship the duplicate and "follow up later."

**Why:** The user explicitly called this out after I suggested shipping the classifier 503-fallback as a copy of the matcher's fallback logic. "Nobody likes duplicate code unless there is a real reason for it." Premature *abstractions* are bad, but that rule protects against speculative interfaces. It does not license duplicating a proven, live pattern.

**How to apply:**
- Two or more concrete callers already using the same logic → extract.
- One call site + speculative future callers → don't abstract.
- Framework/library code: err toward extraction (changes propagate).
- Page-specific ViewModels, trivial formatting: stay inline.

The CLAUDE.md principle "Three similar lines is better than a premature abstraction" applies to *new* abstractions that don't yet have multiple consumers. It doesn't mean "keep copying proven code."
