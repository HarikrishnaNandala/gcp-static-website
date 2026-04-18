variable "project_id" {
  description = "GCP Project ID"
  type = string
}

variable "region" {
  description = "GCP Region"
  type = string
  default = "us-central1"
}

variable "bucket_name" {
    description = "GCS bucket name for static website"
    type = string
  
}

variable "website_location" {
    description = "GCS bucket location"
    type = string
    default = "US"
  
}