# Troubleshooting without guessing

[Lab home](../README.md)

First: save files, check `Get-Location`, read the **first** error, and stop before apply. Do not send credentials, raw state, saved plans, or whole debug logs to Copilot.

| Symptom | Likely cause | Safe next step |
| --- | --- | --- |
| Command not recognized | Tool missing or old terminal PATH | Install the official tool; restart terminal; check version |
| No Terraform configuration found | Wrong directory | Enter the intended example root |
| Missing required variable | Local inputs missing/unsaved | Compare with that root's input example; replace placeholders |
| Please run `az login` / expired token | Azure CLI login missing or stale | Sign in again in VS Code terminal; recheck subscription |
| Wrong subscription/tenant | Account selection or stale environment settings | Check `az account show` and the explicit subscription input; inspect environment names, not secret values |
| AuthorizationFailed creating group | You cannot create groups at subscription scope | Ask an administrator to create a dedicated group and grant workload rights only there |
| MissingSubscriptionRegistration | Network/Storage/Web not registered | Have the subscription administrator register only the required namespaces |
| ResourceGroupNotFound | Group was not created or wrong name/subscription | Read your recorded group values; do not have Copilot create a random replacement |
| Storage or web app name already used | Names are globally unique | Before first apply, choose a different suffix and make a new plan; after partial apply, clean up before renaming |
| F1 quota, capacity, or Japan East availability failure | Free plans are restricted by subscription/region | **Stop. Keep F1 and Japan East.** Instructor checks eligibility/quota; clean up partial resources |
| Always On / 64-bit / zone redundancy error | Free-tier-incompatible settings | Restore the supplied `always_on=false`, 32-bit worker, F1, and AVM zone/capacity overrides |
| Storage data browser returns 403 | Public storage data access is deliberately disabled | Expected. This lab manages an empty account through ARM, not blobs; do not enable public access or paste keys |
| Azure Policy denies the sample | Organizational requirements differ | Ask the policy owner for a suitable sandbox; do not bypass or weaken policy |
| Registry download/lockfile problem | Network proxy, checksum, or different provider constraints | Restore the supplied constraints and lock file; check trusted network access; never ignore checksum errors |
| AVM says unsupported argument | A copied example uses a different module release | Read the exact pinned version's inputs; note these releases use AzAPI |
| Plan wants replacement | Name/region/address changes or a module refactor | Do not apply until you understand and intend the replacement |
| Saved plan is stale | State changed since the plan was created | Generate and review a new plan; never reuse the stale one |
| Edited code but a saved plan still applies old settings | Saved plans contain the earlier inputs/configuration | After any source/input edit, create and review a new plan before applying; HCL edits alone do not invalidate the old file |
| Default website not ready | Startup delay, F1 idling/quota, or failed apply | Inspect app status in Azure Portal; no paid upgrade, custom DNS, or app deployment is needed |
| Destroy fails | Partial apply, Azure lock, permission, or external dependency | Keep state; resolve with instructor; rerun reviewed cleanup |

**When stuck:** provide the command, first error, Terraform/provider versions, and a small sanitized source snippet. Say which example you are using and whether apply partially succeeded. Never claim `validate` or a mock test proves a cloud deployment worked.
