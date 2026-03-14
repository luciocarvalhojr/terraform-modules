terraform {
  required_version = ">= 1.9.0"

  required_providers {
    technitium = {
      source  = "clouddns/technitium"
      version = ">= 1.0.0"
    }
  }
}
