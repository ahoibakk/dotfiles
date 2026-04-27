---
name: No probing for Python
description: The "no Python" rule covers probing/checking too — rule out Python-dependent paths upfront. Node.js IS available.
type: feedback
originSessionId: 957a6591-b458-4338-9aa0-be984c5c04be
---
The `No Python` rule in CLAUDE.md applies to *any* use of the runtime, not just writing scripts. Don't run `python --version`, `where python`, `pip ...`, or similar probes, and don't suggest approaches whose viability depends on the user having Python installed.

Node.js IS now installed and is fair game (`node`, `npm`, `npx`).

**Why:** Probing treats Python as a potentially viable path. The user has already decided it isn't, so the probe is wasted and signals that the rule wasn't internalized. When an MCP bundle, tool, or library requires Python to run, rule it out immediately and either find a .NET- or Node-native path or say "this requires Python, which isn't available — options are X or Y."

**How to apply:** Before running any command that detects a runtime, ask whether that runtime is on the approved list (.NET, Node — not Python). For MCP servers specifically: prefer Claude Code's native HTTP/SSE transport pointing at a remote endpoint, which needs no local runtime. For bundles that ship Python proxies, unpack the manifest to find the actual remote endpoint and connect to that directly. Node-based MCP shims (`mcp-remote`, `npx`-launched servers) are now usable.
