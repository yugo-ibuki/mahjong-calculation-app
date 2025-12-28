# 開発環境構成
# Firebase, Firestore, Monitoring モジュールを使用

terraform {
  required_version = ">= 1.6.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
}

# Firebase
module "firebase" {
  source = "../../modules/firebase"

  project_id  = var.project_id
  region      = var.region
  environment = "dev"
}

# Firestore
module "firestore" {
  source = "../../modules/firestore"

  project_id  = var.project_id
  region      = var.region
  environment = "dev"

  depends_on = [module.firebase]
}

# Monitoring
module "monitoring" {
  source = "../../modules/monitoring"

  project_id  = var.project_id
  environment = "dev"
  alert_email = var.alert_email
}
