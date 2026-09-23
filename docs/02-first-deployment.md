# 2. Read, plan, apply, and change your first resources

[Lab home](../README.md) | Previous: [setup](01-setup.md) | Next: [cleanup](04-cleanup.md)

**Start:** the folder containing [the basic configuration](../examples/01-basic/main.tf), with setup completed and inputs saved. Run one block at a time. **Do not continue after an error.**

In a new terminal, right-click **examples > 01-basic > Open in Integrated Terminal** in VS Code's Explorer. For resources you already deployed, follow [resume an existing lab](resume.md) first; never initialize a replacement state to hide a missing-state error.

## A. Understand the small project

| File | Plain-English meaning |
| --- | --- |
| [versions.tf](../examples/01-basic/versions.tf) | Which Terraform/provider versions and Azure subscription to use |
| [variables.tf](../examples/01-basic/variables.tf) | Questions the configuration asks you: names, subscription, region |
| [main.tf](../examples/01-basic/main.tf) | Desired resources and their settings |
| [outputs.tf](../examples/01-basic/outputs.tf) | Useful results to display, such as the website URL |
| [terraform.tfvars.example](../examples/01-basic/terraform.tfvars.example) | A template for your local answers |

Read [the commented resource definitions](../examples/01-basic/main.tf). `data` reads your existing group; `resource` manages an object; `var` reads your inputs. Terraform reads the folder's configuration together. References determine order: the app needs its plan first. The empty VNet and storage remain separate from the app.

## B. Initialize

```powershell
terraform init -lockfile=readonly
```

**Expected:** `Terraform has been successfully initialized!`. This downloads checksum-verified plugins selected by the supplied lock file. It can take a few minutes. **Azure change: none.** Do not add `-upgrade` or ignore checksum errors.

## C. Format and validate

```powershell
. {
	$ErrorActionPreference = "Stop"
	terraform fmt
	if ($LASTEXITCODE -ne 0) { throw "Formatting failed. Stop here." }
	terraform validate
}
```

**Expected:** `fmt` prints changed filenames, or nothing if already formatted; validation prints `Success! The configuration is valid.` **Azure change: none.** Valid syntax does not prove quota, permissions, or name availability.

Optional safe test:

```powershell
terraform test
```

**Expected:** `Success! 2 passed, 0 failed.` These supplied tests use fake provider responses, not Azure. Tests in other projects can deploy resources; only run tests you have reviewed.

## D. Plan: look before changing anything

```powershell
terraform plan "-out=first.tfplan"
```

**Expected on a fresh example:** `Plan: 4 to add, 0 to change, 0 to destroy.` Terraform reads Azure using your CLI sign-in and saves a local proposal. **No workload is created yet.** The four additions are VNet, storage, plan and app; the group is only read. `(known after apply)` means Azure supplies that value later.

| Symbol | Meaning | Should you stop? |
| --- | --- | --- |
| `+` | Create | Check the name, group, region, SKU |
| `~` | Update in place | Read exactly which settings change |
| `-` | Delete | Stop unless you deliberately requested cleanup |
| `-/+` or `+/-` | Replace | Stop and understand the data-loss/downtime risk |

Review that **all** resources target your group, region is Japan East, storage is Standard/LRS, and plan is **F1**. No extra services should appear. Do not approve an unexpected plan.

```powershell
terraform show .\first.tfplan
```

**Expected:** the same four-resource proposal, displayed again without changing Azure. Keep plans/state local; they may contain sensitive data. **If you edit inputs or source afterward, generate and review a new plan**; a saved plan still contains the earlier decisions.

The quotes around the full `-out=first.tfplan` argument are deliberate: Windows PowerShell 5.1 can split an unquoted attached filename argument incorrectly.

## E. Apply: create the real resources

> **This next command changes Azure immediately. A saved plan does not ask for another `yes`.** Read it first and run it only when you intend to create the four resources.

```powershell
terraform apply .\first.tfplan
```

**Expected after a successful fresh deployment:** `Apply complete! Resources: 4 added, 0 changed, 0 destroyed.` It may take several minutes. **Azure change: creates four resources**, recording their IDs in local state; it does not create or delete your group.

**If apply fails:** stop, keep the input/state files, and record the first error. Some resources may already exist. Ask the instructor to reconcile state and Azure before [cleanup](04-cleanup.md). Never choose a paid SKU to make the run green.

## F. Verify the result

```powershell
. {
	$ErrorActionPreference = "Stop"
	terraform output
	if ($LASTEXITCODE -ne 0) { throw "Cannot read deployment outputs. Stop." }
	terraform state list
}
```

**Expected:** outputs include `resource_group_name` and `web_app_url`; state lists four managed resources plus the group data source. **Azure change: none.** State is Terraform's ownership record, not a backup of storage contents.

```powershell
. {
	$ErrorActionPreference = "Stop"
	$rg = terraform output -raw resource_group_name
	if ($LASTEXITCODE -ne 0) { throw "Cannot read the group name. Stop." }
	az resource list --resource-group $rg --query "[].{Name:name,Type:type,Location:location}" --output table
}
```

**Expected:** four resource rows in Japan East. This checks Azure, not just saved state. If policy adds objects, ask the instructor about ownership; do not delete them blindly.

```powershell
. {
	$ErrorActionPreference = "Stop"
	$url = terraform output -raw web_app_url
	if ($LASTEXITCODE -ne 0) { throw "No verified web app output. Check whether apply completed." }
	Start-Process $url
}
```

**Expected:** Azure's default welcome page over HTTPS. No custom app was uploaded. You can also click **Azure Portal > Resource groups > your group > your App Service > Overview > Browse**. Initial startup/idling can delay the page; a missing app after a failed apply is **not** a startup delay.

## G. Run a no-change plan

```powershell
terraform plan
```

**Expected:** `No changes. Your infrastructure matches the configuration.` Terraform reads Azure without making another copy. This is **idempotence**: repeating the same configuration needs no change. Investigate unexpected differences before continuing.

## H. Make one small change

1. In [main.tf](../examples/01-basic/main.tf), change the `lesson` tag from `first-deployment` to `tag-update`.
2. Save. Do **not** change names, location, address space, or F1.

```powershell
. {
	$ErrorActionPreference = "Stop"
	terraform fmt
	if ($LASTEXITCODE -ne 0) { throw "Formatting failed. Stop here." }
	terraform validate
	if ($LASTEXITCODE -ne 0) { throw "Validation failed. Do not plan or apply." }
	terraform plan "-out=tag-update.tfplan"
}
```

**Expected:** in-place tag updates on the four resources, not replacements. No Azure change has happened yet. A new filename prevents accidentally reusing the first plan. Stop if any command failed.

```powershell
terraform apply .\tag-update.tfplan
```

**Expected:** successful apply of the reviewed tag changes. **Azure change: updates tags.** Check **Azure Portal > Resource groups > your group > a resource > Tags**: `lesson` should be `tag-update`.

```powershell
terraform plan
```

**Expected:** `No changes.` If not, read the difference; do not apply it automatically.

**Checkpoint:** explain why changing a tag normally differs from changing a resource name. Then [destroy this deployment](04-cleanup.md) before trying AVM.
