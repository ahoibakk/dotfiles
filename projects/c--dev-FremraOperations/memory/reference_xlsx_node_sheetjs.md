---
name: reference-xlsx-node-sheetjs
description: "Read .xlsx/Excel files with Node and the SheetJS (xlsx) library, not Python"
metadata: 
  node_type: memory
  type: reference
  originSessionId: 87b27509-453f-412a-8ffb-59080d163702
---

To read or parse `.xlsx`/Excel files, use Node.js with the SheetJS library (`xlsx` npm package). Python is not installed — see [[feedback_no_python_probing]].

**How to apply:** Write a small Node script — `const XLSX = require('xlsx'); const wb = XLSX.readFile('file.xlsx'); const rows = XLSX.utils.sheet_to_json(wb.Sheets[wb.SheetNames[0]]);` — and run it with `node`. Install the package first if missing (`npm install xlsx`); prefer the repo's existing `tests/e2e` node setup or a `.tmp/` scratch dir per [[reference_tmp_scratch_folder]].
