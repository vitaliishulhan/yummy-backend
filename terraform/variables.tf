variable "app_name" {
  type    = string
  default = "yummy"
}

variable "location" {
  type = string
}

variable "pg_port" {
  type    = number
  default = 5432
}

variable "pg_db_name" {
  type = string
}

variable "pg_admin_user" {
  type = string
}

variable "pg_admin_password" {
  type      = string
  sensitive = true
}

variable "subscription_id" {
  type = string
}