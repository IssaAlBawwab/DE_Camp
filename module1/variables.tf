variable "credentials" {
    description = "service account key"
    default = "../key.json"
  
}
variable "region" {
  description = "region "
  default = "us-central1"
}
variable "project" {
  description = "project "
  default = "fluid-stratum-440314-g5"
}

variable "location" {
  description = "project location"
  default = "US"
}

variable "bq_dataset_name" {
  description = "My bq dataset name"
  default = "demo_dataset"
}
variable "gcs_bucket_name" {
  description = "My storage bucket name"
  default = "fluid-stratum-440314-g5-terra-bucket"
}

variable "gcs_storage_class" {
    description = "gcs bucket class"
    default = "STANDARD"
}