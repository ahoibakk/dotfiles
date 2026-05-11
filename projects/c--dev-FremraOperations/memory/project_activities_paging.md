---
name: Activities page needs paging eventually
description: CRM Activities page loads all rows + descriptions client-side; user has flagged paging as needed once data volume grows
type: project
originSessionId: 5461d132-c1b5-4d1c-9fb8-f4c4adf32f7e
---
The `/Activities` page renders all CRM activities into a single table with descriptions in hidden `data-search` attributes for client-side filtering/sorting. As of 2026-05-06 this is fine, but the user explicitly noted that the typical row already represents one employee × one year of notes — so the volume will grow.

**Why:** User asked "rendre den (mye data) eller gjøre søket som en get?" and accepted client-side rendering as the right call *for now*, while flagging paging as the eventual next step.

**How to apply:** When activity counts or description sizes start to make the initial page load noticeably slow (or when the user revisits this), propose server-side paging + a server-side search GET (existing `FilterCompany`/`FilterContact`/`FilterType` already work this way). At that point the hidden `data-search` attribute should be removed and search becomes a debounced query param.
