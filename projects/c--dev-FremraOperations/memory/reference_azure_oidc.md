---
name: Azure OIDC for GitHub Actions deployment
description: Active OIDC managed identity for GitHub Actions CI/CD deployment to Azure App Service
type: reference
---

Current OIDC identity: `oidc-msi-aa9b` (created 2026-03-24 via Deployment Center)

Old identity `fremra-operations-deploy` (created same day via CLI) should be deleted — it was never fully set up (role assignment failed).

Previous app registration (unknown name/ID) was deleted on 2026-03-21, breaking CI. Recreated via Deployment Center.

Azure Portal: fremra-operations → Deployment Center manages the GitHub connection.
