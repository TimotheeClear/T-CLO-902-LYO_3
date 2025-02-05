terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.97.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = "~>1.12.0"
    }
  }
  backend "azurerm" {
    key     = "kubequest_infra.tfstate"
    region  = "francecentral"
  }
}

provider "azapi" {}

provider "azurerm" {
  features {}
}