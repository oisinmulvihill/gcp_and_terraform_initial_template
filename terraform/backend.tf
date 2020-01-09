provider "google" {
  version = "~> 2.5"
  region  = var.region
  zone    = var.zone
}

terraform {
  backend "gcs" {
    bucket = "<your org name>-terraform-admin"
    prefix = "terraform/state"
  }
}
