resource "google_compute_firewall" "ssh-rule" {
  name    = "ssh"
  network = google_compute_network.kube-vpc.id
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  target_tags   = ["allow-ssh"]
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "controlplane" {
  name    = "controlplane"
  network = google_compute_network.kube-vpc.id
  allow {
    protocol = "tcp"
    ports    = ["6443", "80"]
  }
  target_tags   = ["allow-controlplane"]
  source_ranges = ["0.0.0.0/0"]
}

// Allow all internal traffic
resource "google_compute_firewall" "internal" {
  name    = "internal"
  network = google_compute_network.kube-vpc.id
  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "icmp"
  }
  target_tags   = ["allow-internal"]
  source_ranges = [ for instance in google_compute_instance.controller : instance.network_interface[0].access_config[0].nat_ip ]
}

