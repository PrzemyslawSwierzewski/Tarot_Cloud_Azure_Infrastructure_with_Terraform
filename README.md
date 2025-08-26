# Tarot Cloud - Azure Infrastructure with Terraform

This project provisions a **modular Azure environment** using Terraform.  
It demonstrates **infrastructure as code (IaC)** best practices, suitable for a production-like setup.

<img width="1766" height="1120" alt="Tarot-cloud-architecture" src="https://github.com/user-attachments/assets/d3abdbec-4bf4-47e7-80c3-43c3357ef1a3" />


---
## ⚙️ Requirements

- [Terraform](https://developer.hashicorp.com/terraform/downloads) ~> 1.13
- Azure subscription
- SSH key pair for Linux VM access

---
## 📌 Features

- **Resource Groups** – Dedicated container for dev and prod resources
- **Networking Module seperate for dev and prod resources**
  - Virtual Networks & Subnets
  - Public IPs
  - Network Interfaces
- **Networking Module seperate for dev and prod resources**
  - Linux Virtual Machines
  - Cloud-init provisioning
  - SSH key authentication
- **Networking Module seperate for dev and prod resources**
  - Network Security Groups (NSGs)
  - Inbound rules for SSH (22), HTTP (80), HTTPS (443)
  - Outbound rule allowing all traffic
  - Automatic association with subnets
- **Outputs**
  - VM dev and prod Public IP addresses
--- 
**CI/CD with GitHub Actions and Terraform Cloud**
<br>
This repository uses **GitHub Actions** to implement a CI/CD pipeline for Terraform. <br>
<br>
**Terraform Cloud** serves as the remote backend to manage state securely and track runs.
---
🔄 **CI/CD Workflow**

Triggers:<br>
  -Pushes to the main branch
  -Pull requests against main

GitHub Actions + Terraform Cloud ensure automated validation,init, fmt, plan, and apply steps on every change.

## 🚀 Usage
1. **Checkout** — Clone the repository.  
2. **Terraform Setup** — Install CLI and configure Github secrets with {`TF_API_TOKEN`} - Terraform User API token. {`ARM_CLIENT_ID`, `ARM_CLIENT_SECRET`, `ARM_SUBSCRIPTION_ID`, `ARM_TENANT_ID} - Azure Service Principal credentials  
3. **Terraform Init** — Connect to Terraform Cloud workspace. In providers.tf file change organization and name of the workspace :
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
4. **Terraform Format** — Check formatting of `.tf` files.  
5. **Terraform Plan** — Generate a plan. 
6. **Terraform Apply** — Apply the plan to provision/update infrastructure.

---

### 🔑 Secrets

- `TF_API_TOKEN` — Terraform Cloud API token  
- `SSH_PUBLIC_KEY` — SSH key for VM access  
- `ARM_CLIENT_ID`, `ARM_CLIENT_SECRET`, `ARM_SUBSCRIPTION_ID`, `ARM_TENANT_ID` — Azure Service Principal credentials  

---

### 🏗 Best Practices Implemented
- Multi-environment structure (Prod, Dev)
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
- Add monitoring (Azure Monitor, Log Analytics)

---

This project is licensed under the [MIT License](./LICENSE).
