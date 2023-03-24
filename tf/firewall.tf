resource "google_compute_firewall" "ssh-rule" {
  name = "ssh"
  network = google_compute_network.kube-vpc.id
  allow {
    protocol = "tcp"
    ports = ["22"]
  }
  target_tags = ["allow-ssh"]
  source_ranges = ["0.0.0.0/0"]
}
