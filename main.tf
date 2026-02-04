terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.58.0"
    }
  }
}

provider "azurerm" {
  features {
    
  }
}

resource "azurerm_resource_group" "example" {
  name     = "example"
  location = "UK South"
  tags = { 
    "key" = "Environment"
    "value" = "Green"
   }
}
