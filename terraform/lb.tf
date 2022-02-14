resource "google_compute_forwarding_rule" "faceit-lb" {
  name            = "faceit-lb"
  region          = var.region
  port_range      = 8080
  ip_protocol     = "TCP"
  backend_service = google_compute_region_backend_service.backend.id
}
resource "google_compute_region_backend_service" "backend" {
  name                  = "backend"
  region                = var.region
  load_balancing_scheme = "EXTERNAL"
  health_checks         = [google_compute_region_health_check.faceit-hc.id]
  backend {
    group = google_compute_instance_group_manager.faceit-group.instance_group
  }
}
resource "google_compute_region_health_check" "faceit-hc" {
  name   = "faceit-hc"
  region = var.region

  http_health_check {
    port         = "8080"
    request_path = "/health"
  }
}
