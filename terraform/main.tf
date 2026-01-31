resource "google_compute_network" "vpc" {
  name                    = "${var.name_prefix}-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "private_subnet" {
  name                     = "${var.name_prefix}-private-subnet"
  ip_cidr_range            = "10.10.0.0/20"
  region                   = var.region
  network                  = google_compute_network.vpc.id
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "public_subnet" {
  name          = "${var.name_prefix}-public-subnet"
  ip_cidr_range = "10.10.16.0/20"
  region        = var.region
  network       = google_compute_network.vpc.id
}

resource "google_container_cluster" "primary" {
  name     = "${var.name_prefix}-gke"
  location = var.region
  network  = google_compute_network.vpc.id
  #    subnetwork = google_compute_subnetwork.private.id
  initial_node_count       = 1
  remove_default_node_pool = true
  ip_allocation_policy {}
}

resource "google_container_node_pool" "primary_nodes" {
  name     = "hackathon-node-pool"
  cluster  = google_container_cluster.primary.name
  location = var.region


  node_config {
    machine_type = "e2-micro"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  initial_node_count = 2
}