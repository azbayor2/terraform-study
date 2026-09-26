terraform {
  required_providers {
    ncloud = {
      source = "NaverCloudPlatform/ncloud"
    }
  }

  backend "s3" {
    bucket = "azbayor2-terraform-state"
    region = "KR"
    key    = "remote-state/terraform.tfstate"

    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_s3_checksum            = true

    use_lockfile = true

    endpoints = {
      s3 = "https://kr.object.ncloudstorage.com"
    }
  }
}