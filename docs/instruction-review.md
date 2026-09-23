# Beginner-guide acceptance — 2026-09-23

[Lab home](../README.md) | [Verification](verification.md)

**Result: PASS for documentation simplicity, concision and actionable safety.** This is an expert review, not a claim that novice users or a live Azure deployment were tested successfully.

## What changed after critique

- Added exact Windows/VS Code installation, shell and Copilot clicks; separated optional tool detail from the main route.
- Added the original-folder/input/state recovery route for a new terminal.
- Grouped multiline PowerShell into one copy-paste operation, preserved variables, and stopped dependent commands after failures.
- Refused input overwrite, separated plan review from apply, and explained conditional success output and partial failures.
- Required successful inventory reads before group deletion; kept state until cleanup is verified.
- Kept Japan East, Windows F1 and the four-resource boundary unchanged. Corrected stale-plan and live-evidence wording.

Two critique rounds identified issues; corrections were followed by a final read-only review with **no must-fix findings**. Technical detail remains in references instead of interrupting the learner path.

## Checks executed for this release

- Three Lab01 Terraform roots: formatting, backend-disabled initialization and validation passed on Windows with Terraform 1.16.3; three dependency locks unchanged.
- Four Lab01 native mock runs passed: two/basic and two/AVM. No live Azure provider calls.
- Authoring workspace: **19 guide-safety tests**, **28 guard tests**, **104 parsed PowerShell blocks** (99 learner blocks), and three inactive Lab02 workflow lint checks passed. The safety harness used stubbed cloud commands and real native process failures; it was not a live deployment test.
- Local links/heading targets, source identity and editor diagnostics were checked. Runnable Terraform source/tests/locks were not changed by this review.

**Release target:** private **alvinea28/tf-basics-lab01**, branch **main**, as requested. No state, inputs, saved plans or provider caches are release content.

**Open:** instructor clearance for Windows F1 quota/policy and a complete live lifecycle. The separate partial Lab02 simulation is not a Lab01 deployment pass; see verification.
