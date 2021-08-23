terraform {
  required_version = ">= 0.12" 
  required_providers {
    azurerm = "=2.42.0"
  }
  backend "azurerm" {
  }
}