terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.10.0"
    }
  }
}

provider "google" {
  credentials = file("key2.json")
  project     = var.project
  region      = var.region
  zone        = var.zone
}
