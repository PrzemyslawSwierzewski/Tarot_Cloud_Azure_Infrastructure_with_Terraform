# Tarot Cloud - Azure Infrastructure with Terraform

This project provisions a **modular Azure environment** using Terraform.  
It demonstrates **infrastructure as code (IaC)** best practices, suitable for a production-like setup.

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
  - 
This repository uses **GitHub Actions** to implement a CI/CD pipeline for Terraform.  
**Terraform Cloud** serves as the remote backend to manage state securely and track runs.
---
### Workflow
**Triggers**:  
- Pushes to the `main` branch  
- Pull requests against `main`  

## 🚀 Usage
1. **Checkout** — Clone the repository.  
2. **Terraform Setup** — Install CLI and configure Terraform Cloud using `TF_API_TOKEN`.  
3. **Terraform Init** — Connect to Terraform Cloud workspace (`tarot-cloud`) in `personal-org-prem`).  
4. **Terraform Format** — Check formatting of `.tf` files.  
5. **Terraform Plan** — Generate a plan and upload as artifact.  
6. **Terraform Apply** — Apply the plan to provision/update infrastructure.

---

### Secrets

- `TF_API_TOKEN` — Terraform Cloud API token  
- `SSH_PUBLIC_KEY` — SSH key for VM access  
- `ARM_CLIENT_ID`, `ARM_CLIENT_SECRET`, `ARM_SUBSCRIPTION_ID`, `ARM_TENANT_ID` — Azure Service Principal credentials  

---

### Remote Backend

Terraform Cloud is used as the backend:

```hcl
terraform {
  backend "remote" {
    organization = "personal-org-prem"

    workspaces {
      name = "tarot-cloud"
    }
  }
}
```

Benefits
	• Automated CI/CD for every code change
	• Centralized state management with Terraform Cloud
	• Plan artifacts for safe review before applying changes
	• Secure credentials stored in GitHub Secrets

🏗 Best Practices Implemented<br>
	• Automated CI/CD for every code change
	• Centralized state management with Terraform Cloud
	• Secure credentials stored in GitHub Secrets
	• Modular design → compute, networking, security<br>
	• Dynamic resources → scalable with for_each<br>
	• Separation of concerns → networking ≠ security<br>
	• Reusable locals for naming standards<br>
	• Sensitive variables stored in .tfvars or Terraform Cloud<br>
	• Outputs for cross-module dependencies<br>

📈 Future Improvements<br>
	• Implement multi-environment structure (what’s left is naming the resources and assigning them appropriate tags) <br>
	• Add monitoring (Azure Monitor, Log Analytics)<br>

This project is licensed under the [MIT License](./LICENSE).
