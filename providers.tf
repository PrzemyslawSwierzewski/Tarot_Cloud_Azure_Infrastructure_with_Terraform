terraform {
  backend "remote" {
    organization = "Prem_learning_org"

    workspaces {
      name = "tarot-cloud-project"
    }
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.41.0"
    }
  }

  required_version = "~> 1.14.0"
}

provider "azurerm" {
  features {}
}