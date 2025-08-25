# Tarot Cloud - Azure Infrastructure with Terraform

This project provisions a **modular Azure environment** using Terraform.  
It demonstrates **infrastructure as code (IaC)** best practices, suitable for a production-like setup.

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

## ⚙️ Requirements

- [Terraform](https://developer.hashicorp.com/terraform/downloads) >= 1.12.2
- Azure subscription
- SSH key pair for Linux VM access

---

## 🚀 Usage

1. Clone the repository:
```bash
git clone https://github.com/PrzemyslawSwierzewski/tarot-cloud.git
cd tarot-cloud

2. Initialize Terraform:
terraform init

3.Preview the plan:
terraform plan -var-file="terraform.tfvars" (if you are running the code locally you would need to save the SSH public key here)

4.Deploy infrastructure:
terraform apply -var-file="terraform.tfvars"
```

🏗 Best Practices Implemented<br>
	• Modular design → compute, networking, security<br>
	• Dynamic resources → scalable with for_each<br>
	• Separation of concerns → networking ≠ security<br>
	• Reusable locals for naming standards<br>
	• Sensitive variables stored in .tfvars or Terraform Cloud<br>
	• Outputs for cross-module dependencies<br>

📈 Future Improvements<br>
	• Add CI/CD pipeline (GitHub Actions / Azure DevOps)<br>
	• Implement multi-environment structure (dev, stage, prod)<br>
	• Add monitoring (Azure Monitor, Log Analytics)<br>

This project is licensed under the [MIT License](./LICENSE).
