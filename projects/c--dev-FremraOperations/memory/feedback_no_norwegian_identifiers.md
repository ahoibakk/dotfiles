---
name: feedback-no-norwegian-identifiers
description: Code identifiers must be English; Norwegian only belongs in user-facing display strings and domain data
metadata: 
  node_type: memory
  type: feedback
  originSessionId: e40f6887-a2cb-4243-ac3d-cf3b6fe82b13
---

The user dislikes Norwegian words used as code identifiers — enum members, properties, locals, method names. This applies equally to **non-C# identifiers**: HTML element `id`s, `data-*` attribute values, CSS class names, and JavaScript variable/object keys. (e.g. `data-tab="basis"` + `id="panel-basis"`, not `data-tab="grunnlag"`.)

**Why:** Mixing Norwegian and English identifiers makes the code inconsistent and harder to read.

**How to apply:** Name all C# identifiers in English. Examples from the Budget module rename: `CostFormula.Commission` (not `Provisjon`), `PayrollTax` (not `ArbeidsgiverAvgift`), `PensionInsurance` (not `PensjonAdministrasjon`), `IdleCapacity` (not `Ledighet`), `IncludedInPayrollTaxBase` (not `IncludedInAgaBase`), `IdleCapacityGMultiplier` (not `LedighetGMultiplier`). Norwegian IS fine in user-facing display strings, UI labels (the tab text "Grunnlag" is fine), and seed/domain data (cost-line names like "Husleie") — those are shown to Norwegian users. A doc-comment quoting a Norwegian business term as a translation aid is also acceptable. When writing new code in a module, default to English identifiers from the start — and when editing an existing file that already uses Norwegian ids, fix them rather than following the bad convention.
