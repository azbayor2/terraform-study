output "vpc_id" {
  value = ncloud_vpc.this.id
}

output "subnet_id" {
  value = ncloud_subnet.this.id
}

output "network_acl_id" {
  value = ncloud_network_acl.this.id
}

output "server_id" {
  value = ncloud_server.this.id
}

output "server_private_ip" {
  value = ncloud_server.this.network_interface[0].private_ip
}

output "login_key_private_key" {
  value     = ncloud_login_key.this.private_key
  sensitive = true
}
