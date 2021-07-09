terraform {
  required_providers {
    aws = {
      version = ">= 3.22.0"
    }
  }
  backend "remote" {
    organization = "rserag"

    workspaces {
      name = "development"
    }
  }
}
