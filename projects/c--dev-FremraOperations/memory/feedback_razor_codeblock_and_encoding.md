---
name: feedback_razor_codeblock_and_encoding
description: "Razor @{ } nesting rule, and Razor HTML-encodes non-ASCII in @Model output (test gotcha)"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 82ccde9c-c4d2-491e-976c-aa9f9e775e83
---

Two recurring bites when adding Razor Pages + page integration tests in FremraOperations.

**1. Inside a Razor code-block body (`@if`/`@else`/`@for`/`@foreach`) you are already in
code context — do NOT write `@{ ... }` there.** Just write the C# statement directly
(`IntCell(...);`, `var x = ...;`). `@{` is only for switching INTO code from markup
context (page body, inside `<tag>...</tag>`). Using `@{` inside a code block fails with
`RZ1010: Unexpected "{" after "@"`. Local `void` helper functions that emit markup are
fine — declare them directly in the code block, call them bare.

**2. Razor HTML-encodes non-ASCII characters in `@expression`/`@Model.X` output.** A "å"
rendered via `@Model.ErrorMessage` comes back as `&#xE5;` in the response body. Static
markup text is NOT encoded (passes through literally). So in page integration tests,
`Assert.Contains("åpent utkast", html)` fails on raw `ReadAsStringAsync()` output —
decode first: `WebUtility.HtmlDecode(await response.Content.ReadAsStringAsync())`.
`BudgetIntegrationPageTests` already has a `ReadDecodedAsync` helper for exactly this.

**Why:** Both cost a build/test cycle when building the Budget authoring UI (step 3).
**How to apply:** When writing `.cshtml`, only use `@{` from markup context. When
asserting on page text that originates from `@Model.*` and may contain Norwegian
letters (å/ø/æ) or symbols, HtmlDecode the response body first.
