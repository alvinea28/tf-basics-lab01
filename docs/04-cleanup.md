# 4. Destroy safely and verify cleanup

[Lab home](../README.md)

**Destroy means real deletion.** Any data you added to the storage account would be lost. Only use empty workshop resources. Do not delete state first: Terraform needs it to know what it owns.

## A. Check the correct root and account

**Start:** the same example folder, input file and state that created the resources. Use [the basic root](../examples/01-basic/main.tf) for basic cleanup or [the AVM root](../examples/02-avm/main.tf) for AVM cleanup. Do not copy state between them.

If you reopened the terminal, follow [resume an existing lab](resume.md) first. It selects the exact example folder and restores your recorded values. Do not run cleanup from the lab root, a new extraction or a different Terraform workspace.

```powershell
. {
	$ErrorActionPreference = "Stop"
	Get-Location
	az account show --query "{Name:name,Subscription:id}" --output table
	if ($LASTEXITCODE -ne 0) { throw "Cannot verify the account. Stop." }
	terraform state list
}
```

**Expected:** the correct example folder, your sandbox subscription, and that example's resource addresses. An empty list is not proof that no resources exist in Azure if you lost or changed the state.

## B. Preview deletion

```powershell
terraform plan -destroy
```

**Expected after a complete deployment:** four/basic or ten/AVM managed instances to destroy. **After a partial apply, expect fewer:** the proposal must match the objects actually tracked in your state. The manually created group must not be a Terraform deletion. **No deletion yet.**

Stop if the target is unfamiliar. Never use `-target` to hide unexpected resources or disable locking to force a run through.

## C. Destroy with an explicit confirmation

```powershell
terraform destroy
```

**What happens:** Terraform computes a fresh destroy plan, asks you to type `yes`, and then deletes resources in dependency-safe order. The web app is removed before its plan. Answer anything else to cancel.

**Expected:** `Destroy complete!` with no errors. The count can include AVM configuration objects as well as top-level Azure resources. Destroy only knows objects in this root's state; it does not remove arbitrary things someone added to your group.

On failure, keep files/state and ask the instructor to reconcile Azure inventory with state before retrying. Do not remove policy, switch subscription or delete state as a workaround.

## D. Check Azure, not just Terraform

Use the recorded `$rg` from setup or section A. This block stops on a failed Azure read; an error is never treated as an empty group.

```powershell
. {
	$ErrorActionPreference = "Stop"
	terraform state list
	if ($LASTEXITCODE -ne 0) { throw "Cannot inspect state. Stop." }
	$remaining = az resource list --subscription $subscriptionId --resource-group $rg --query "length(@)" --output tsv
	if ($LASTEXITCODE -ne 0) { throw "Cannot inspect Azure. Do not delete the group." }
	if ($remaining -ne "0") { throw "Azure still has resources. Check ownership with the instructor." }
	Write-Output "Verified: 0 resources remain in $rg."
}
```

**Expected:** no managed workload resources in state, then `Verified: 0 resources remain in ...`. Data-source entries are reads, not billable objects. Also check **Azure Portal > Resource groups > your group > Overview**; clear filters so every resource is visible.

**After the basic exercise:** keep the empty group and your local input file; continue with [Copilot and AVM](03-copilot-and-avm.md).

## E. Finish the lab

Only after **both** examples are cleaned up and Azure confirms your dedicated group is empty:

```powershell
. {
	$ErrorActionPreference = "Stop"
	$remaining = az resource list --subscription $subscriptionId --resource-group $rg --query "length(@)" --output tsv
	if ($LASTEXITCODE -ne 0) { throw "Cannot inspect Azure. Do not delete the group." }
	if ($remaining -ne "0") { throw "Group is not empty. Stop." }
	az group delete --subscription $subscriptionId --name $rg
}
```

**What changes:** deletes the group you created manually. Azure CLI asks for confirmation. Check the group name carefully: group deletion removes all its children if it is not empty. This command is not a substitute for Terraform cleanup.

```powershell
. {
	$ErrorActionPreference = "Stop"
	$exists = az group exists --subscription $subscriptionId --name $rg
	if ($LASTEXITCODE -ne 0 -or $exists -ne "false") { throw "Group deletion is not verified. Keep state and investigate." }
	Write-Output $exists
}
```

**Expected:** `false` with no error: the group is gone. On a shared classroom machine, sign out separately:

```powershell
az logout
```

**Expected:** no output; the CLI session ends. Keep source/provider locks. Retain or securely remove local plans/state only after confirmed cleanup under your organization's rules; never upload them.

Check Cost Management later for delayed usage entries. The F1 plan has no plan charge; storage transactions/data retention and any manually added resources can still incur charges.
