provider "google" {
  version = "~> 2.5"
  region  = "${var.region}"
  zone    = "${var.zone}"
}

terraform {
  backend "gcs" {
    bucket = "terraform-admin-shared-state"
    prefix = "terraform/state"
  }
}
