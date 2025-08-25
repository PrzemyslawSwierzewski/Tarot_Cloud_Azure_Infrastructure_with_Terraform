# Tarot Cloud - Azure Infrastructure with Terraform

This project provisions a **modular Azure environment** using Terraform.  
It demonstrates **infrastructure as code (IaC)** best practices, suitable for a production-like setup.

<img width="1643" height="790" alt="diagram-export-25 08 2025-17_41_21" src="https://github.com/user-attachments/assets/c30c6476-3c74-4dbb-b611-fa43c605cf50" />

---
## ⚙️ Requirements

- [Terraform](https://developer.hashicorp.com/terraform/downloads) ~> 1.13
- Azure subscription
- SSH key pair for Linux VM access

---
## 📌 Features

- **Resource Group** – Dedicated container for resources
- **Networking Module**
  - Virtual Networks & Subnets
  - Public IPs
  - Network Interfaces
- **Compute Module**
  - Linux Virtual Machines
  - Cloud-init provisioning
  - SSH key authentication
- **Security Module**
  - Network Security Groups (NSGs)
  - Inbound rules for SSH (22), HTTP (80), HTTPS (443)
  - Outbound rule allowing all traffic
  - Automatic association with subnets
- **Outputs**
  - VM Public IP addresses
  - **CI/CD with GitHub Actions and Terraform Cloud**
---
This repository uses **GitHub Actions** to implement a CI/CD pipeline for Terraform. <br>
---
**Terraform Cloud** serves as the remote backend to manage state securely and track runs.
---
### ⚙️ Workflow
**Triggers**:  
- Pushes to the `main` branch  
- Pull requests against `main`  

## 🚀 Usage
1. **Checkout** — Clone the repository.  
2. **Terraform Setup** — Install CLI and configure Terraform Cloud using `TF_API_TOKEN`.  
3. **Terraform Init** — Connect to Terraform Cloud workspace `your-workspace` in `your-organization`.  
4. **Terraform Format** — Check formatting of `.tf` files.  
5. **Terraform Plan** — Generate a plan. 
6. **Terraform Apply** — Apply the plan to provision/update infrastructure.

---

### 🔑 Secrets

- `TF_API_TOKEN` — Terraform Cloud API token  
- `SSH_PUBLIC_KEY` — SSH key for VM access  
- `ARM_CLIENT_ID`, `ARM_CLIENT_SECRET`, `ARM_SUBSCRIPTION_ID`, `ARM_TENANT_ID` — Azure Service Principal credentials  

---

### ☁️ Remote Backend

Terraform Cloud is used as the backend in providers.tf:

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

### 🏗 Best Practices Implemented
- Automated CI/CD for every code change
- Centralized state management with Terraform Cloud
- Secure credentials stored in GitHub Secrets
- Modular design → compute, networking, security
- Dynamic resources → scalable with for_each
- Separation of concerns → networking ≠ security
- Reusable locals for naming standards
- Sensitive variables stored in .tfvars or Terraform Cloud
- Outputs for cross-module dependencies

---

### 📈 Future Improvements
- Implement multi-environment structure (Prod, Dev)
- Add monitoring (Azure Monitor, Log Analytics)

---


This project is licensed under the [MIT License](./LICENSE).
