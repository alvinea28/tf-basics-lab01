# Lab01 verification

[Lab home](../README.md)

Verified during authoring on **2026-09-23**, using Terraform **1.16.3 on Windows**:

- Recursive formatting passed.
- Basic and AVM roots initialized without a backend and validated successfully.
- **Four native Terraform mock runs passed**: two per example. No Azure credentials were used.
- The local network-module answer initialized and validated successfully.
- Genuine provider lock files include signed Windows/Linux provider download checksums. Read-only reinitialization on Windows preserved all lock-file bytes.
- Local guide links, PowerShell syntax, and official reference URLs were checked.

## Repeat the safe checks

From a clean lab01 copy's root, run one complete block. Downloads may occur; **no Azure authentication or resources** are involved. A failure stops the block.

```powershell
. {
	$ErrorActionPreference = "Stop"
	foreach ($example in @("examples/01-basic", "examples/02-avm")) {
		terraform "-chdir=$example" init -backend=false -input=false -lockfile=readonly
		if ($LASTEXITCODE -ne 0) { throw "Initialization failed: $example" }
		terraform "-chdir=$example" fmt -check -recursive
		if ($LASTEXITCODE -ne 0) { throw "Formatting failed: $example" }
		terraform "-chdir=$example" validate
		if ($LASTEXITCODE -ne 0) { throw "Validation failed: $example" }
		terraform "-chdir=$example" test
		if ($LASTEXITCODE -ne 0) { throw "Mock tests failed: $example" }
	}
}
```

**Expected for each example:** initialized, silent format success, `Success! The configuration is valid.`, then `Success! 2 passed, 0 failed.` Total: **four** mock runs.

Check the supplied module answer separately:

```powershell
. {
	$ErrorActionPreference = "Stop"
	terraform -chdir=solutions/network-module init -backend=false -input=false -lockfile=readonly
	if ($LASTEXITCODE -ne 0) { throw "Module initialization failed." }
	terraform -chdir=solutions/network-module validate
	if ($LASTEXITCODE -ne 0) { throw "Module validation failed." }
}
```

**Expected:** initialized, then valid configuration. There are no tests or deployment in this module-answer check.

## Not tested live

An authorized instructor must still verify the participant subscription's Japan East F1 quota/capacity, Azure policy/permissions, closed-storage ARM operations, default web page, first apply, no-change plan, tag update, partial-apply cleanup, and final destruction.

No live **Lab01** plan/apply/destroy was performed. A valid configuration and mocked plan are not proof that a subscription can deploy it. The VNet remains separate and the plan must stay F1 even if live prerequisites fail.

## Subsequent isolated participant rehearsal

On 2026-09-23, the basic and AVM roots were copied to separate test directories and executed with Terraform 1.16.3 on **both Windows and Ubuntu Linux**. On each platform, the four shipped lab01 mock runs passed again, plus **10 additional lab01 lifecycle runs**: mocked preview, create, unchanged plan, owner-tag update, and unchanged plan for each root. Automatic mock cleanup succeeded; tag updates retained resource IDs, and locked initialization did not alter the provider locks.

All provider operations were mocked, with explicit synthetic IDs/hostname. These runs exercised the native Terraform dependency graph, not Azure API normalization, quota, policy, or live deletion. The original learner source files were hash-verified as unchanged during the simulation. The participant-input guide and local input templates were also cross-checked for matching field names.

## Later isolated live result: blocked, not a Lab01 pass

On the same date, a **separate Lab02 simulation** first hit a Blob-backend policy **403**. An explicitly authorized, differently configured local-state retry created a VNet and storage account, then Azure rejected Windows **F1 with quota 0 in Japan East**. No App Service plan/web app, HTTPS check, full convergence, tag lifecycle or live cleanup was proved. Partial state/recovery material was retained and execution disabled.

That result is neither a successful Lab01 deployment nor validation of the unchanged Lab02 Blob workflows. Do not reuse the simulation state or treat a region listing as quota clearance. The later documentation review made **no additional Azure changes**.

## Guide review and release checks

The [instruction-review record](instruction-review.md) documents the critique/correction cycle and final acceptance. The current release reran all four Lab01 mock runs, validated all three roots, preserved locks, and passed the shared offline guide-safety checks. These are local/source results, not a new cloud deployment.
