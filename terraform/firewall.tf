resource "google_compute_firewall" "faceitapp" {
  name          = "faceit-firewall-app"
  network       = google_compute_network.faceit.name
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["8080", "22"]
  }
}

resource "google_compute_firewall" "faceitdb" {
  name          = "faceit-firewall-db"
  network       = google_compute_network.faceit.name
  source_ranges = ["192.168.10.0/24"]

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["5432"]
  }
}
