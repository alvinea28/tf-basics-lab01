# 3. Build a module with Copilot, then use AVM

[Lab home](../README.md) | [Cleanup](04-cleanup.md)

**Start:** basic cleanup A-D is complete; your group is empty. Keep its inputs and state in place. This exercise creates a separate deployment, **not** a state migration.

## A. Ask Copilot to explain, not execute

1. Open [the basic example](../examples/01-basic/main.tf) in VS Code.
2. Click **Chat/Copilot**. Select **Ask** in the mode menu, not Agent.
3. Click **Add Context > Files** (or the paperclip), choose that file, and paste the prompt below. Do not approve terminal execution.

> Explain this Terraform to a first-time learner. For each block, distinguish local configuration, an Azure lookup, and a managed Azure resource. Explain why the web app depends on its F1 plan, but is NOT connected to the VNet or storage. Do not edit files or run commands.

**Expected:** an explanation, not a deployment. Check that it identifies **four** managed resources and the pre-existing resource group. If it proposes a VM, paid plan, VNet integration, or monitoring, reject that suggestion.

## B. Build a small local module yourself

A **module** is a folder of Terraform files with inputs and outputs. A root module is the folder where you run Terraform. A child module is called by another module.

Return to the lab root using the value recorded during setup. If you closed the terminal, open the **original lab root** with **File > Open Folder > Terminal > New Terminal**, then restore the folder value:

```powershell
. {
	if (-not (Test-Path .\examples\01-basic\main.tf)) { throw "Open the original lab01 root first." }
	$labRoot = (Get-Location).Path
	Write-Output $labRoot
}
```

**Expected:** the original lab folder path, not an example folder. **Azure change: none.**

```powershell
. {
	$ErrorActionPreference = "Stop"
	Set-Location $labRoot -ErrorAction Stop
	New-Item -ItemType Directory -Path .\practice\network-module -Force -ErrorAction Stop
}
```

**What happens:** you create a local scratch directory. The lab ignores practice work in Git. Nothing happens in Azure.

In Chat, choose **Edit** if available, or request proposed file edits in Agent mode with terminal approvals kept manual. Paste this prompt; accept only the listed scratch-folder edits:

> Create a beginner-friendly local Terraform child module in practice/network-module. Use hashicorp/azurerm 5.6.0 and Terraform >=1.16.3,<2.0.0. Inputs: name (string), resource_group_name (string), location (string, default japaneast, validation allowing ONLY japaneast), address_space (list(string), default ["10.10.0.0/16"]), tags (map(string), default {}). Manage exactly ONE azurerm_virtual_network called this. Outputs: resource_id and name. No provider configuration inside the child module: inherit it from the caller. Do not create a resource group, subnet, gateway, VM, peering, identity, diagnostics, or DDoS plan. Add short comments. Do not run init, plan, apply, destroy, or Azure CLI commands; explain your changes first.

Review the diff, click **Keep/Accept** only for the intended scratch files, and save. Compare with the supplied answers: [variables](../solutions/network-module/variables.tf), [resource](../solutions/network-module/main.tf), [outputs](../solutions/network-module/outputs.tf), and [provider requirement](../solutions/network-module/versions.tf). Without Copilot: in Explorer, expand **solutions > network-module**, Ctrl-click those four files > **Copy**, then right-click **practice > network-module > Paste**. Do not copy its cache or state; do not overwrite existing practice work without reviewing it.

```powershell
. {
	$ErrorActionPreference = "Stop"
	terraform -chdir=practice/network-module init -backend=false
	if ($LASTEXITCODE -ne 0) { throw "Initialization failed. Stop here." }
	terraform -chdir=practice/network-module fmt
	if ($LASTEXITCODE -ne 0) { throw "Formatting failed. Stop here." }
	terraform -chdir=practice/network-module validate
}
```

**Expected:** successful initialization, formatted code and `Success! The configuration is valid.` `-chdir` selects a folder for that command only. **Azure change: none; no credentials needed.**

If validation fails, share only the error and relevant **source code** with Copilot:

> Explain this validation error simply. Suggest the smallest fix without adding services, changing Japan East, or running commands. Do not request credentials or state.

**Do not replace a live resource with this module.** That changes its Terraform address and can propose deletion/recreation. Keeping a live object requires a reviewed state migration. This practice only validates a module; it does not deploy it.

## C. Understand Azure Verified Modules

**AVM** is Microsoft's published library of reusable modules. You still use Terraform's normal `init`, `plan`, `apply`, and `destroy` commands. A Copilot-generated module or your own wrapper is **not** automatically an Azure Verified Module.

Open [the AVM example](../examples/02-avm/main.tf). It requests the same four top-level Azure objects, now through:

| Module | Pinned release | Important override |
| --- | --- | --- |
| `Azure/avm-res-network-virtualnetwork/azurerm` | `0.22.2` | Empty VNet, no optional networking |
| `Azure/avm-res-storage-storageaccount/azurerm` | `0.10.0` | `account_sku_name = "Standard_LRS"`, keyless, public data access off |
| `Azure/avm-res-web-serverfarm/azurerm` | `2.0.8` | `sku_name = "F1"`, no zone balancing, no explicit worker count |
| `Azure/avm-res-web-site/azurerm` | `0.23.0` | Windows, Always On off, 32-bit worker, basic publishing auth off |

These releases use **AzAPI**, despite `/azurerm` in the registry address. [The provider declarations](../examples/02-avm/versions.tf) identify the plugins. Extra plugin dependencies do not mean extra Azure services; telemetry is disabled.

> **AVM defaults are not always beginner/free-tier defaults.** The plan module defaults to a paid SKU, multiple workers, and zone balancing. The site module defaults to Always On. Our explicit overrides matter; never remove them merely to shorten code.

Ask Copilot:

> Compare the basic root with the pinned AVM root. Explain every module input in short sentences. Verify the EXACT published versions' interfaces rather than guessing from latest examples. Identify all settings that keep Windows App Service on F1 and all optional services left disabled. Do not modify or deploy anything.

## D. Run the AVM example

In the same terminal, copy **inputs only**, once. If the destination already exists, open and verify it instead of overwriting:

```powershell
. {
	$ErrorActionPreference = "Stop"
	Set-Location (Join-Path $labRoot "examples\02-avm") -ErrorAction Stop
	if (Test-Path .\terraform.tfvars) { throw "AVM inputs already exist. Check them instead of overwriting." }
	Copy-Item ..\01-basic\terraform.tfvars .\terraform.tfvars -ErrorAction Stop
}
```

**Expected:** no output; the copied inputs appear beside [the AVM template](../examples/02-avm/terraform.tfvars.example). State was not copied. **Azure change: none.**

```powershell
. {
	$ErrorActionPreference = "Stop"
	terraform init -lockfile=readonly
	if ($LASTEXITCODE -ne 0) { throw "Initialization failed. Stop here." }
	terraform validate
	if ($LASTEXITCODE -ne 0) { throw "Validation failed. Stop here." }
	terraform test
}
```

**Expected:** initialized, valid configuration, then `Success! 2 passed, 0 failed.` Downloads can take several minutes. **Azure change: none.**

```powershell
terraform plan "-out=avm.tfplan"
```

**Expected on a fresh example:** `Plan: 10 to add, 0 to change, 0 to destroy.` These are **four top-level Azure resources** plus six web-app configuration/policy instances, not ten paid services. **No workload changes yet.**

AVM names contain **tf01avm**. Review your group, `japaneast`, `F1` and every child action. Stop on another SKU, replacements or extra services. Replan after any source/input edit.

> Applying a saved plan changes Azure immediately, with no additional `yes` prompt.

```powershell
terraform apply .\avm.tfplan
```

**Expected after successful creation:** `Apply complete! Resources: 10 added, 0 changed, 0 destroyed.` **Azure change: creates the four resources and applies their child settings.** On failure, keep state and follow cleanup with the instructor; AVM cannot bypass quota or policy.

```powershell
. {
	$ErrorActionPreference = "Stop"
	terraform output
	if ($LASTEXITCODE -ne 0) { throw "Cannot read outputs. Check whether apply completed." }
	terraform plan
}
```

**Expected:** names/HTTPS URL, followed by `No changes.` Open the URL, and check **Azure Portal > Resource groups > your group** shows four top-level resources in Japan East. The app should show its default welcome page. These are read-only verification steps.

**Checkpoint:** explain a local module versus a registry module; identify why AVM needs explicit cost controls. Then [clean up the AVM example and your empty group](04-cleanup.md).
