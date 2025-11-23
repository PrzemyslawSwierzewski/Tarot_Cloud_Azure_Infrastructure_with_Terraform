# Tarot Cloud - Azure Infrastructure with Terraform

This project provisions a **modular Azure environment** using Terraform and demonstrates **Infrastructure as Code (IaC)** best practices. It is designed as a production-like setup with full DevOps automation and security.

<img width="2239" height="1947" alt="diagram-export-22 11 2025-16_20_58" src="https://github.com/user-attachments/assets/420ce5b2-62ce-46a4-a4d5-784636615ff8" />

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
- Virtual Machine Scale Sets (VMSS) for Prod, integrated with Azure Load Balancer
- Standardized OS disks with LRS storage

### Networking Module
- Virtual Networks with multiple subnets
- Network Interfaces and Public IPs for each VM
- NSGs with inbound rules (SSH, HTTP, HTTPS) and outbound to Internet
- NSG-to-subnet associations automated
- Azure Load Balancer with backend pool and health probes configured for VMSS

### Security & Best Practices
- Network Security Groups per environment
- Security scanning via **Trivy** integrated into GitHub Actions
- Secrets securely stored in GitHub Secrets
- Separation of concerns for modularity and reusability

### Monitoring & Observability (Prod)
- Azure Monitor Agent (AMA) installed on Linux VMs
- Log Analytics workspace for centralized logs and metrics
- Logs collected:
  - Syslog from Linux VMs:
    - Facilities: AUTH, DAEMON, SYSLOG
    - Severities: Warning, Error, Critical, Alert, Emergency
- Metric alerts:
  - CPU > 90%
  - Memory < 400MB
  - VM availability missing
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
- `PUBLIC_IP_ADDRESS`
- `TFSEC_GITHUB_TOKEN`  
- `TF_API_TOKEN`  
- `SSH_PUBLIC_KEY`  
- `ARM_CLIENT_ID`, `ARM_CLIENT_SECRET`, `ARM_SUBSCRIPTION_ID`, `ARM_TENANT_ID`  

---

## 🏗 Best Practices Implemented

- **Modular design**: compute, networking, monitoring, and security split into reusable modules  
- **Multi-environment support**: Dev & Prod with consistent patterns
- **Virtual Machine Scale Sets** integrated with Load Balancer
- **Automated CI/CD**: GitHub Actions + Terraform Cloud for deployment pipelines  
- **Security scanning**: integrated with trivy and best-practice policies  
- **Centralized state management**: Terraform Cloud backend with locking enabled  
- **Secrets management**: sensitive variables stored securely in environment variables / key vault  
- **Cross-module outputs**: shared values exposed for easy reuse between modules  
- **Observability & monitoring**: Log Analytics, Azure Monitor Agent, syslog ingestion, metric + query-based alerts  
- **Separation of concerns**: consistent naming via reusable locals and isolated module responsibilities  

---

## 💰 Cost Awareness

This project provisions multiple Azure resources that may incur **ongoing costs**. Key points to consider:

- **Virtual Machines**: Running multiple Linux VMs in Dev and Prod can generate significant charges. Consider using smaller VM sizes in Dev or stopping them when not in use.
- **Public IPs**: Static public IPs incur a monthly fee. Use dynamic IPs for Dev if static IPs are not required.
- **Storage**: OS disks (Standard LRS) and monitoring storage can accumulate costs depending on usage and retention period.
- **Monitoring & Alerts**: Azure Monitor and Log Analytics may generate charges based on data ingestion and retention. Limit retention or adjust metrics collection for cost control.
- **Networking**: VNet and NSGs are free, but data egress may result in charges if traffic leaves the Azure region.

**Tip:** Monitor your subscription with [Azure Cost Management](https://azure.microsoft.com/en-us/services/cost-management/) and delete resources when not needed to avoid unexpected costs.

---

This project is licensed under the [MIT License](./LICENSE).
