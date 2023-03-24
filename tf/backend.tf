// Created outside Terraform
terraform {
  backend "gcs" {
    bucket = "juhos-sandbox-tfstate"
    prefix = "terraform/state"
  }
}
