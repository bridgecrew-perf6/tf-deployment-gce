provider "google" {
  project     = var.project_name
  region      = "europe-west4-a"
}

resource "google_service_account" "default" {
  account_id   = var.serviceaccount
  display_name = var.serviceaccount
}

resource "google_compute_instance" "default" {
  name         = "testvm"
  machine_type = "e2-micro"
  zone         = "europe-west4-a"

  tags = ["foo", "bar"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    network = "default"

    access_config {
      # Ephemeral public IP
    }
  }

  metadata = {
    foo = "bar"
  }

  metadata_startup_script = "echo hi > /test.txt"

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.default.email
    scopes = ["cloud-platform"]
  }
}