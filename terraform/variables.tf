# Set the variable value in *.tfvars file
# or using the -var="hcloud_token=..." CLI option

variable "hcloud_token" {
  type        = string
  description = "The 64 digit API token"
}

variable "hdns_token" {
  type        = string
  description = "The DNS API token"
}

variable "machines" {
  type = map
  description = "Hash of IP, Role, HW size to use for student maschines."
  default = {
    "puppetca" = { ip = "10.0.8.7",  server_type = "cx21", image = "centos-8" }
    "puppet"   = { ip = "10.0.8.8",  server_type = "cx21", image = "centos-8" }
    "puppetdb" = { ip = "10.0.8.9",  server_type = "cx11", image = "centos-7" } # use centos/7 because puppetlabs-puppetdb does not work on centos/8 yet
    "agent01"  = { ip = "10.0.8.11", server_type = "cx11", image = "centos-8" }
  }
}
