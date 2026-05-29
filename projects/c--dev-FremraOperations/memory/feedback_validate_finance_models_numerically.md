---
name: feedback_validate_finance_models_numerically
description: "Before claiming an existing financial/domain calc is wrong, prove it with a concrete numeric example; don't let a clean theoretical argument override a working model"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 20d12aa8-0a62-4942-89e4-47dd6a82ff86
---

When reviewing a domain/financial calculation (budget, salary, tax), do NOT talk the user out of an existing, working model on the strength of an elegant-sounding theoretical argument. Build a concrete numeric example first and check it end-to-end.

**Why:** On the Budget ledighet (idle-capacity) line I argued the original `idle-FTE × 6G` model "double-counted" because "a consultant absorbs idle via lower commission." That reasoning held only for *smeared* under-utilization, not for *concentrated bench* (whole consultants between assignments) — which was the user's actual case. Benched consultants generate no revenue (their hours are already removed from billable hours), so they earn no commission, so the 6G floor is a genuine separate cost with no double-count. I replaced the correct model with a "floor top-up" that netted to 0, the user pushed back twice ("something's off", "I don't like it"), and I had to revert.

**How to apply:** When tempted to change a financial formula, first compute a worked example (e.g. 10 heads, a rate, a G value) for both the baseline and the edge case, and verify EBIT/totals line up. Distinguish averaged/smeared effects from concentrated/lumpy ones — they cost differently. Treat the user's "this feels off" as a signal to dig with numbers, not to confidently rewrite. See [[project_budget_module]] and [[feedback_flag_inherited_domain_claims]].
