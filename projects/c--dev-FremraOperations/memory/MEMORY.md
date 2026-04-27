# Memory Index

- [feedback_autonomous_work.md](feedback_autonomous_work.md) — User expects Claude to handle grunt work (killing processes, restarting apps) autonomously
- [feedback_verify_dependencies.md](feedback_verify_dependencies.md) — Always verify what references a resource before recommending removal (burned by OIDC deletion breaking CI)
- [reference_azure_oidc.md](reference_azure_oidc.md) — Active OIDC identity for GitHub Actions deployment (oidc-msi-aa9b)
- [feedback_no_git_reset.md](feedback_no_git_reset.md) — Never reset/rewrite git history without explicit permission, even for local commits
- [feedback_no_git_restore.md](feedback_no_git_restore.md) — Never git restore unstaged changes; stash first, ask before discarding
- [feedback_run_tests_before_commit.md](feedback_run_tests_before_commit.md) — Always run dotnet test before committing, never commit broken tests
- [feedback_plan_detail.md](feedback_plan_detail.md) — Write plans as self-contained documents that work in a new session without conversation history
- [feedback_skip_design_doc_for_scripts.md](feedback_skip_design_doc_for_scripts.md) — Skip formal design doc for one-shot SQL seed scripts and similar throwaway work
- [feedback_skip_trivial_tests.md](feedback_skip_trivial_tests.md) — Don't write tests for trivially simple code like webhook notifiers
- [feedback_employee_start_date.md](feedback_employee_start_date.md) — Always account for Employee.StartDate in date-range calculations

- [feedback_no_worktree_refactors.md](feedback_no_worktree_refactors.md) — Don't use worktree agents for interconnected refactors; implement sequentially
- [project_azure_sql_migration.md](project_azure_sql_migration.md) — Database migrated from SQLite to Azure SQL; don't reference SQLite
- [reference_dev_tools.md](reference_dev_tools.md) — Installed CLI tools (dotnet, az, gh, sqlcmd) and Azure SQL connection details
- [feedback_sqlcmd_path.md](feedback_sqlcmd_path.md) — Call sqlcmd directly; don't use the full path since it's on PATH
- [feedback_no_maxlength.md](feedback_no_maxlength.md) — Never add HasMaxLength to EF Core string properties; use nvarchar(max)
- [feedback_never_run_app.md](feedback_never_run_app.md) — Never start the FremraOperations web app; the user runs it themselves
- [feedback_no_time_estimates.md](feedback_no_time_estimates.md) — Never give time/duration estimates; argue approaches on risk/blast radius/reviewability instead
- [reference_maestro.md](reference_maestro.md) — Maestro is the accounting software used by Fremra's economics dept; possible future integration target
- [project_sql_always_on.md](project_sql_always_on.md) — SQL DB auto-pause is intentionally disabled (cold-start exceptions); suggest fixed DTU tier instead for cost cuts
- [feedback_no_unnecessary_cd.md](feedback_no_unnecessary_cd.md) — Never use `cd` (denied in settings.json); Bash cwd is already correct. Avoid `&&` chains too.
- [feedback_no_framework_grep.md](feedback_no_framework_grep.md) — Don't grep `C:\Program Files\dotnet\` or `.nuget\packages\` to resolve API/namespace questions; use known conventions or official docs
- [feedback_no_over_branching.md](feedback_no_over_branching.md) — Regular commits go to dev; feature/* only for major work; main is production; no PRs ever
- [feedback_dev_to_main.md](feedback_dev_to_main.md) — "take dev to main" means fast-forward main to dev cleanly — no merge commit, no PR
- [feedback_no_python_probing.md](feedback_no_python_probing.md) — Don't probe for Python or suggest paths that depend on it. Node.js IS now installed and available.
- [feedback_user_secret_naming.md](feedback_user_secret_naming.md) — User secret keys use UPPERCASE_SNAKE_CASE; multi-company apps prefix with Norwegian orgnum (e.g., "919638095:TRIPLETEX_SESSION_TOKEN")
- [feedback_no_scratch_projects_outside_repo.md](feedback_no_scratch_projects_outside_repo.md) — Never create throwaway projects under /tmp/AppData\Local\Temp; each file op triggers a permission prompt. Use existing test project or skip the check
- [reference_tmp_scratch_folder.md](reference_tmp_scratch_folder.md) — Use `.tmp/` inside the repo (gitignored) for any throwaway scratch work