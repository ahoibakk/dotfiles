---
name: Drop CrmActivity.CompanyName next dev→main
description: Pending cleanup — remove the legacy CompanyName column from CrmActivities once the FK rollout (CompanyId → CrmCompany) is in production
type: project
originSessionId: 7ea0819c-6ca7-4baa-a346-734d6357d7a6
---
`CrmActivity.CompanyName` is kept populated alongside `CompanyId` (FK → `CrmCompany`) as a transitional cache. The FK + backfill migration was added on 2026-04-30 in branch `dev`.

**Why:** The user wanted activities converted to a real FK against `CrmCompany`, but didn't want to do the destructive column drop in the same dev→main cycle as the schema introduction (per the project's "ship dev→main first for destructive migrations" rule). So this is a two-step rollout.

**How to apply:** After this branch ships dev→main and prod is on the FK, do a follow-up dev cycle that:
1. Removes `CompanyName` column from `CrmActivity`
2. Drops the `CompanyName` writes in `CrmActivityService.UpdateAsync` and `ActivitiesModel.ResolveCompanyAsync`
3. Updates reads to use `activity.Company?.Name` (Include `Company` in queries)
4. Updates `GetByCompanyNameAsync` and `FilterCompany` to pivot on `CompanyId` (or join via `Company.Name`)
5. Updates `Pages/Crm/CompanyDetail.cshtml` to route by id, or keeps name-routing but resolves via `CrmCompany.Name`
6. Generates the destructive migration

There is a `// TODO` comment on `CrmActivity.CompanyName` and in the migration `Sql()` block pointing to this work.
