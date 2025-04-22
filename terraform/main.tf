terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.26.0"
    }

    docker = {
      source  = "kreuzwerker/docker"
      version = "3.2.0"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  subscription_id = var.subscription_id
  features {}
}

provider "docker" {}

resource "azurerm_resource_group" "app_rg" {
  name     = var.app_name
  location = var.location
}

# PostgreSQL
resource "random_id" "pg_suffix" {
  byte_length = 2
}

resource "azurerm_postgresql_flexible_server" "pg_server" {
  create_mode         = "Default"
  name                = "${var.app_name}-db-server-${random_id.pg_suffix.hex}"
  resource_group_name = azurerm_resource_group.app_rg.name
  location            = var.location

  administrator_login    = var.pg_admin_user
  administrator_password = var.pg_admin_password
  version                = "16"
  sku_name               = "B_Standard_B1ms"
  storage_mb             = 32768
  delegated_subnet_id    = null

  backup_retention_days        = 7
  geo_redundant_backup_enabled = false

  lifecycle {
    # prevent_destroy = true
  }
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_all" {
  name             = "allow-all"
  server_id        = azurerm_postgresql_flexible_server.pg_server.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "255.255.255.255"
}

resource "azurerm_postgresql_flexible_server_database" "db" {
  server_id = azurerm_postgresql_flexible_server.pg_server.id
  name      = var.pg_db_name
  collation = "en_US.utf8"
  charset   = "UTF8"

  lifecycle {
    # prevent_destroy = true
  }
}

# seed db

resource "null_resource" "seed_db" {
  depends_on = [azurerm_postgresql_flexible_server.pg_server, azurerm_postgresql_flexible_server_database.db]

  provisioner "local-exec" {
    environment = {
      PGHOST     = azurerm_postgresql_flexible_server.pg_server.fqdn
      PGUSER     = var.pg_admin_user
      PGPASSWORD = var.pg_admin_password
      PHPORT     = var.pg_port
      PGDATABASE = var.pg_db_name
    }
    command = <<EOT
      psql -f ./scripts/init.sql
    EOT
  }
}



# Backend
