# Workflow Orchestration

## 1. Plan Mode Default
- Enter plan mode for ANY non-trivial task (3+ steps or architectural decisions)
- If something goes sideways, STOP and re-plan immediately – don't keep pushing
- Use plan mode for verification steps, not just building
- Write detailed specs upfront to reduce ambiguity

## 2. Subagent Strategy
- Use subagents liberally to keep main context window clean
- Offload research, exploration, and parallel analysis to subagents
- For complex problems, throw more compute at it via subagents
- One task per subagent for focused execution

## 3. Self-Improvement Loop
- After ANY correction from the user: save a `feedback` memory file with the pattern
- Write rules for yourself that prevent the same mistake
- Ruthlessly iterate on these lessons until mistake rate drops
- Memory feedback files are auto-loaded each session — no manual review needed

## 4. Verification Before Done
- Never mark a task complete without proving it works
- Diff behavior between main and your changes when relevant
- Ask yourself: "Would a staff engineer approve this?"
- Run tests, check logs, demonstrate correctness

## 5. Demand Elegance (Balanced)
- For non-trivial changes: pause and ask "is there a more elegant way?"
- If a fix feels hacky: "Knowing everything I know now, implement the elegant solution"
- Skip this for simple, obvious fixes – don't over-engineer
- Challenge your own work before presenting it

## 6. Autonomous Bug Fixing
- When given a bug report: just fix it. Don't ask for hand-holding
- Point at logs, errors, failing tests – then resolve them
- Zero context switching required from the user
- Go fix failing CI tests without being told how

---

# Task Management

1. **Plan First**: Use plan mode for alignment, TodoWrite for tracking steps
2. **Verify Plan**: Check in before starting implementation
3. **Track Progress**: Mark items complete as you go
4. **Explain Changes**: High-level summary at each step
5. **Capture Lessons**: Save corrections as memory feedback files

---

# Deliverable Format (HTML-first)

Plans and substantial written deliverables go out as a single self-contained HTML file, not a markdown wall. Markdown walls are hard to engage with; HTML keeps the user in the loop.

## When this applies
Produce an HTML file for: implementation plans, design docs / specs, architecture proposals, explainers, option / competitor comparisons, status updates, research summaries, onboarding docs — anything the user is meant to read, review, and react to.

## When it does NOT apply
Keep plain markdown for: ordinary chat replies, single-fact answers, short status lines, code edits themselves, commit messages, tool/command output. Don't HTML-ify trivial responses.

## Requirements for the HTML file
- **Single self-contained file** — all CSS and JS inline, no external/CDN dependencies, no build step. It must open straight from disk.
- **Mobile-readable** — include `<meta name="viewport">`, responsive layout, a constrained max-width container (~860px), system font stack, generous line-height.
- **Scannable structure** — clear `<section>`s and headings; color-coded callout boxes (e.g. green = decision/recommended, amber = risk/caution, blue = info, red = blocker).
- **Diagrams** — inline SVG for data-flow / architecture / sequence where a diagram beats prose.
- **UI mockups** — whenever the deliverable involves any UI (new pages, screen/layout changes, new components), include a visual mockup of each affected screen rendered in HTML/CSS (or inline SVG) — not a prose description. Show the layout, the key controls, and realistic sample data, and mark which elements are editable vs. derived. A plan that touches the UI without a mockup is incomplete.
- **Data model / ER diagram** — whenever the deliverable adds or alters database tables, entities, or their relationships, include an ER diagram (inline SVG) showing the new/changed entities, their key columns (PK/FK), and the relationship cardinality. A plan that changes the data model without an ER diagram is incomplete.
- **Comparisons** — real `<table>`s for option/trade-off comparisons, not bullet lists.
- **Code** — include the key code snippets the user should review, in styled `<pre><code>` blocks.
- Add small interactive bits (copy buttons, collapsible sections, sliders) only when they genuinely aid review — don't gold-plate.

## Output location & opening
- Write the file to `~/.claude/plans/` (`C:\Users\ahoibakk\.claude\plans\`) with a descriptive dated name, e.g. `2026-05-18-feature-x-plan.html`.
- After writing, open it in the default browser. The Bash tool runs MSYS bash (not PowerShell), so use `start "" "<full path>"` or `explorer.exe "<full path>"` — a bare `Start-Process` will fail.
- Tell the user the path as a clickable link.

## Interaction with plan mode
In plan mode the HTML file IS the plan: write it, open it, then call `ExitPlanMode` with a short (3–5 line) markdown summary plus a pointer to the opened HTML file. The HTML carries the detail; the ExitPlanMode card just carries the ask.

---

# Core Principles

- **Simplicity First**: Make every change as simple as possible. Impact minimal code.
- **No Laziness**: Find root causes. No temporary fixes. Senior developer standards.
- **Minimal Impact**: Changes should only touch what's necessary. Avoid introducing bugs.
- **No AI Attribution**: Never add "Co-Authored-By" or any AI/Claude attribution to commit messages.
- **Windows Platform**: Development is done on Windows. Use PowerShell-compatible commands when suggesting terminal commands to the user. Don't suggest Unix-only tools (e.g. openssl, sed, awk) without a Windows alternative.
- **No Python**: Python is not installed. Never suggest or use Python scripts; pick a .NET or Node alternative. Node.js is available.
- **Use Dedicated Tools**: Prefer Read over cat/head/tail, Grep over grep/rg. Reserve shell commands for cases that genuinely need piping or combining multiple operations. `find` is allowed.
- **Be Brief**: Keep responses short and to the point. No preamble, no trailing summaries, no filler.
