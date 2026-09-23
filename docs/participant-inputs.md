# Exactly what each participant must enter

[Lab home](../README.md) | [Return to setup](01-setup.md)

Use this checklist while following the setup guide. It does not replace Azure sign-in or group creation.

## 1. Understand the three places values appear

| Place | Example | What to type |
| --- | --- | --- |
| PowerShell prompt from `Read-Host` | `Paste your sandbox subscription ID:` | Your actual ID **without quotation marks** |
| PowerShell variable | `$subscriptionId`, `$rg`, `$suffix` | These hold values for the current terminal session; they are not Terraform inputs by themselves |
| Terraform local input file | `subscription_id = "..."` | The actual value **inside quotation marks**, not the text `$subscriptionId` |

GitHub/Copilot sign-in and Azure sign-in are separate. Terraform uses your Azure CLI sign-in; adding an ID to a file does not authenticate you.

## 2. Find or generate your values

| Input | Where you get the value | Example shape only |
| --- | --- | --- |
| `subscription_id` | Azure Portal > Subscriptions > your sandbox > Overview > **Subscription ID**; or `az account show --query id --output tsv` after selecting it | A GUID such as `11111111-2222-3333-4444-555555555555` |
| `resource_group_name` | Your group created in setup section D; copy the printed value of `$rg` | `rg-tf-basics-lab01-a1b2c3d4` |
| `name_suffix` | Setup generates it once using a GUID; copy the printed value of `$suffix` | `a1b2c3d4` |
| `owner` | Choose a non-sensitive nickname | `learner07` |
| `location` | Provided by the workshop | **Keep `japaneast`** |

The examples above are not a real subscription or reserved names. **Do not deploy with them.** Each participant uses their own authorized values. A group must already exist; Terraform reads it rather than creates it. A suffix must be 6-12 lowercase letters/digits and helps make the storage/web app names globally unique.

## 3. Edit the local input copy

In the basic example folder, follow setup section E to copy [terraform.tfvars.example](../examples/01-basic/terraform.tfvars.example) to the local input file and open it. Edit the **copy**, not the supplied template. On repeat visits, open your existing copy rather than overwrite it.

In VS Code's Explorer, expand the basic example folder, click the local input copy, and edit the values. **Read-only illustration, not a block to deploy:** these values are deliberately fake.

```hcl
subscription_id     = "11111111-2222-3333-4444-555555555555"
resource_group_name = "rg-tf-basics-lab01-a1b2c3d4"
name_suffix         = "a1b2c3d4"
location            = "japaneast"
owner               = "learner07"
```

Replace the first three values and optionally the nickname with **your** values. Keep the field names, equals signs, and quotes. Save with **Ctrl+S**. Terraform automatically loads the local input file when you run commands from that example folder.

Do **not** change [versions.tf](../examples/01-basic/versions.tf) to paste your subscription there. It already reads `var.subscription_id`. Do not replace references such as `var.name_suffix` in [main.tf](../examples/01-basic/main.tf) with your personal values.

## 4. Check before your first plan

- [ ] `az account show` names the intended sandbox subscription.
- [ ] The input file's subscription ID matches that account selection.
- [ ] The resource group exists in that subscription, is yours, and is empty.
- [ ] The suffix matches the one recorded during setup; no `replaceme` remains.
- [ ] Location remains `japaneast`; the plan SKU in the supplied code remains **F1**.
- [ ] You did not add a password, token, storage key, client secret, or connection string.
- [ ] The input file is saved in the **basic example's folder**, not the lab root or the AVM folder.

**Expected:** the saved file contains five quoted values, and each checkbox is true. The local inputs are ignored by Git. Never paste state/plan files into Copilot to troubleshoot inputs.

## 5. Reuse values correctly in the AVM exercise

First destroy the basic workload. Then follow [the AVM guide](03-copilot-and-avm.md) to copy **only the local input file** into the AVM example folder. Use the same authorized subscription and still-existing group; do not copy state or the provider cache. AVM uses separate resource names and state.

After any deployment, changing `name_suffix` or `resource_group_name` can cause replacements. Do not generate a fresh suffix every time you run a command. Restore your recorded values when opening another terminal; keep state until cleanup is confirmed.
