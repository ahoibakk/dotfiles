---
name: Do the grunt work autonomously
description: User expects Claude to handle process management (killing processes, restarting apps) without asking them to do it
type: feedback
---

Don't ask the user to do grunt work like stopping locked processes or running mechanical commands. Just do it yourself.

**Why:** User got frustrated when asked to stop the web app before tests could run — they expect autonomous problem-solving for mechanical blockers.

**How to apply:** When a process is locking a file, kill it yourself. When a build fails because of a stale process, fix it yourself. BUT — do not *start* the web app (see `feedback_never_run_app.md`); the user runs the app themselves. The distinction: unblock (kill/clean up) = yes; launch long-running services = no.
