terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.97.0"
    }
  }
}
 
provider "azurerm" {
  features {}
}