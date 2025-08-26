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

[CODE:bash]
git clone https://github.com/PrzemyslawSwierzewski/Tarot-Cloud---Azure-Infrastructure-with-Terraform.git
cd Tarot-Cloud---Azure-Infrastructure-with-Terraform
[/CODE]

2. **Terraform Setup** — Install Terraform CLI and configure GitHub secrets:  
- `TF_API_TOKEN` — Terraform Cloud API token  
- `SSH_PUBLIC_KEY` — SSH key for VM access  
- `ARM_CLIENT_ID`, `ARM_CLIENT_SECRET`, `ARM_SUBSCRIPTION_ID`, `ARM_TENANT_ID` — Azure Service Principal credentials  

3. **Terraform Init** — Connect to your Terraform Cloud workspace and initialize:

[CODE:bash]
terraform init
[/CODE]

> Note: Update `providers.tf` with your organization and workspace:

[CODE:hcl]
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
[/CODE]

4. **Terraform Format** — Check formatting of `.tf` files:

[CODE:bash]
terraform fmt
[/CODE]

5. **Terraform Plan** — Generate a plan:

[CODE:bash]
terraform plan -out=tfplan
[/CODE]

6. **Terraform Apply** — Apply the plan:

[CODE:bash]
terraform apply tfplan
[/CODE]

---

## 🔑 Secrets

- `TF_API_TOKEN` — Terraform Cloud API token  
- `SSH_PUBLIC_KEY` — SSH key for VM access  
- `ARM_CLIENT_ID`, `ARM_CLIENT_SECRET`, `ARM_SUBSCRIPTION_ID`, `ARM_TENANT_ID` — Azure Service Principal credentials  

---

## 🏗 Best Practices Implemented

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

## 📈 Future Improvements

- Add monitoring using Azure Monitor & Log Analytics  
- Integrate static analysis and security scanning (tfsec / Checkov)  

---

This project is licensed under the [MIT License](./LICENSE).
