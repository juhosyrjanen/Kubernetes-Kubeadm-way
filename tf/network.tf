// Terraform GCP VPC and Subnets    
resource "google_compute_network" "kube-vpc" {
  project                 = var.project
  name                    = "kube-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "kube-subnet" {
  name          = "kube-subnet"
  ip_cidr_range = "10.1.0.0/24"
  region        = var.region
  network       = google_compute_network.kube-vpc.id

}

resource "google_compute_address" "kubernetes_public_address" {
  name   = "kubernetes-ip"
  region = var.region
}

resource "google_compute_http_health_check" "kubernetes" {
  name = "kubernetes-health-check"

  host         = "kubernetes.default.svc.cluster.local"
  request_path = "/healthz"
  port         = 80
}

resource "google_compute_target_pool" "kubernetes" {
  name   = "kubernetes-target-pool"
  region = var.region
  health_checks = [
    google_compute_http_health_check.kubernetes.self_link
  ]
  instances = [
    for instance in google_compute_instance.controller : instance.self_link
  ]
}

resource "google_compute_forwarding_rule" "kubernetes" {
  name        = "kubernetes-forwarding-rule"
  region      = var.region
  ip_protocol = "TCP"
  port_range  = "6443"
  target      = google_compute_target_pool.kubernetes.self_link
  ip_address  = google_compute_address.kubernetes_public_address.address
}

output "kubernetes_lb_ip" {
  value = google_compute_forwarding_rule.kubernetes.ip_address
}
resource "null_resource" "write_lb_ip_to_file" {
  depends_on = [google_compute_forwarding_rule.kubernetes]

  provisioner "local-exec" {
    command = "echo 'kubernetes_lb_ip: ${google_compute_forwarding_rule.kubernetes.ip_address}' > ../ansible/group_vars/all.yaml"
  }
}

