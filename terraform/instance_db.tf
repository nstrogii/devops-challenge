resource "google_compute_instance" "db-instance" {
  name         = "db-instance"
  machine_type = "f1-micro"

  boot_disk {
    auto_delete = "true"

    initialize_params {
      image = "https://www.googleapis.com/compute/v1/projects/cos-cloud/global/images/cos-stable-93-16623-102-8"
      size  = "10"
      type  = "pd-balanced"
    }
  }

  metadata = {
    gce-container-declaration = <<EOT
spec:
  containers:
    - image: postgres:13-alpine
      name: faceit
      securityContext:
        privileged: true
      env:
        - name: POSTGRES_USER
          value: ${var.application.postgresql_user}
        - name: POSTGRES_PASSWORD
          value: ${var.application.postgresql_password}
        - name: POSTGRES_DB
          value: ${var.application.postgresql_dbname}
      stdin: false
      tty: false
      volumeMounts: []
      restartPolicy: Always
      volumes: []
EOT
    ssh-keys                  = join("\n", [for key in var.ssh_keys : "${key.user}:${key.publickey}"])
  }

  labels = {
    container-vm = "cos-stable-93-16623-102-8"
  }
  network_interface {
    # A default network is created for all GCP projects
    subnetwork = google_compute_subnetwork.faceit.id
    # Uncomment below 2 line if need ssh access
    # access_config {
    # }
  }
}
