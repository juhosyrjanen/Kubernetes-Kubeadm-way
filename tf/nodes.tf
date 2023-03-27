resource "google_compute_instance" "controller" {
  for_each = toset([ "${var.region}-a", "${var.region}-b", "${var.region}-c" ])

  name         = "controller-${each.key}"
  machine_type = "e2-medium"
  zone         = each.key
  tags = ["allow-ssh"]

  boot_disk {
    initialize_params {
      // Ubuntu
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    network = google_compute_network.kube-vpc.name
    subnetwork = google_compute_subnetwork.kube-subnet.name 
    access_config {
      // Include this section to give the VM an external ip address
    }
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${file(local.public_key_path)}"
  }
}

// Output the public IP addresses of the controller instances
output "controller_public_ips" {
    value = [for instance in google_compute_instance.controller : instance.network_interface[0].access_config[0].nat_ip]
}

resource "google_compute_instance" "worker" {
  for_each = toset([ "${var.region}-a", "${var.region}-b", "${var.region}-c" ])

  name         = "worker-${each.key}"
  machine_type = "f1-micro"
  zone         = each.key
  tags = ["allow-ssh"]

  boot_disk {
    initialize_params {
      // Ubuntu
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    network = google_compute_network.kube-vpc.name
    subnetwork = google_compute_subnetwork.kube-subnet.name 
    access_config {
      // Include this section to give the VM an external ip address
    }
  }
  
  metadata = {
    ssh-keys = "${var.ssh_user}:${file(local.public_key_path)}"
  }
}

// Output the public IP addresses of the worker instances
output "worker_public_ips" {
    value = [for instance in google_compute_instance.worker : instance.network_interface[0].access_config[0].nat_ip]
}

// Pass IPs to Ansible
resource "null_resource" "ansible_provisioner" {
  triggers = {
    controller_public_ips = join(",", values(google_compute_instance.controller)[*].network_interface[0].access_config[0].nat_ip)
    worker_public_ips     = join(",", values(google_compute_instance.worker)[*].network_interface[0].access_config[0].nat_ip)
  }

  provisioner "local-exec" {
    command = "echo '${local.inventory_content}' > ../ansible/inventory.ini" 
    // && ansible-playbook -i inventory.ini playbook.yml"
  }
}

