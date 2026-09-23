# Resume an existing deployment safely

[Lab home](../README.md) | [Deployment](02-first-deployment.md) | [Cleanup](04-cleanup.md)

Use this page after closing VS Code or opening a new terminal. **Open your original extracted lab copy**, not a fresh download. The original inputs and state identify resources that may still exist in Azure.

## 1. Open the correct example terminal

1. In VS Code, select **File > Open Folder** and open your original lab01 folder.
2. In Explorer, expand the examples folder. Right-click the **01-basic** folder for basic resources, or **02-avm** for AVM resources, then select **Open in Integrated Terminal**.
3. Confirm the terminal profile is **PowerShell**, then run:

```powershell
. {
  $ErrorActionPreference = "Stop"
  Get-Location
  if ((Split-Path (Get-Location).Path -Leaf) -notin @("01-basic", "02-avm")) { throw "Open the original example folder, not the lab root." }
  if (-not (Test-Path .\terraform.tfvars)) { throw "Original inputs are missing. Ask the instructor." }
  if (-not (Test-Path .\terraform.tfstate)) { throw "Original state is missing. Do not initialize a replacement or assume Azure is empty." }
  $labRoot = (Resolve-Path ..\.. -ErrorAction Stop).Path
  $stateWorkspace = terraform workspace show
  if ($LASTEXITCODE -ne 0 -or $stateWorkspace -ne "default") { throw "Cannot confirm the original default workspace. Stop." }
  Get-Content .\terraform.tfvars -ErrorAction Stop
}
```

**Expected:** the chosen example path and your five non-secret input values, with no error. **Azure change: none.** Missing state or a different workspace requires instructor recovery, not copying another example's state. If you have never deployed, return to normal setup instead.

## 2. Restore your recorded values and account

Copy the three values from the displayed inputs at the prompts. Do not generate a new suffix. Complete `az login` first if your CLI session has expired.

```powershell
. {
  $subscriptionId = Read-Host "Original subscription_id, without quotes"
  $rg = Read-Host "Original resource_group_name, without quotes"
  $suffix = Read-Host "Original name_suffix, without quotes"
  if ($suffix -notmatch '^[a-z0-9]{6,12}$' -or $rg -ne "rg-tf-basics-lab01-$suffix") { throw "Names do not match the original lab inputs. Stop." }
  az account set --subscription $subscriptionId
  if ($LASTEXITCODE -ne 0) { throw "Cannot select the original subscription. Stop." }
  az account show --query "{Name:name,Subscription:id}" --output table
  if ($LASTEXITCODE -ne 0) { throw "Cannot verify the selected account." }
}
```

**Expected:** the table's subscription matches the saved `subscription_id`; the recorded group/suffix match the same file. Selecting Azure CLI's account does **not** rewrite Terraform inputs. This changes CLI selection only, not resources.

Return to the step where you stopped. Do not overwrite inputs, copy state between examples, recreate the group, or regenerate names to make an error disappear.
