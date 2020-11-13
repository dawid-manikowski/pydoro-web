terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }

  backend "remote" {
    organization = "LazyDev"

    workspaces {
      name = "production"
    }
  }
}
