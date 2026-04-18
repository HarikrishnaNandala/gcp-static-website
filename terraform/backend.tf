terraform {
  backend "gcs" {
    bucket = "terraform-gcp-learning-492920-state"
    prefix = "phase5/static-website"    
  }
}