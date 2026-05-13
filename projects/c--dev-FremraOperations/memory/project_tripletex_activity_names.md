---
name: tripletex-activity-name-conventions
description: "Two gotchas in /project/hourlyRates rate rows — (Alle) catch-all is null, and activity names carry a sort-order prefix"
metadata: 
  node_type: memory
  type: project
  originSessionId: e421fb45-bd4e-43ff-a455-49496e3bec6d
---

Two non-obvious facts about how Fremra's Tripletex configures `/project/hourlyRates` rows; both bit us on the Belegg Timepris column and silently undercounted KPIs/prognosis revenue:

1. **`(Alle)` catch-all rows have `activity = null` in the API.** A project configured with one rate row (Ansatt = Alle, Aktivitet = Alle, e.g. project FIØK / id 30) emits a `projectSpecificRates` entry with the `activity` field absent. A strict `activity.name == "Konsulentbistand"` filter drops it and leaves the project with no resolvable rate.

2. **Activity names carry a leading "N " sort-order prefix.** Fremra's projects (e.g. project NG Flyt / id 17) use names like `"1 Konsulentbistand"`, `"2 Konsulentbistand, overtid 50%"`, `"3 Konsulentbistand, overtid 100%"`, `"4 Reisetid"`. Stripping a leading `^\d+\s+` before comparing against the configured billable activity name is required to match the base activity while still excluding overtime variants and other named activities.

**Why:** Both behaviors are silent — no error, just empty `DefaultRate`/`EmployeeRates`. Until the [[feedback]]-driven Belegg Timepris column made it visible, prognosis and dashboard P&L silently fell through to employee-level fallback rates instead of using the actual project rate, so revenue numbers were lower than reality.

**How to apply:** All consumers (Allocation, Index/Dashboard, Prognosis) call `TripletexClient.GetProjectHourlyRates` — fix the filter there once, it propagates everywhere. Don't reintroduce a strict equality check on `activity.name`. See `MatchesBillableActivity` in `FremraOperations.Shared/Tripletex/TripletexClient.cs` and the corresponding tests in `TripletexClientTests`.
