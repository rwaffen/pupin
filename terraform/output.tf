
output "server_ip_list" {
  value = {
    for instance, data in hcloud_server.nodes:
      instance => data.ipv4_address
  }
}
