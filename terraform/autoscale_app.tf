resource "google_compute_autoscaler" "faceit-autoscaler" {
  name   = "aceit-autoscaler"
  zone   = var.zone
  target = google_compute_instance_group_manager.faceit-group.id

  autoscaling_policy {
    max_replicas    = 3
    min_replicas    = 2
    cooldown_period = 60

    cpu_utilization {
      target = 0.5
    }
  }
}

resource "google_compute_instance_template" "faceit-template" {
  name         = "faceit-template"
  machine_type = "f1-micro"
  region       = var.region

  disk {
    source_image = "projects/confidential-vm-images/global/images/cos-stable-93-16623-102-8"
    auto_delete  = true
    boot         = true
  }

  metadata = {
    gce-container-declaration = <<EOT
spec:
  containers:
    - image: ${var.application.image}
      name: faceit
      securityContext:
        privileged: true
      env:
        - name: POSTGRESQL_HOST
          value: "${google_compute_instance.db-instance.network_interface.0.network_ip}"
        - name: POSTGRESQL_PORT
          value: ${var.application.postgresql_port}
        - name: POSTGRESQL_USER
          value: ${var.application.postgresql_user}
        - name: POSTGRESQL_PASSWORD
          value: ${var.application.postgresql_password}
        - name: POSTGRESQL_DBNAME
          value: ${var.application.postgresql_dbname}
      stdin: false
      tty: false
      volumeMounts: []
      restartPolicy: Always
      volumes: []
EOT
    ssh-keys                  = join("\n", [for key in var.ssh_keys : "${key.user}:${key.publickey}"])
  }

  network_interface {
    subnetwork = google_compute_subnetwork.faceit.id
    # Uncomment below 2 line if need ssh access
    # access_config {
    # }
  }
}

resource "google_compute_target_pool" "faceit-pool" {
  name = "faceit-pool"
}

resource "google_compute_instance_group_manager" "faceit-group" {
  name = "faceit-group"
  zone = var.zone

  version {
    instance_template = google_compute_instance_template.faceit-template.id
    name              = "primary"
  }

  target_pools       = [google_compute_target_pool.faceit-pool.id]
  base_instance_name = "faceitapp"
}
