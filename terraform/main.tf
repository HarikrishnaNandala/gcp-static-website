terraform {
  required_providers {
    google = {
        source = "hashicorp/google"
        version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region = var.region
}

resource "google_storage_bucket" "website" {
    name = var.bucket_name
    location = var.website_location
    storage_class = "STANDARD"
    force_destroy = true
    
    website {
        main_page_suffix = "index.html"
        not_found_page = "404.html"
    }
  


    ## Allow public access #¤
    uniform_bucket_level_access = false

    versioning {
        enabled = false
    }
}
resource "google_storage_bucket_iam_member" "public_read" {
    bucket = google_storage_bucket.website.name
    role = "roles/storage.objectViewer"
    member = "allUsers"
}

# -------------------------------------------------------
# Reserve a Global Static IP
# -------------------------------------------------------

resource "google_compute_global_address" "website_ip" {
  name = "website-static-ip"
}

# -------------------------------------------------------
# Backend Bucket — connects Load Balancer to GCS
# -------------------------------------------------------

resource "google_compute_backend_bucket" "website_backend" {
  name        = "website-backend-bucket"
  bucket_name = google_storage_bucket.website.name
  enable_cdn  = true

  cdn_policy {
    cache_mode        = "CACHE_ALL_STATIC"
    default_ttl       = 3600   # 1 hour
    max_ttl           = 86400  # 24 hours
    client_ttl        = 3600   # 1 hour
    serve_while_stale = 86400  # serve stale content for 24hrs if origin is down
  }
}

# -------------------------------------------------------
# URL Map — routes all traffic to backend bucket
# -------------------------------------------------------

resource "google_compute_url_map" "website_url_map" {
  name            = "website-url-map"
  default_service = google_compute_backend_bucket.website_backend.self_link
}

# -------------------------------------------------------
# HTTP Target Proxy
# -------------------------------------------------------

resource "google_compute_target_http_proxy" "website_http_proxy" {
  name    = "website-http-proxy"
  url_map = google_compute_url_map.website_url_map.self_link
}

# -------------------------------------------------------
# Global Forwarding Rule — entry point for traffic
# -------------------------------------------------------

resource "google_compute_global_forwarding_rule" "website_forwarding_rule" {
  name                  = "website-forwarding-rule"
  load_balancing_scheme = "EXTERNAL"
  ip_address            = google_compute_global_address.website_ip.address
  ip_protocol           = "TCP"
  port_range            = "80"
  target                = google_compute_target_http_proxy.website_http_proxy.self_link
}


