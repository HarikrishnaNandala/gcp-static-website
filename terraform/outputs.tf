output "bucket_name" {
  description = "The name of the GCS website bucket"
  value = google_storage_bucket.website.name
}

output "website_url" {
  description = "Direct GCS website URL"
  value = "https://storage.googleapis.com/${google_storage_bucket.website.name}/index.html"
}

output "bucket_self_link" {
  description = "Bucket self link (used by CDN backend)"
  value = google_storage_bucket.website.self_link
}

output "load_balancer_ip" {
  description = "Global Load Balancer IP — use this to access your site"
  value       = google_compute_global_address.website_ip.address
}

output "cdn_website_url" {
  description = "Website URL via Load Balancer + CDN"
  value       = "http://${google_compute_global_address.website_ip.address}"
}
