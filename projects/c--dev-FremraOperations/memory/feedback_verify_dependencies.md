---
name: Verify dependencies before recommending removal
description: Always check what references a resource before suggesting it be deleted — especially cloud credentials, secrets, and infrastructure
type: feedback
---

Before recommending removal of any credential, secret, OIDC federated credential, or infrastructure resource, verify that nothing references it (workflows, CI/CD, other services).

**Why:** Recommended removing "unused" OIDC federated credentials, but one was actively used by the GitHub Actions deploy workflow. This broke production deployment.

**How to apply:** When auditing resources for cleanup, grep the codebase (including `.github/workflows/`, IaC, and config files) for references to each resource before suggesting removal. If in doubt, flag it as "possibly unused — verify before removing" rather than stating it's unused.
