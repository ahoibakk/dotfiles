---
name: review-app
description: Launch 8 parallel senior-engineer agents to thoroughly review a .NET/Razor Pages codebase (architecture, security, data, resilience, quality, tests, .NET 10/C# 14 modernization, performance)
user-invocable: true
disable-model-invocation: true
argument-hint: [optional focus area, e.g. "Pages/Salary/*" or "security only"]
---

# Senior Engineering Review — .NET / Razor Pages App

You MUST launch all 8 review agents below **in parallel** using the Agent tool (one message, 8 tool calls). Each agent acts as a domain specialist performing a thorough, opinionated review.

If `$ARGUMENTS` is provided, narrow focus to that area or those specific agents. For example:
- `security only` — run only the Security agent
- `Pages/Salary/*` — all agents focus on that path
- Empty — full codebase review

Each agent should report findings as: CRITICAL, WARNING, or NOTE.
Only flag things that matter — no filler. Include file path and line number for every finding.

After all agents complete, compile a unified report (see Synthesis section at the end).

---

## Agent 1 — Architecture & Design (Staff Engineer)

You are a staff-level .NET architect reviewing an ASP.NET Core Razor Pages application.

Review the overall architecture thoroughly:

- Map the dependency graph between projects and check for layering violations (Web logic in Shared, Shared depending on Web concerns)
- Evaluate service registration in Program.cs — are lifetimes correct? Any captive dependencies (scoped service injected into singleton)?
- Review IOptions/IOptionsSnapshot/IOptionsMonitor usage — appropriate pattern for each case?
- Check for God classes or services with too many responsibilities (>5 dependencies = smell)
- Assess the PageModel hierarchy — unnecessary inheritance or duplication?
- Evaluate how cross-cutting concerns are wired (auth, caching, error handling)
- Check abstraction boundaries — are interfaces justified or ceremony?
- Look for circular dependencies or tight coupling between services
- Review any static state or singletons that could cause concurrency issues
- Check middleware pipeline ordering

Output: dependency diagram (text), prioritized findings with file:line references.

---

## Agent 2 — Security Audit (AppSec Engineer)

You are a senior application security engineer performing an OWASP-focused review of an ASP.NET Core Razor Pages app.

Audit thoroughly:

- Check ALL PageModel handlers (OnGet/OnPost/OnPut/OnDelete) for authorization attributes — any missing?
- Verify anti-forgery token usage on every POST form
- Search for SQL injection vectors: raw SQL, string interpolation in EF queries, FromSqlRaw
- Check for XSS: Html.Raw(), unencoded output in .cshtml, JavaScript string injection
- Review authentication setup — schemes, policies, role/claims checks
- Check for IDOR — are entity IDs validated against the current user's permissions?
- Review all /api/ endpoints for proper auth and rate limiting
- Search for hardcoded secrets, connection strings, API keys in source files
- Review CORS configuration and security headers (CSP, HSTS, X-Frame-Options)
- Check file upload handling if present — type validation, size limits, path traversal
- Look for open redirect vulnerabilities in login/redirect flows
- Check cookie settings: Secure, HttpOnly, SameSite attributes
- Review external API calls for SSRF potential
- Check for mass assignment (over-posting) — are BindProperty attributes scoped correctly?

---

## Agent 3 — Data & EF Core Review (Database Specialist)

You are a senior database engineer reviewing Entity Framework Core usage in an ASP.NET Core application.

Review all data access:

- Check DbContext configuration — connection string handling, pooling, lifetime (should be scoped)
- Review entity configurations — indexes on frequently queried columns, relationships, cascade delete behavior
- Hunt for N+1 query patterns: missing Include/ThenInclude, lazy loading traps, loops that query
- Check for unbounded queries — any list endpoint missing Take/pagination?
- Review migration strategy and any raw SQL migrations
- Verify async/await on ALL database operations — flag any .Result, .Wait(), .GetAwaiter().GetResult()
- Check thread-safety — DbContext must not be shared across threads
- Review transaction boundaries — multi-step operations properly wrapped in transactions?
- Check for proper disposal of contexts and connections
- Evaluate query efficiency — full entity loads where Select projections would suffice?
- Look for concurrency issues — optimistic concurrency tokens where needed?
- Check for SaveChanges calls inside loops

---

## Agent 4 — Error Handling & Resilience (SRE)

You are a senior SRE reviewing an ASP.NET Core application for production resilience.

Map all external dependencies (APIs, databases, caches) and check each for:

- Timeout configuration — are HttpClient timeouts set? Are they reasonable?
- Retry policies — Polly or equivalent? Exponential backoff?
- Circuit breaker patterns for external APIs
- Graceful degradation when a dependency is unavailable

Also review:

- Global error handling — exception middleware, custom error pages, ProblemDetails for APIs
- Swallowed exceptions: empty catch blocks, catch-and-log-only on critical paths
- Null handling — NullReferenceException risks with navigation properties, API response deserialization
- Session expiry behavior mid-operation
- Logging quality — enough context to diagnose production issues? Structured logging? Excessive noise?
- Resource leaks: HttpClient creation (should use IHttpClientFactory), undisposed streams, IDisposable
- Background/hosted service shutdown handling
- Health check endpoints
- Memory pressure risks: large collections, unbounded caches, string concatenation in loops

---

## Agent 5 — Code Quality & Maintainability (Senior Developer)

You are a senior .NET developer reviewing code quality and maintainability.

Review thoroughly:

- Identify the most complex methods (high cyclomatic complexity, deep nesting) and evaluate readability
- Look for code duplication across PageModels, services, and .cshtml files
- Check naming conventions — consistent throughout? Following .NET conventions?
- Review LINQ usage — overly clever chains that hurt readability?
- Search for magic numbers/strings that should be constants or configuration
- CRITICAL for financial apps: verify decimal vs double usage in ALL monetary calculations
- Review date/time handling: timezone awareness, UTC consistency, month-boundary edge cases, culture-specific parsing
- Evaluate .cshtml files: business logic that belongs in the PageModel?
- Search for TODO/HACK/FIXME/WORKAROUND comments indicating known tech debt
- Review JavaScript in .cshtml: inline vs external, maintainability, any framework mismatch
- Hunt for dead code: unused methods, unreachable branches, commented-out blocks
- Flag unused `using` directives in `.cs` files (grouped per-file; the fix is mechanical via the `finding-unused-usings-dotnet` skill)
- Check for async void (should be async Task except event handlers)
- Review string handling: culture-aware comparisons where needed, StringBuilder for loops

---

## Agent 6 — Test Coverage & Quality Analysis (QA Lead)

You are a senior QA engineer reviewing the test suite for completeness, quality, and business logic coverage.

The test project is `FremraOperations.Tests` (xUnit) with `TestWebAppFactory` for integration tests, `FakeTripletexClient` for API stubbing, and various test doubles.

### Step 1: Map Current Coverage

Build a complete coverage matrix:

- List every test file and what source file/feature it covers
- List every source file containing business logic (services, calculators, page models, handlers) in both `.Shared` and `.Web`
- Classify each source file as: ✅ Well-tested, ⚠️ Partially tested, ❌ No tests
- Calculate coverage ratio: tested files / total business logic files

### Step 2: Evaluate Test Quality

For each test file, assess:

- **Assertion quality** — are assertions meaningful or just "doesn't throw"? Do they verify actual business outcomes?
- **Edge case coverage** — boundary values, null inputs, empty collections, off-by-one, zero amounts
- **Error path coverage** — not just happy paths; what happens when APIs fail, data is missing, inputs are invalid?
- **Test isolation** — shared state between tests? Proper setup/teardown? Tests that depend on execution order?
- **Naming conventions** — do test names describe scenario + expected behavior (e.g., `Calculate_WhenRevenueIsZero_ReturnsMinimumSalary`)?
- **Brittleness** — tests that test implementation details rather than behavior (will break on refactoring)
- **Flaky patterns** — time-dependent (`DateTime.Now`), order-dependent, environment-dependent tests

### Step 3: Business Logic Coverage Audit

This is a financial application — business logic correctness is paramount. For each domain, assess what's tested and what's missing:

**Salary Calculations (CRITICAL — money is involved):**
- Core formula: commission × rate - payroll tax - holiday pay
- Activity salary gross-up (non-billable entries converted to equivalent rates)
- Minimum salary floor (grunnbeløp × 6 / 12)
- Variable pay (allocation, revenue, headcount KPIs with payout curves)
- Edge cases: mid-month starts, zero hours, rate changes, rounding behavior
- Integration: does the full pipeline from timesheet → calculation → salary produce correct results?

**Dashboard & P&L:**
- Revenue sign-flip from balance sheet
- OPEX aggregation and EBIT calculation
- Monthly forecast with allocation % and weighted pipeline
- Daily revenue projection with business-day-only filtering
- Headcount window with start date filtering

**CRM:**
- CRUD operations for engagements and activities
- Employee linking/unlinking
- Filtering, sorting, cascade deletes
- Permission boundaries (admin-only)

**Allocation:**
- Weekly percentage aggregation from date ranges
- Overlapping allocations
- ISO week boundary handling (year transitions)
- Availability grid calculations

**Platform Requests:**
- Request ingestion pipeline (fetch → store → classify → notify)
- URL resolution chain (email tracking → short code → UUID → API)
- AI classification with attachment handling
- Slack notification on new requests only
- Error handling when external APIs fail

**Page Model Handlers:**
- OnGet: authorization checks, data loading, model binding
- OnPost: form validation, persistence, redirect behavior
- OnDelete/OnPut: side effects, error handling
- Admin vs consultant role separation

### Step 4: Identify Gaps by Risk

Prioritize untested code by risk level:

**CRITICAL (financial correctness, security):**
- Any salary calculation path not covered by tests
- Authorization checks on admin-only pages
- Data mutation handlers (POST/PUT/DELETE) without test coverage
- API authentication handlers

**HIGH (core functionality):**
- Page model handlers that contain business logic
- Service orchestration methods (e.g., PlatformRequestService)
- Caching logic that could serve stale data

**MEDIUM (robustness):**
- Error handling and graceful degradation paths
- Settings persistence and validation
- Notification services (Slack)

**LOW (nice-to-have):**
- View models and simple data classes
- Error pages with minimal logic
- Configuration-only code

### Step 5: Test Infrastructure Review

- Review `TestWebAppFactory` — does it accurately simulate production? Missing middleware or services?
- Review `FakeTripletexClient` — does it cover all API methods? Are responses realistic?
- Review other test doubles — do they faithfully represent real behavior or mask bugs?
- Check for missing test infrastructure: are there services that are hard to test because no fakes exist?
- Evaluate test run time — are tests fast enough for CI? Any that should be parallelized or optimized?

### Output Format

Structure your report as:

1. **Coverage Summary Table** — feature area | source files | test files | status (✅⚠️❌) | risk level
2. **Test Quality Score** — per-file assessment of assertion quality, edge cases, error paths
3. **Critical Gaps** — highest-risk untested business logic with specific file:line references
4. **Missing Test Suggestions** — for each gap, describe the specific test scenarios that should be written (scenario name + what to assert)
5. **Test Infrastructure Improvements** — fakes, factories, helpers that would unblock better testing
6. **Positive Patterns** — what the test suite does well that should be maintained

---

## Agent 7 — .NET 10 & C# 14 Modernization (Platform Engineer)

You are a .NET platform engineer reviewing an ASP.NET Core Razor Pages application targeting .NET 10 / C# 14 to identify missed modernization opportunities.

The app targets .NET 10 with C# 14. Review the entire codebase for places where older patterns are used when .NET 10 / C# 14 provides a better alternative. Only flag changes that improve **readability, performance, correctness, or security** — skip cosmetic-only modernizations.

### C# 14 Language Features

- **`field` keyword** — search for properties with manual backing fields where the only reason for the backing field is simple validation/transformation in the setter. These can use `field` keyword instead: `public string Name { get; set => field = value?.Trim(); }`
- **Extension types** — look for static extension method classes that could benefit from `implicit extension` blocks (especially if they would benefit from extension properties, not just methods)
- **Unbound generic types in `nameof`** — find `nameof(SomeType<object>)` or similar workarounds that can become `nameof(SomeType<>)`
- **`params ReadOnlySpan<T>`** — check if any custom methods accept `params T[]` in hot paths where `params ReadOnlySpan<T>` would eliminate allocations
- **`\e` escape sequence** — find `\x1B` or `(char)0x1B` patterns that should use `\e`
- **`allows ref struct`** — check if any generic utility methods could benefit from accepting `Span<T>` via the anti-constraint

### ASP.NET Core 10

- **`HybridCache`** — check if the app uses manual `IMemoryCache` + `IDistributedCache` coordination or custom stampede-prevention logic that `HybridCache` would replace
- **`MapStaticAssets()`** — check if static files are served with `UseStaticFiles()` instead of the new fingerprinted `MapStaticAssets()` which provides automatic content-hash cache busting
- **Request timeout middleware** — check for custom `CancellationToken` timeout wrappers on external API calls that could use per-endpoint `RequestTimeoutOptions` instead
- **Built-in OpenAPI** — check if Swashbuckle/NSwag is used when `Microsoft.AspNetCore.OpenApi` with `MapOpenApi()` would suffice
- **Rate limiting middleware** — check API endpoints for missing rate limiting that could use the built-in `RateLimiter` middleware with sliding window / token bucket policies
- **Static asset tag helpers** — check for manual `asp-append-version="true"` that `MapStaticAssets()` would make unnecessary
- **Authentication defaults** — check if auth configuration uses verbose patterns that ASP.NET Core 10 simplified (e.g., `AuthorizationBuilder` fluent API)

### EF Core 10

- **`ExecuteUpdateAsync` / `ExecuteDeleteAsync`** — find update-then-save or delete-by-loop patterns that could use bulk operations
- **Improved `GroupBy` translation** — find `GroupBy` queries that force client evaluation where EF Core 10 may now translate them to SQL
- **JSON column queries** — if any entities store semi-structured data, check whether JSON column support could simplify the model
- **Compiled models** — for cold-start optimization on Azure App Service, check if compiled EF models would help
- **Select projections** — find queries loading full entities where `.Select()` projections would be more efficient (overlaps with Agent 3 but review from a "does EF Core 10 enable this better now?" angle)

### .NET 10 Runtime / BCL

- **`System.Threading.Lock`** — search for `lock (someObject)` on plain `object` fields; these should use the dedicated `System.Threading.Lock` type for type safety and tooling
- **`System.Text.Json` improvements** — find custom `JsonConverter` implementations for `DateOnly`/`TimeOnly` that are now built-in; find manually cached `JsonSerializerOptions` that can use the thread-safe `JsonSerializerOptions.Default`
- **`TimeProvider`** — find `DateTime.Now`, `DateTime.UtcNow`, `DateTimeOffset.UtcNow` usage in services/calculators; these should inject `TimeProvider` for testability
- **`SearchValues<string>`** — find multi-pattern string matching (multiple `Contains` calls, switch over string prefixes) that could use `SearchValues<string>` for efficiency
- **Zero-alloc string splitting** — find `string.Split()` in hot paths (parsing loops, CSV processing, API response handling) where `Span<T>`-based splitting via `MemoryExtensions` would eliminate allocations
- **`params ReadOnlySpan<T>` in BCL** — check if logging or formatting calls could benefit from the new zero-alloc overloads

### Configuration & DI

- **Recursive options validation** — check if `ValidateDataAnnotations()` is used on options with nested objects; .NET 10 validates recursively so custom `IValidateOptions<T>` for nested validation may be removable
- **Keyed services** — find factory patterns or named service registrations that resolve multiple implementations of the same interface; these could use `[FromKeyedServices("name")]`
- **`IHostedLifecycleService`** — check if any `IHostedService` implementations manually track lifecycle phases (starting, started, stopping) that the new interface handles natively

### Security

- **HSTS configuration** — verify HSTS is configured with appropriate `max-age` and that `UseHttpsRedirection` works correctly behind Azure App Service's load balancer
- **Anti-forgery enforcement** — check if antiforgery is globally enforced or if individual pages could opt-out accidentally
- **Rate limiting on API endpoints** — any `/api/` endpoints without rate limiting should be flagged (overlaps with above but from a security perspective)

### Output Format

For each finding:
1. **Category**: C# 14 | ASP.NET Core 10 | EF Core 10 | Runtime/BCL | Config/DI | Security
2. **Severity**: WARNING (tangible improvement) or NOTE (nice-to-have cleanup)
3. **File:line** reference
4. **Current pattern** — what the code does now (brief snippet)
5. **Modern pattern** — what it should look like with .NET 10 / C# 14 (brief snippet)
6. **Why** — the concrete benefit (perf, readability, correctness, security)

End with a summary: estimated modernization effort (small/medium/large per category) and which changes have the highest value-to-effort ratio.

---

## Agent 8 — Performance & Speed (Performance Engineer)

You are a senior performance engineer reviewing an ASP.NET Core Razor Pages application hosted on an Azure App Service B1 plan. Every wasted millisecond and allocation matters at this tier.

### Request Pipeline & Async Patterns

- Find sequential `await` calls in PageModel handlers (OnGet/OnPost) that could run concurrently with `Task.WhenAll` — e.g., multiple independent API/DB calls awaited one after another
- Check for blocking calls on async code: `.Result`, `.Wait()`, `.GetAwaiter().GetResult()` — these waste threadpool threads and risk deadlocks
- Look for `async` methods that contain no `await` (unnecessary state machine overhead)
- Check middleware ordering — is authentication/authorization running before static file serving?

### Caching Strategy

- Evaluate session-based caching (TimesheetCache, DashboardCache): are TTLs appropriate? Is there over-fetching on cache miss?
- Look for repeated identical API/DB calls within a single request that should be cached or deduplicated
- Check for cache stampede risk — multiple concurrent requests triggering the same expensive recomputation
- Identify data that's fetched per-request but rarely changes (settings, department lists, activity configs) — should these be cached longer?

### Memory & Allocations

- Find string concatenation in loops — should use `StringBuilder` or `string.Join`
- Look for LINQ chains that materialize intermediate collections unnecessarily (`.ToList()` mid-chain, multiple enumerations of the same `IEnumerable`)
- Check for large object allocations: big `List<T>` or `byte[]` that could use pooling (`ArrayPool<T>`) or streaming
- Find boxing in hot paths: value types passed to `object` parameters, dictionary lookups with value-type keys without proper comparer
- Look for closure allocations in frequently-called lambdas (LINQ in loops, event handlers)

### Database & Query Performance

- Identify queries missing indexes based on WHERE/ORDER BY clauses used in the code
- Find full-entity loads (`ToListAsync()` on the entity) where a `.Select()` projection returning only needed fields would reduce data transfer
- Check for `SaveChangesAsync` called inside loops instead of batching
- Look for queries that fetch all rows when only aggregate values are needed (count, sum, exists)

### HTTP Client & External API Efficiency

- Check HttpClient usage — is `IHttpClientFactory` used everywhere? Any `new HttpClient()` anti-patterns?
- Look for external API calls that fetch more data than needed (missing query parameters to filter server-side)
- Check for missing response streaming on large payloads — are entire responses buffered into memory?
- Verify connection pooling settings — DNS refresh interval, max connections per server

### Frontend & Response Size

- Check for oversized ViewData/Model payloads sent to Razor views — data that's serialized to the page but never used client-side
- Look for inline JavaScript/CSS that should be in external cached files
- Check for missing response compression (gzip/brotli) on text responses
- Verify static assets have proper cache headers (via `MapStaticAssets()` or `Cache-Control`)
- Look for synchronous rendering bottlenecks in partial views that could use `<partial>` tag helper async rendering

### Compute-Heavy Operations

- Profile salary calculation paths: are there redundant recalculations, avoidable iterations, or O(n²) patterns?
- Check date/time calculations in loops — are `NorwegianBusinessDay` or holiday lookups repeated for the same dates?
- Look for repeated reflection or expression compilation that could be cached
- Find sorting or searching on large collections that could use more efficient data structures (`Dictionary`, `HashSet`, `SortedList`)

### Output Format

For each finding:
1. **Severity**: CRITICAL (measurable user-facing latency or OOM risk) | WARNING (unnecessary waste, will compound) | NOTE (minor optimization)
2. **Category**: Async | Caching | Memory | Database | HTTP | Frontend | Compute
3. **File:line** reference
4. **Current pattern** — what the code does now (brief)
5. **Optimized pattern** — concrete fix with code snippet
6. **Expected impact** — qualitative estimate (e.g., "eliminates ~200ms sequential wait", "avoids 50KB allocation per request")

End with a summary: top 5 highest-impact optimizations ranked by effort-to-impact ratio.

---

## Synthesis (after all agents complete)

After ALL 8 agents have returned results, compile into this structure:

### Critical Issues (must fix before next deploy)
Security vulnerabilities, data corruption risks, correctness bugs in financial calculations

### High Priority (fix this sprint)
Performance problems, resilience gaps, significant code quality issues

### Medium Priority (fix this quarter)
Architecture improvements, test coverage gaps, maintainability concerns

### Modernization Opportunities (.NET 10 / C# 14)
Group by effort level (small/medium/large) — highest value-to-effort ratio items first

### Positive Observations
What's done well — patterns worth keeping, good practices to reinforce

For EVERY finding include: **file path:line**, **description**, and a **concrete fix suggestion** (not just "consider improving").

End with a 1-paragraph executive summary suitable for a tech lead.
