variable "name_prefix" {
  description = "리소스 이름 앞에 붙는 접두사 (소문자, 숫자, 하이픈)"
  type        = string
  default     = "dev"
}

variable "zone" {
  type    = string
  default = "KR-2"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "ssh_allowed_cidr" {
  description = "SSH(22) 접속을 허용할 IP 대역"
  type        = string
  default     = "0.0.0.0/0"
}

variable "server_image_name_regex" {
  description = "사용할 OS 이미지 이름 (정규식)"
  type        = string
  default     = "ubuntu-22.04.*"
}

variable "server_spec_code" {
  description = "서버 스펙 코드 (예: c2-g3 = 2vCPU/4GB)"
  type        = string
  default     = "c2-g3"
}
