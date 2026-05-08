---
name: Tripletex API approval/locking semantics
description: Non-obvious facts about the Tripletex timesheet API that don't show up by reading endpoint docs alone
type: project
---
Tripletex API notes that supplement the endpoint docs (and CLAUDE.md):

- There is **no approval filter on `/timesheet/entry`**. Approval is month-level only via `/timesheet/month`. Filtering entries by approval status requires joining against the month payload.
- `TimesheetEntry.locked` (bool, read-only) means the entry is locked/uneditable — it is **not** a per-entry approval field. There is no per-entry approval state at all.

**Why:** Mistaking `locked` for an approval marker, or assuming `/timesheet/entry` exposes approval metadata, has caused incorrect filtering in salary calculations.

**How to apply:** When reasoning about which entries are "approved" or "final", always go through `/timesheet/month`. Treat `locked` as edit-permission state only.
