# Tarot Cloud - Azure Infrastructure with Terraform

This project provisions a **modular Azure environment** using Terraform.  
It demonstrates **infrastructure as code (IaC)** best practices and is suitable for production-like setups.

<img width="1766" height="1120" alt="Tarot-cloud-architecture" src="https://github.com/user-attachments/assets/ec1a153d-cd18-44a0-ac47-6885e5544fc8" />

---

## ⚙️ Requirements

- [Terraform](https://developer.hashicorp.com/terraform/downloads) ~> 1.13
- Azure subscription
- SSH key pair for Linux VM access

---

## 📌 Features

### Resource Groups
- Dedicated containers for Dev and Prod environments

### Networking Module
- Separate configurations for Dev and Prod
- Virtual Networks & Subnets
- Public IPs
- Network Interfaces

### Compute Module
- Separate configurations for Dev and Prod
- Linux Virtual Machines
- Cloud-init provisioning
- SSH key authentication

### Security Module
- Separate configurations for Dev and Prod
- Network Security Groups (NSGs)
- Inbound rules: SSH (22), HTTP (80), HTTPS (443)
- Outbound rule allowing all traffic
- Automatic association with subnets

### Monitoring Module
- Monitoring logs are collected based on Azure Monitor (later to be replaced with Azure Monitor Agent (AMA) https://medium.com/@t.costantini89/send-linux-vm-logs-to-an-azure-log-analytics-workspace-using-terraform-and-the-azure-monitor-agent-939d481cc48a)
- Log Analytics workspace for collecting logs and metrics
- Storage account for diagnostics data
- Diagnostic settings to send VM logs and metrics to workspace and storage
- Metric alerts: CPU >90%, Memory <10%
- Notifications sent via action group (email)

### Outputs
- VM Dev and Prod public IP addresses
- Other cross-module outputs

---

## 🔄 CI/CD Workflow

**Triggers:**  
- Pushes to the `main` branch  
- Pull requests against `main`  

**Automation:**  
GitHub Actions + Terraform Cloud handle automated validation, initialization, formatting, plan generation, and apply on every change.

---

## 🚀 Usage

1. **Checkout** — Clone the repository:

```bash
git clone https://github.com/PrzemyslawSwierzewski/Tarot-Cloud---Azure-Infrastructure-with-Terraform.git
cd Tarot-Cloud---Azure-Infrastructure-with-Terraform
```

2. **Terraform Setup** — Install Terraform CLI and configure GitHub secrets:
- `EMAIL_ADDRESS` - Email address where you would like to recive an emails in case of high CPU or high memory utilization
- `TFSEC_GITHUB_TOKEN` - Your GITHUB_TOKEN. It will be passed to GitHub action for tfsec checks
- `PUBLIC_IP_ADDRESS` - Your public IP address. It will be used to restrict the Network Security Group so that only you can access the Linux machine
- `TF_API_TOKEN` — Terraform Cloud API token. It will be used to connect to your terraform cloud.
- `SSH_PUBLIC_KEY` — SSH key for VM access. It will be used to save your ssh key on a linux machine.
- `ARM_CLIENT_ID`, `ARM_CLIENT_SECRET`, `ARM_SUBSCRIPTION_ID`, `ARM_TENANT_ID` — Azure Service Principal credentials. It will be used to connect to your Azure subscription. 

3. **Terraform Init** — Connect to your Terraform Cloud workspace and initialize:

```bash
terraform init
```

> Note: Update `providers.tf` with your organization and workspace:

```hcl
terraform {
  backend "remote" {
    organization = "personal-org-prem"

    workspaces {
      name = "tarot-cloud"
    }
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.41.0"
    }
  }

  required_version = "~> 1.13"
}
```

4. **Terraform Format** — Check formatting of `.tf` files:

```bash
terraform fmt
```

5. **Terraform Plan** — Generate a plan:

```bash
terraform plan -out=tfplan
```

6. **Terraform Apply** — Apply the plan:

```bash
terraform apply tfplan
```

---

## 🔑 Secrets

- `TFSEC_GITHUB_TOKEN` - Your GITHUB_TOKEN
- `TF_API_TOKEN` — Terraform Cloud API token  
- `SSH_PUBLIC_KEY` — SSH key for VM access  
- `ARM_CLIENT_ID`, `ARM_CLIENT_SECRET`, `ARM_SUBSCRIPTION_ID`, `ARM_TENANT_ID` — Azure Service Principal credentials  

---

## 🏗 Best Practices Implemented

- Security scanning with tfsec implemented with GitHub Actions
- Multi-environment structure (Prod, Dev)  
- Automated CI/CD for all code changes  
- Centralized state management with Terraform Cloud  
- Secure credentials stored in GitHub Secrets  
- Modular design → compute, networking, security  
- Dynamic resources using `for_each`  
- Separation of concerns → networking ≠ security  
- Reusable locals for consistent naming  
- Sensitive variables stored in `.tfvars` or Terraform Cloud  
- Outputs for cross-module dependencies  

---

This project is licensed under the [MIT License](./LICENSE).
