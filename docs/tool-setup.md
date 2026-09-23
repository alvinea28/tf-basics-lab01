# Install tools and open the lab

> **Copy/paste:** Copy the entire block, including `. {` and `}`, paste it once, then press Enter. It groups commands so a failure stops the group; never paste the next group after an error.

[Lab home](../README.md) | Next: [Azure setup](01-setup.md)

**Windows only.** Skip tools already installed at the required version. If your organization manages software, ask IT rather than changing its restrictions.

## 1. Install the tools

| Tool | Installation steps |
| --- | --- |
| [VS Code](https://code.visualstudio.com/download) | Download the Windows installer, run it, and keep **Add to PATH** selected. Finish the wizard. |
| [Git for Windows](https://git-scm.com/downloads/win) | Run the installer. Keep **Git from the command line and also from 3rd-party software** and **Git Credential Manager** enabled. Other defaults are suitable for this lab. |
| [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-windows) | Follow **Install or update > Latest version > 64-bit MSI**. Run the downloaded installer and finish the wizard. This does not sign you in. |
| [Terraform 1.16.3](https://releases.hashicorp.com/terraform/1.16.3/) | Follow the ZIP/PATH steps below. The Terraform editor extension alone does **not** install the CLI. |

### Terraform ZIP and PATH

1. For a standard Intel/AMD Windows PC, download **terraform_1.16.3_windows_amd64.zip** from the release page. Ask the instructor about ARM-based PCs.
2. In File Explorer, right-click the ZIP > **Extract All**.
3. Paste **%LOCALAPPDATA%\Programs** into Explorer's address bar. Create a folder named **Terraform** and move the extracted executable into it.
4. Open Windows Start, search **Edit environment variables for your account**, and open it.
5. Under **User variables**, select **Path > Edit > New**. Enter **%LOCALAPPDATA%\Programs\Terraform**. Do not replace existing entries.
6. Click **OK** on each dialog. Close and reopen VS Code so its terminal sees the new PATH.

## 2. Open your own clean copy

1. On the lab's GitHub page, select **Code > Download ZIP**; or use the clean ZIP supplied by the instructor.
2. In File Explorer, select **Extract All**. Do not work inside the compressed ZIP.
3. In VS Code, select **File > Open Folder**. Choose the extracted folder containing [README.md](../README.md) and [examples/01-basic/main.tf](../examples/01-basic/main.tf). Trust it only after checking its source.
4. Press **Ctrl+Shift+X**, search **HashiCorp Terraform**, select the HashiCorp publisher's extension, and click **Install**.
5. Press **Ctrl+Shift+P** > **Terminal: Select Default Profile** > **PowerShell** (or **Windows PowerShell**). Then select **Terminal > New Terminal**. Do not use Bash for these blocks.
6. Open a guide in the Explorer and press **Ctrl+Shift+V** for its readable Markdown preview.

**Expected:** the Explorer shows the lab files and the terminal is PowerShell in your extracted lab folder. A folder ending in **-main** from a ZIP is fine.

## 3. Check each tool

Run these read-only checks. Fix any **not recognized** error before proceeding.

```powershell
. {
	$ErrorActionPreference = "Stop"
	terraform -version
	az version
	git --version
	Get-Location
}
```

**Expected:** `Terraform v1.16.3`, Azure CLI version information, a Git version, and the lab folder path. Nothing is created in Azure. If another Terraform version appears, ask the instructor to resolve the PATH order; the supplied version marker does not switch executables for you.

## 4. Optional: enable Copilot

Click the **Chat/Copilot** icon in VS Code > **Set up Copilot** or **Sign in**. Complete GitHub sign-in in the browser. This is separate from Azure sign-in. If Copilot is unavailable, the lab includes a complete local-module answer.

Continue with [Azure setup](01-setup.md).
