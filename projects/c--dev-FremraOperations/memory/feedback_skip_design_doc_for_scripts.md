---
name: Skip formal design doc for small features and one-shot scripts
description: Don't write a docs/superpowers/specs/ design doc for small CRUD features, one-shot scripts, or anything where the conversational design outline is sufficient — the agreed approach in conversation is the spec
type: feedback
originSessionId: f5e4a5df-65a4-4eef-a42e-032ec2ba295b
---
For small features (simple CRUD pages, single-entity additions), one-shot scripts (SQL seeds, data backfills, ad-hoc migrations), and any work where the design fits in a short conversational exchange, **do not write a formal design doc in `docs/superpowers/specs/`**. Present the design in the conversation, get approval, then go straight to implementation.

**Why:** The user has pushed back twice now — once for SQL scripts, again for a simple asset-management CRUD feature ("You dont have to design this small feature? Just implement"). Writing a markdown design doc for work that has no architectural decisions worth preserving is ceremony. The in-conversation design + commit messages + code itself are sufficient documentation.

**How to apply:** Still do the brainstorming conversation: explore context, ask clarifying questions, propose approaches, present design sections, get approval. But skip the `docs/superpowers/specs/YYYY-MM-DD-topic-design.md` step (and usually the writing-plans step too — use TodoWrite instead) for work that:
- Is one-shot (runs once, then archived)
- Is a small feature addition with no architectural decisions (standard CRUD, following existing patterns in the codebase)
- Has a design that fits in a short conversational exchange
- The user has explicitly said "just implement" or "just build it"

Still write design docs + formal plans for: multi-session work, architectural changes, anything that crosses system boundaries, anything where future-you needs the preserved context. When unsure, ask the user.
