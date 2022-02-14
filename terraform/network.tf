resource "google_compute_network" "faceit" {
  name                    = "faceit-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "faceit" {
  name          = "faceit-subnetwork"
  ip_cidr_range = "192.168.10.0/24"
  region        = var.region
  network       = google_compute_network.faceit.id
}
