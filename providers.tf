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

  required_version = "~> 1.12.2"
}

provider "azurerm" {
  features {}
}