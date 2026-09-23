# 1. Set up your tools and your Azure sandbox

[Lab home](../README.md) | Next: [first deployment](02-first-deployment.md)

**Start:** your own lab01 folder, in the VS Code **PowerShell** terminal. Copy one block at a time; stop on errors. `$name` is a terminal variable, not a value to paste into a form.

## A. Open the lab and install tools

Follow [the click-by-click tool setup](tool-setup.md), then check the starting folder:

```powershell
. {
	$ErrorActionPreference = "Stop"
	Get-Location
	if (-not (Test-Path .\examples\01-basic\main.tf)) { throw "Open the lab01 root folder first." }
	$labRoot = (Get-Location).Path
}
```

**Expected:** your lab folder path and no error. `$labRoot` remembers it for later steps in this terminal. **Azure change: none.**

## B. Sign in without copying credentials

```powershell
az login --output none
```

**Expected:** a Microsoft account window or browser opens. Sign in and complete MFA; select the permitted tenant/subscription if prompted. Return here when the PowerShell prompt returns. This authorizes Azure CLI, not GitHub/Copilot; no resources are created.

List the subscriptions you can access:

```powershell
az account list --query "[].{Name:name,Id:id,State:state}" --output table
```

**Expected:** a table. Choose the instructor-approved **Enabled** sandbox subscription, not production or a tenant-only entry. In [Azure Portal](https://portal.azure.com/), the same ID is under **Subscriptions > your sandbox > Overview > Subscription ID**.

```powershell
. {
	$ErrorActionPreference = "Stop"
	$subscriptionId = Read-Host "Paste your sandbox subscription ID"
	if ($subscriptionId -notmatch '^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$') {
		throw "Enter the subscription ID, not its display name. Do not include quotation marks or spaces."
	}
	az account set --subscription $subscriptionId
	if ($LASTEXITCODE -ne 0) { throw "Cannot select that subscription. Stop and check your access." }
	az account show --query "{Name:name,Subscription:id,Tenant:tenantId}" --output table
}
```

**Expected:** the table matches your chosen sandbox. This changes the CLI's selected subscription, not Azure resources. An ID identifies an account; it does not grant access.

If you have old `ARM_*` environment settings from another project, inspect **names only**:

```powershell
Get-ChildItem Env:ARM_* | Select-Object Name
```

**Expected:** normally no names. If names appear, ask the instructor to check for stale authentication settings before proceeding. Do not print their values or clear corporate settings indiscriminately.

## C. Check Japan East and required Azure services

```powershell
az appservice list-locations --sku F1 --output table
```

**Expected:** Japan East appears. This read-only list **does not prove Windows F1 quota or capacity**.

**Stop/go checkpoint:** ask the instructor to confirm at least one available Windows F1 plan for this subscription in Japan East and that its policies allow these resources. If quota is 0/unknown, stay with [local checks](verification.md). For an unresolved quota, the instructor can use **Azure Portal > Help + support > Create a support request > Service and subscription limits (quotas)** and describe **Windows App Service F1, Japan East**. Submitting a request is not approval. Do not switch region/SKU or upgrade a subscription as part of this lab.

```powershell
. {
	$ErrorActionPreference = "Stop"
	az provider show --namespace Microsoft.Network --query registrationState --output tsv
	if ($LASTEXITCODE -ne 0) { throw "Cannot check Network registration." }
	az provider show --namespace Microsoft.Storage --query registrationState --output tsv
	if ($LASTEXITCODE -ne 0) { throw "Cannot check Storage registration." }
	az provider show --namespace Microsoft.Web --query registrationState --output tsv
}
```

**Expected:** `Registered` for each namespace. A resource provider is Azure's API for a service family. Our Terraform providers do not automatically register services across your subscription.

If any is not Registered, an authorized administrator opens **Subscriptions > your sandbox > Resource providers**, searches that exact namespace, selects it, and clicks **Register**. Repeat only for missing namespaces, then rerun the check. Registration changes a subscription setting, not workload resources. Do not request subscription-wide Contributor just for this step.

## D. Create your own empty resource group

```powershell
. {
	$ErrorActionPreference = "Stop"
	$suffix = [guid]::NewGuid().ToString("N").Substring(0, 8)
	$rg = "rg-tf-basics-lab01-$suffix"
	$exists = az group exists --name $rg
	if ($LASTEXITCODE -ne 0) { throw "Cannot check group ownership. Stop." }
	if ($exists -ne "false") { throw "Group already exists. Choose a new suffix before creation." }
	Get-Variable subscriptionId, rg, suffix | Select-Object Name, Value
}
```

**Expected:** three non-secret values and no error. The eight-character suffix makes names less likely to collide. Keep this terminal open. **Azure change: none.** Do not regenerate the suffix after resources exist.

```powershell
az group create --name $rg --location japaneast --tags workshop=tf-basics-lab01 --output table
```

**Expected:** your group name and `japaneast` in the result. **Azure change: one empty resource group**, with no standalone usage charge. If forbidden, have an administrator create this exact dedicated group and grant you Contributor only there.

```powershell
az resource list --resource-group $rg --query "[].{Name:name,Type:type,Location:location}" --output table
```

**Expected:** no resource rows **and no error**. A failed read is not an empty group; investigate policy-created resources before continuing.

## E. Configure the basic example

In the same terminal, make the input copy **once**. On a repeat visit, open your existing inputs; do not overwrite them.

```powershell
. {
	$ErrorActionPreference = "Stop"
	Set-Location (Join-Path $labRoot "examples\01-basic") -ErrorAction Stop
	if (Test-Path .\terraform.tfvars) { throw "Inputs already exist. Open and check them; do not overwrite." }
	Copy-Item .\terraform.tfvars.example .\terraform.tfvars -ErrorAction Stop
}
```

**Expected:** a new local input copy beside [the template](../examples/01-basic/terraform.tfvars.example); no terminal output is normal. **Azure change: none.** In the Explorer, open that copy and fill the five fields using [the input checklist](participant-inputs.md). Keep quotes around values and press **Ctrl+S**.

Compare the saved non-secret inputs with your terminal values:

```powershell
. {
	$ErrorActionPreference = "Stop"
	Get-Content .\terraform.tfvars
	Get-Variable subscriptionId, rg, suffix | Select-Object Name, Value
}
```

**Expected:** subscription/group/suffix match; no all-zero ID, `replaceme`, or literal `$rg` remains; location is `japaneast`. Never add credentials. This ignored input file also preserves your values if you close the terminal.

**Checkpoint:** correct tools, approved quota/policy, your empty group, saved inputs. Continue to [first deployment](02-first-deployment.md).
