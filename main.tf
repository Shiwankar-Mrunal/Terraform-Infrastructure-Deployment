terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}
 
provider "azurerm" {
  features {}
   subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  client_id       = var.client_id
  client_secret   = var.client_secret
}
 
# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "rg-demo-web"
  location = "West Europe"
}
 
  #Create an Azure Storage Account
 resource "azurerm_storage_account" "storage_account" {
  name                     = "storageforstaticpage"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

 
# Random suffix to make storage name unique
resource "random_integer" "suffix" {
  min = 10000
  max = 99999
}
 
# App Service Plan
resource "azurerm_service_plan" "app_service_plan" {
  name                = "demo-serviceplan"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku_name            = "S1"   # Basic tier
  os_type             = "Linux"
}
 
# Web App
resource "azurerm_linux_web_app" "webapp" {
  name                = "demo-webapp-${random_integer.suffix.result}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  service_plan_id     = azurerm_service_plan.app_service_plan.id
 
  site_config {
    application_stack {
      python_version = "3.9"  # Example runtime
    }
  }
 

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = "1"
    "STORAGE_ACCOUNT_NAME"     = azurerm_storage_account.storage_account.name
  }

  depends_on = [azurerm_storage_account.storage_account]
}