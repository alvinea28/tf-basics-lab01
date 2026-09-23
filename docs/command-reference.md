# Terraform command reference, in plain English

[Lab home](../README.md)

Run commands from the root you intend to manage. A VS Code workspace folder and a Terraform CLI workspace are different concepts.

| Command | What it does | Changes Azure? |
| --- | --- | --- |
| `terraform -version` | Prints the installed CLI version | No |
| `terraform init -lockfile=readonly` | Installs locked providers/modules and configures state storage | No workload deployment; a remote backend can require authentication |
| `terraform fmt` | Rewrites local whitespace to standard formatting | No |
| `terraform fmt -check -recursive` | Checks formatting, including nested code, without fixing it | No; a nonzero exit is useful in CI |
| `terraform validate` | Checks syntax/types/references after initialization | No; does not prove cloud permissions or quota |
| `terraform plan` | Compares configuration, state, and live Azure; previews changes | No workload writes; reads Azure and can lock remote state |
| `terraform plan "-out=review.tfplan"` | Saves a proposal for later review/apply | Same as plan; creates a potentially sensitive local file |
| `terraform show .\review.tfplan` | Displays a saved plan | No |
| `terraform apply` | Creates a fresh plan and asks for `yes` | **Yes**, after confirmation |
| `terraform apply .\review.tfplan` | Executes exactly that saved plan | **Yes, without another confirmation** |
| `terraform output` | Prints the outputs already recorded in state | No |
| `terraform output -raw web_app_url` | Prints just the URL string, without quotation marks | No |
| `terraform state list` | Lists tracked addresses, including data sources | No |
| `terraform state show ADDRESS` | Shows one saved state entry; can reveal sensitive values | No |
| `terraform plan -destroy` | Previews removal of this root's managed resources | No workload deletion |
| `terraform destroy` | Replans deletion and asks for `yes` | **Yes**, after confirmation |
| `terraform test` | Runs test files | **Depends on tests**; ours mock every provider |
| `terraform providers` | Shows which provider each module requires | No |
| `terraform workspace show` | Prints the selected Terraform state workspace | No; use only `default` in these labs |
| `terraform -help` | Shows command help | No |

## Six words to remember

- **HCL:** the configuration language in these examples.
- **Provider:** a plugin that talks to an API, such as AzureRM or AzAPI.
- **Resource:** an object Terraform manages through a provider.
- **Data source:** an existing object Terraform reads without owning its lifecycle.
- **Module:** a reusable folder of Terraform inputs, resources, and outputs.
- **State:** the record connecting Terraform addresses to existing cloud objects. Protect it.

## Plan exit codes used in automation

Ordinary plan uses `0` for success and `1` for error. With `-detailed-exitcode`, **0 = no changes, 1 = error, 2 = changes**. A workflow must not mistake `2` for a failed plan or ignore `1`.

## Not beginner shortcuts

Do not use `-auto-approve`, `-lock=false`, `force-unlock`, `state rm`, `state push`, or `-target` to get past a confusing result. Ask for help. Deleting a state file does not delete Azure; deleting Azure by hand does not update the source code.
