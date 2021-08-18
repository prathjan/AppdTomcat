
# Configure the VMware vSphere Provider
provider "vsphere" {
  user           = var.vsphere_user
  password       = var.vsphere_password
  vsphere_server = var.vsphere_server

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

terraform {
  required_providers {
    mysql = {
      source = "petoju/mysql"
      version = "3.0.6"
    }
  }
}

