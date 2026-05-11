---
name: No output-trimming pipes on build/test commands
description: Don't pipe build/test output through Select-Object/head/tail to "trim" it — run the command bare
type: feedback
originSessionId: 311cb044-2efe-4fa6-8ed6-d5c3c185d5f9
---
Never pipe `dotnet build`, `dotnet test`, or similar commands through `Select-Object -Last N`, `head`, `tail`, or any output trimmer. Run the bare command.

**Why:** The user pushed back hard ("motherfucker whats with the select-object?!") when I ran `dotnet build ... | Select-Object -Last 30`. It's noise, it adds shell complexity, and it can hide real output. Bash tool already handles long output fine.

**How to apply:** When running build/test/lint commands, just invoke them directly — no pipe-to-trimmer at the end. If output is genuinely huge, run with `--verbosity quiet` or equivalent flags instead of post-processing.

Also do not pipe Bash-tool commands to PowerShell cmdlets like `Out-String`, `Select-Object`, `Format-Table`. The Bash tool runs through bash, not PowerShell — those cmdlets don't exist there and the command will fail with `command not found`. Just run the dotnet command bare.
