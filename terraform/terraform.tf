terraform {
  required_providers {
    hetznerdns = {
      source = "timohirt/hetznerdns"
    }
    hcloud = {
      source = "hetznercloud/hcloud"
    }
  }
  required_version = ">= 0.14"
}

# Configure the Hetzner Cloud Provider
provider "hcloud" {
  token   = var.hcloud_token
}

# Configure Hetzner DNS Provider
provider "hetznerdns" {
  apitoken = var.hdns_token
}
