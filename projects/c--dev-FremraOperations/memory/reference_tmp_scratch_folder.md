---
name: .tmp scratch folder for throwaway work
description: Repo-local gitignored folder at c:/dev/FremraOperations/.tmp for Claude's temp files, scratch scripts, and inspection artifacts
type: reference
originSessionId: 2ee9fe36-a305-40bb-b1b5-04710fa8410e
---
Use `c:/dev/FremraOperations/.tmp/` for any throwaway work: downloaded payloads, one-off scripts, JSON blobs you want to inspect, API response dumps, copy-paste clipboard content, etc.

- Gitignored via `.tmp/` entry in `.gitignore` — files here never get committed.
- Lives inside the repo (unlike `%TEMP%`), so file-op permission prompts stay inside the project scope rather than hitting the `feedback_no_scratch_projects_outside_repo` issue.
- Safe to delete the whole folder anytime — nothing in there is load-bearing.
- Prefer this over the repo root. If you see stray scratch files (e.g. `.req4-*.txt`) in the root, they likely belong in `.tmp/`.
