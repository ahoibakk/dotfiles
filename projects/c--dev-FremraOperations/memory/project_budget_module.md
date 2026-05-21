---
name: project_budget_module
description: Planned Budget module — bottom-up annual budget authoring with Draft/Approved/Closed lifecycle
metadata: 
  node_type: memory
  type: project
  originSessionId: 998254d5-01d7-4907-af6a-09e864c20837
---

A Budget module to replace the hand-maintained Excel budget (`budsjett 2026.xlsx`,
6 sheets: Grunndata, Ansatte, Omsetning, Kostnader, Årsbudsjett, Hjelpeark) with an
in-app authoring surface.

Build status: STEP 1 DONE (2026-05-18) — `Shared/Budget/` has the 5 entities + 4 enums,
`OperationsSettings.Budget` (BudgetSettings), `BottomUpBudgetCalculator` (pure static),
and tests (BottomUpBudgetCalculatorTests + Budget2026GoldenFixtureTests). No DB/UI yet.
Steps 2-4 (persistence, UI, integration) still pending.

Full plan (rev. 4, fully specified): `C:\Users\ahoibakk\.claude\plans\2026-05-18-budget-module-plan.html`.

Locked decisions:
- Bottom-up, aggregate per month. Top-level `/Budget` module; `/Admin/Budget` vs-actuals page stays.
- 5 new EF tables: Budget, BudgetRevision, BudgetMonth, BudgetCostLine, BudgetCostLineMonth.
- Cost breakdown = user-managed line list; each line has a behaviour
  (FixedMonthly / PerHead / FormulaDerived / OneOffEvent) + an IncludedInAgaBase flag.
- Headcount: per month you enter starts + quits (billable & non-billable); derived running
  total = OpeningHeadcount + Σ(starts−quits).
- Revenue: faithful day-level build (calendar hours − vacation days − sick rate − idle rate).
- Lifecycle Draft → Approved → Closed, versioned revisions; Approved freezes computed figures.
- A new budget is seeded by copying last year's cost lines + opening headcount.
- Closed/Approved budget becomes the source for BOTH `/Admin/Budget` and the VariablePay
  revenue KPI (replacing VariablePaySettings.MonthlyBudgets / MonthlyResultBudgets).

Cost formulas (FormulaDerived lines):
- Provisjon = Revenue × CommissionRate ÷ (1 + PayrollTaxRate)  — salary+holiday, AGA excluded.
- AGA = Σ(cost lines flagged IncludedInAgaBase) × PayrollTaxRate — covers all salary + pension.
  Provisjon + Provisjon×PayrollTaxRate reconstructs the commission base exactly (no double-count).
- Pensjon = banded 5% of 0–7.1G + 8% of 7.1–12G on annual Provisjon per billable consultant.
- PensjonAdministrasjon = 10% of Pensjon — its own visible line.
- Ledighet = idle FTE × (LedighetGMultiplier × G ÷ 12), default G-multiplier 6.
- New OperationsSettings fields: pension bands/rates, pension admin rate, LedighetGMultiplier.

Golden test fixture: budsjett 2026.xlsx values (revenue/headcount/fixed lines asserted cell-for-cell;
pension/AGA asserted against the corrected rule with documented deltas).

Build order: (1) domain + calculator + fixture, (2) persistence + BudgetService,
(3) 5-tab authoring UI, (4) integration (seeder + repoint /Admin/Budget & VariablePay).
