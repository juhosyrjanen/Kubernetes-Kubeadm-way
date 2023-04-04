// Created outside Terraform
terraform {
  backend "gcs" {
    bucket = "tfstate"
    prefix = "terraform/state"
  }
}
