output "bucket_name" {
  description = "The name of the GCS website bucket"
  value = google_storage_bucket.gcp-static-website_492920.name
}

output "website_url" {
  description = "Direct GCS website URL"
  value = "https://storage.googleapis.com/${google_storage_bucket.gcp-static-website_492920.name}/index.html"
}

output "bucket_self_link" {
  description = "Bucket self link (used by CDN backend)"
  value = google_storage_bucket.gcp-static-website_492920.self_link
}

output "load_balancer_ip" {
  description = "Global Load Balancer IP — use this to access your site"
  value       = google_compute_global_address.gcp-static-website_492920.address
}

output "cdn_website_url" {
  description = "Website URL via Load Balancer + CDN"
  value       = "http://${google_compute_global_address.gcp-static-website_492920.address}"
}
