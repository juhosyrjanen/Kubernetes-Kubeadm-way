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