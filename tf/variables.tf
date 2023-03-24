locals {
  public_key_path  = "../id_rsa.pub"
  private_key_path = "../id_rsa"

  inventory_content = templatefile("../ansible/inventory.tpl", {
    controller_public_ips = [for instance in google_compute_instance.controller : instance.network_interface[0].access_config[0].nat_ip]
    worker_public_ips     = [for instance in google_compute_instance.worker : instance.network_interface[0].access_config[0].nat_ip]

  })

}

// Fill out variables to fit your GCP project
variable "project" {
  type        = string
  description = "The project ID to deploy to"
  default     = "juhos-sandbox"
}

variable "region" {
  type        = string
  description = "The region to deploy to"
  default     = "europe-north1"
}

variable "ssh_user" {
  type        = string
  description = "The user to SSH as"
  default     = "kube"
}


