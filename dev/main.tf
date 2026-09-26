# VPC
resource "ncloud_vpc" "this" {
  name            = "${var.name_prefix}-vpc"
  ipv4_cidr_block = var.vpc_cidr
}

# Network ACL
resource "ncloud_network_acl" "this" {
  vpc_no = ncloud_vpc.this.id
  name   = "${var.name_prefix}-nacl"
}

# NACL은 stateless라서 응답 트래픽(ephemeral port)도 따로 열어줘야 함
resource "ncloud_network_acl_rule" "this" {
  network_acl_no = ncloud_network_acl.this.id

  inbound {
    priority    = 100
    protocol    = "TCP"
    rule_action = "ALLOW"
    ip_block    = var.ssh_allowed_cidr
    port_range  = "22"
    description = "SSH"
  }

  inbound {
    priority    = 110
    protocol    = "TCP"
    rule_action = "ALLOW"
    ip_block    = "0.0.0.0/0"
    port_range  = "1024-65535"
    description = "ephemeral (응답 트래픽)"
  }

  outbound {
    priority    = 100
    protocol    = "TCP"
    rule_action = "ALLOW"
    ip_block    = "0.0.0.0/0"
    port_range  = "1-65535"
    description = "all TCP out"
  }

  outbound {
    priority    = 110
    protocol    = "UDP"
    rule_action = "ALLOW"
    ip_block    = "0.0.0.0/0"
    port_range  = "1-65535"
    description = "all UDP out (DNS 등)"
  }
}

# Subnet (public)
resource "ncloud_subnet" "this" {
  vpc_no         = ncloud_vpc.this.id
  name           = "${var.name_prefix}-subnet"
  subnet         = var.subnet_cidr
  zone           = var.zone
  network_acl_no = ncloud_network_acl.this.id
  subnet_type    = "PUBLIC"
  usage_type     = "GEN"
}

# 서버 로그인용 키 (private key는 state에 저장됨)
resource "ncloud_login_key" "this" {
  key_name = "${var.name_prefix}-key"
}

data "ncloud_server_image_numbers" "this" {
  filter {
    name   = "name"
    values = [var.server_image_name_regex]
    regex  = true
  }
  filter {
    name   = "hypervisor_type"
    values = ["KVM"]
  }
}

# VM
resource "ncloud_server" "this" {
  name                = "${var.name_prefix}-server"
  subnet_no           = ncloud_subnet.this.id
  server_image_number = data.ncloud_server_image_numbers.this.image_number_list[0].server_image_number
  server_spec_code    = var.server_spec_code
  login_key_name      = ncloud_login_key.this.key_name
}
