terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.97.0"
    }
  }
  backend "azurerm" { 
    key     = "terraform_back.tfstate"
    region  = "francecentral"
  }

} 

provider "azurerm" { 
  features {}
}