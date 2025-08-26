# Tarot Cloud - Azure Infrastructure with Terraform

This project provisions a **modular Azure environment** using Terraform and demonstrates **Infrastructure as Code (IaC)** best practices. It is designed as a production-like setup with full DevOps automation and security.

<img width="1766" height="1120" alt="Tarot-cloud-architecture" src="https://github.com/user-attachments/assets/ec1a153d-cd18-44a0-ac47-6885e5544fc8" />

---

## ⚙️ Requirements

- [Terraform](https://developer.hashicorp.com/terraform/downloads) ~> 1.13
- Azure subscription
- SSH key pair for Linux VM access

---

## 📌 Project Highlights

### Multi-Environment Architecture
- Separate **Dev** and **Prod** resource groups
- Fully isolated **Virtual Networks**, **Subnets**, **NSGs**, and **Public IPs**
- Modular design for compute, networking, and security

### Compute Module
- Linux Virtual Machines (Ubuntu 22.04 LTS)
- Dev and Prod environments with SSH key authentication
- Cloud-init provisioning for automated setup
- Standardized OS disks with LRS storage

### Networking Module
- Virtual Networks with multiple subnets
- Network Interfaces and Public IPs for each VM
- NSGs with inbound rules (SSH, HTTP, HTTPS) and outbound allow-all
- NSG-to-subnet associations automated

### Security & Best Practices
- Network Security Groups per environment
- Security scanning via **tfsec** integrated into GitHub Actions
- Secrets securely stored in GitHub Secrets
- Separation of concerns for modularity and reusability

### Monitoring & Observability (Prod)
- Azure Monitor Agent (AMA) installed on Linux VMs
- Log Analytics workspace for centralized logs and metrics
- Storage account for diagnostics and monitoring data
- Metric alerts:
  - CPU > 90%
  - Memory < 400MB
  - VM heartbeat missing
- Email notifications via Azure Monitor Action Group

---

## 🔄 CI/CD & Automation

- **Triggers:** Pushes and Pull Requests to `main` branch
- **Automation:** GitHub Actions + Terraform Cloud
  - Terraform validation, formatting, plan generation, and apply
  - tfsec security scanning on every change
- **State Management:** Centralized via Terraform Cloud for collaboration

---

## 🚀 Usage

1. **Clone the Repository**

Run the following commands in your terminal:

```bash
git clone https://github.com/PrzemyslawSwierzewski/Tarot-Cloud---Azure-Infrastructure-with-Terraform.git
cd Tarot-Cloud---Azure-Infrastructure-with-Terraform
```

2. **Configure Secrets** in GitHub:

- `EMAIL_ADDRESS` — For monitoring alerts  
- `TFSEC_GITHUB_TOKEN` — For tfsec security scanning  
- `PUBLIC_IP_ADDRESS` — Restrict NSG access to your IP  
- `TF_API_TOKEN` — Terraform Cloud API token  
- `SSH_PUBLIC_KEY` — VM SSH access  
- `ARM_CLIENT_ID`, `ARM_CLIENT_SECRET`, `ARM_SUBSCRIPTION_ID`, `ARM_TENANT_ID` — Azure Service Principal

3. **Initialize Terraform**

Run:

```bash
terraform init
```

> Update `providers.tf` with your organization and workspace:

```hcl
terraform {
  backend "remote" {
    organization = "personal-org-prem"
    workspaces { name = "tarot-cloud" }
  }

  required_providers {
    azurerm = { source = "hashicorp/azurerm", version = "4.41.0" }
  }

  required_version = "~> 1.13"
}
```

4. **Format Terraform files**

```bash
terraform fmt
```

5. **Generate a Plan**

```bash
terraform plan -out=tfplan
```

6. **Apply the Plan**

```bash
terraform apply tfplan
```

---

## 🔑 Secrets Management

All sensitive credentials are stored securely in GitHub Secrets or Terraform Cloud variables:

- `EMAIL_ADDRESS` 
- `TFSEC_GITHUB_TOKEN`  
- `TF_API_TOKEN`  
- `SSH_PUBLIC_KEY`  
- `ARM_CLIENT_ID`, `ARM_CLIENT_SECRET`, `ARM_SUBSCRIPTION_ID`, `ARM_TENANT_ID`  

---

## 🏗 Best Practices Implemented

- Modular design: compute, networking, security  
- Multi-environment: Dev & Prod  
- Automated CI/CD with GitHub Actions + Terraform Cloud  
- Security scanning integrated with tfsec  
- Centralized Terraform state management  
- Sensitive variables stored securely  
- Cross-module outputs for reusable references  
- Production-grade monitoring and alerts  
- Separation of concerns and reusable locals for consistent naming  

---

This project is licensed under the [MIT License](./LICENSE).
