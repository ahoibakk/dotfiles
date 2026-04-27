---
name: feedback_employee_start_date
description: Always account for employee StartDate in calculations — never include periods before an employee started
type: feedback
---

Always account for employee StartDate when calculating per-employee metrics (allocation, utilization, revenue, etc.). Employees should only be measured against the period from their start date onwards.

**Why:** This is a fundamental business rule, not a one-off request. Calculating against periods before someone started produces misleading numbers (e.g. dragging down average allocation).

**How to apply:** Whenever iterating over employees across a date range, filter the range to start from `Employee.StartDate` if it falls within the period. Skip employees entirely if they haven't started yet during the measured period.
