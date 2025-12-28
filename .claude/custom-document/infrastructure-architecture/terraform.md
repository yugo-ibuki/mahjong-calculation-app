# Terraform インフラ構成

Terraform による GCP リソースの IaC (Infrastructure as Code) 管理。
**GCP プロジェクト作成から全リソースを Terraform で管理**。

---

## 前提条件（手動で必要な作業）

> [!IMPORTANT]
> 以下は Terraform 実行前に一度だけ手動で行う作業です。

1. **GCP 組織** または **フォルダ** が存在すること
2. **課金アカウント (Billing Account)** が有効であること
3. **ブートストラップ用サービスアカウント** の作成

### ブートストラップ手順

```bash
# 1. gcloud 認証
gcloud auth login

# 2. ブートストラップ用プロジェクト作成 (組織管理用)
gcloud projects create mahjong-bootstrap --organization=ORG_ID

# 3. 課金アカウント紐付け
gcloud billing projects link mahjong-bootstrap \
  --billing-account=BILLING_ACCOUNT_ID

# 4. 必要な API 有効化
gcloud services enable \
  cloudresourcemanager.googleapis.com \
  cloudbilling.googleapis.com \
  iam.googleapis.com \
  firebase.googleapis.com \
  --project=mahjong-bootstrap

# 5. Terraform 用サービスアカウント作成
gcloud iam service-accounts create terraform \
  --display-name="Terraform Service Account" \
  --project=mahjong-bootstrap

# 6. 組織レベルの権限付与
gcloud organizations add-iam-policy-binding ORG_ID \
  --member="serviceAccount:terraform@mahjong-bootstrap.iam.gserviceaccount.com" \
  --role="roles/resourcemanager.projectCreator"

gcloud organizations add-iam-policy-binding ORG_ID \
  --member="serviceAccount:terraform@mahjong-bootstrap.iam.gserviceaccount.com" \
  --role="roles/billing.user"

# 7. サービスアカウントキー作成
gcloud iam service-accounts keys create terraform-key.json \
  --iam-account=terraform@mahjong-bootstrap.iam.gserviceaccount.com
```

---

## ディレクトリ構成

```
terraform/
├── bootstrap/                  # 初期セットアップ (プロジェクト作成)
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── environments/
│   ├── dev/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── terraform.tfvars
│   │   └── backend.tf
│   └── prod/
│       ├── main.tf
│       ├── variables.tf
│       ├── terraform.tfvars
│       └── backend.tf
├── modules/
│   ├── project/                # GCPプロジェクト作成
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── firebase/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── cloud-functions/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── firestore/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── monitoring/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
└── shared/
    ├── providers.tf
    └── versions.tf
```

---

## GCP プロジェクト作成モジュール

### modules/project/main.tf

```hcl
# ランダムサフィックス (プロジェクトIDの一意性確保)
resource "random_id" "project" {
  byte_length = 4
}

# GCP プロジェクト作成
resource "google_project" "main" {
  name            = var.project_name
  project_id      = "${var.project_id_prefix}-${random_id.project.hex}"
  org_id          = var.org_id
  folder_id       = var.folder_id  # 組織直下でない場合
  billing_account = var.billing_account

  labels = {
    environment = var.environment
    managed_by  = "terraform"
  }
}

# 必要な API を有効化
resource "google_project_service" "apis" {
  for_each = toset([
    "firebase.googleapis.com",
    "firebasestorage.googleapis.com",
    "firestore.googleapis.com",
    "cloudfunctions.googleapis.com",
    "run.googleapis.com",
    "cloudbuild.googleapis.com",
    "artifactregistry.googleapis.com",
    "secretmanager.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "cloudresourcemanager.googleapis.com",
  ])

  project                    = google_project.main.project_id
  service                    = each.value
  disable_on_destroy         = false
  disable_dependent_services = false
}

# Terraform 状態管理用バケット
resource "google_storage_bucket" "terraform_state" {
  project       = google_project.main.project_id
  name          = "${google_project.main.project_id}-terraform-state"
  location      = var.region
  force_destroy = var.environment != "prod"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    condition {
      num_newer_versions = 5
    }
    action {
      type = "Delete"
    }
  }

  depends_on = [google_project_service.apis]
}
```

### modules/project/variables.tf

```hcl
variable "project_name" {
  description = "Human-readable project name"
  type        = string
}

variable "project_id_prefix" {
  description = "Project ID prefix (suffix will be auto-generated)"
  type        = string
}

variable "org_id" {
  description = "GCP Organization ID"
  type        = string
  default     = null
}

variable "folder_id" {
  description = "GCP Folder ID (if not directly under org)"
  type        = string
  default     = null
}

variable "billing_account" {
  description = "Billing Account ID"
  type        = string
}

variable "environment" {
  description = "Environment (dev/prod)"
  type        = string
}

variable "region" {
  description = "Default region"
  type        = string
  default     = "asia-northeast1"
}
```

### modules/project/outputs.tf

```hcl
output "project_id" {
  description = "Created project ID"
  value       = google_project.main.project_id
}

output "project_number" {
  description = "Created project number"
  value       = google_project.main.number
}

output "terraform_state_bucket" {
  description = "Terraform state bucket name"
  value       = google_storage_bucket.terraform_state.name
}
```

---

## 環境別プロジェクト作成

### environments/dev/main.tf

```hcl
# プロジェクト作成
module "project" {
  source = "../../modules/project"

  project_name      = "Mahjong Calculator Dev"
  project_id_prefix = "mahjong-dev"
  org_id            = var.org_id
  billing_account   = var.billing_account
  environment       = "dev"
  region            = var.region
}

# Firebase 有効化
module "firebase" {
  source = "../../modules/firebase"

  project_id  = module.project.project_id
  region      = var.region
  environment = "dev"

  depends_on = [module.project]
}

# Firestore
module "firestore" {
  source = "../../modules/firestore"

  project_id  = module.project.project_id
  region      = var.region
  environment = "dev"

  depends_on = [module.firebase]
}

# Cloud Functions
module "cloud_functions" {
  source = "../../modules/cloud-functions"

  project_id         = module.project.project_id
  region             = var.region
  environment        = "dev"
  min_instance_count = 0   # コスト節約
  max_instance_count = 10

  depends_on = [module.firebase, module.firestore]
}

# 監視
module "monitoring" {
  source = "../../modules/monitoring"

  project_id  = module.project.project_id
  environment = "dev"
  alert_email = var.alert_email
}
```

### environments/dev/variables.tf

```hcl
variable "org_id" {
  description = "GCP Organization ID"
  type        = string
}

variable "billing_account" {
  description = "Billing Account ID"
  type        = string
}

variable "region" {
  description = "Default region"
  type        = string
  default     = "asia-northeast1"
}

variable "alert_email" {
  description = "Email for alerts"
  type        = string
}
```

### environments/dev/terraform.tfvars

```hcl
org_id          = "123456789012"           # 要変更
billing_account = "XXXXX-XXXXXX-XXXXXX"    # 要変更
region          = "asia-northeast1"
alert_email     = "dev-alerts@example.com"
```

### environments/prod/terraform.tfvars

```hcl
org_id          = "123456789012"           # 要変更
billing_account = "XXXXX-XXXXXX-XXXXXX"    # 要変更
region          = "asia-northeast1"
alert_email     = "prod-alerts@example.com"
```

---

## デプロイフロー

### 1. 開発環境作成

```bash
cd terraform/environments/dev

# 初期化 (ローカル状態で開始)
terraform init

# プラン確認
terraform plan

# 適用 (プロジェクト作成)
terraform apply

# 出力確認
terraform output project_id
# => mahjong-dev-a1b2c3d4
```

### 2. バックエンド移行 (GCS へ)

プロジェクト作成後、状態を GCS バケットに移行:

```hcl
# environments/dev/backend.tf
terraform {
  backend "gcs" {
    bucket = "mahjong-dev-a1b2c3d4-terraform-state"  # 出力値を使用
    prefix = "terraform/state"
  }
}
```

```bash
# バックエンド移行
terraform init -migrate-state
```

### 3. 本番環境作成

```bash
cd terraform/environments/prod
terraform init
terraform plan
terraform apply
```

---

## 環境一覧確認

```bash
# 開発環境
cd terraform/environments/dev
terraform output

# 出力例:
# project_id = "mahjong-dev-a1b2c3d4"
# project_number = "123456789012"
# terraform_state_bucket = "mahjong-dev-a1b2c3d4-terraform-state"

# 本番環境
cd terraform/environments/prod
terraform output

# 出力例:
# project_id = "mahjong-prod-e5f6g7h8"
# project_number = "987654321098"
# terraform_state_bucket = "mahjong-prod-e5f6g7h8-terraform-state"
```

---

## プロバイダー設定

```hcl
# shared/versions.tf
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

# shared/providers.tf
provider "google" {
  project = var.project_id
  region  = var.region
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
}
```

---

## 環境別設定

### 開発環境

```hcl
# environments/dev/main.tf
module "firebase" {
  source = "../../modules/firebase"

  project_id   = var.project_id
  region       = var.region
  environment  = "dev"
}

module "firestore" {
  source = "../../modules/firestore"

  project_id  = var.project_id
  region      = var.region
  environment = "dev"

  depends_on = [module.firebase]
}

module "cloud_functions" {
  source = "../../modules/cloud-functions"

  project_id            = var.project_id
  region                = var.region
  environment           = "dev"
  min_instance_count    = 0
  max_instance_count    = 10

  depends_on = [module.firebase, module.firestore]
}

module "monitoring" {
  source = "../../modules/monitoring"

  project_id   = var.project_id
  environment  = "dev"
  alert_email  = var.alert_email
}
```

```hcl
# environments/dev/terraform.tfvars
project_id  = "mahjong-dev"
region      = "asia-northeast1"
alert_email = "dev-alerts@example.com"
```

```hcl
# environments/dev/backend.tf
terraform {
  backend "gcs" {
    bucket = "mahjong-dev-terraform-state"
    prefix = "terraform/state"
  }
}
```

### 本番環境

```hcl
# environments/prod/terraform.tfvars
project_id  = "mahjong-prod"
region      = "asia-northeast1"
alert_email = "prod-alerts@example.com"
```

---

## モジュール詳細

### Firebase モジュール

```hcl
# modules/firebase/main.tf
resource "google_firebase_project" "default" {
  provider = google-beta
  project  = var.project_id
}

# App Check 設定
resource "google_firebase_app_check_service_config" "functions" {
  provider = google-beta
  project  = var.project_id
  service_id = "firebasefunctions.googleapis.com"
  enforcement_mode = var.environment == "prod" ? "ENFORCED" : "UNENFORCED"
  
  depends_on = [google_firebase_project.default]
}

# iOS アプリ登録
resource "google_firebase_apple_app" "ios" {
  provider     = google-beta
  project      = var.project_id
  display_name = "Mahjong Calculator iOS"
  bundle_id    = var.ios_bundle_id
  team_id      = var.ios_team_id

  depends_on = [google_firebase_project.default]
}

# Android アプリ登録
resource "google_firebase_android_app" "android" {
  provider     = google-beta
  project      = var.project_id
  display_name = "Mahjong Calculator Android"
  package_name = var.android_package_name

  depends_on = [google_firebase_project.default]
}

# Web アプリ登録
resource "google_firebase_web_app" "web" {
  provider     = google-beta
  project      = var.project_id
  display_name = "Mahjong Calculator Web"

  depends_on = [google_firebase_project.default]
}
```

```hcl
# modules/firebase/variables.tf
variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "asia-northeast1"
}

variable "environment" {
  description = "Environment (dev/prod)"
  type        = string
}

variable "ios_bundle_id" {
  description = "iOS Bundle ID"
  type        = string
  default     = "com.example.mahjong"
}

variable "ios_team_id" {
  description = "Apple Team ID"
  type        = string
  default     = ""
}

variable "android_package_name" {
  description = "Android Package Name"
  type        = string
  default     = "com.example.mahjong"
}
```

### Firestore モジュール

```hcl
# modules/firestore/main.tf
resource "google_firestore_database" "default" {
  provider         = google-beta
  project          = var.project_id
  name             = "(default)"
  location_id      = var.region
  type             = "FIRESTORE_NATIVE"
  deletion_policy  = var.environment == "prod" ? "DELETE_PROTECTION" : "DELETE"
}

# セキュリティルール
resource "google_firebaserules_ruleset" "firestore" {
  provider = google-beta
  project  = var.project_id

  source {
    files {
      name    = "firestore.rules"
      content = file("${path.module}/rules/firestore.rules")
    }
  }

  depends_on = [google_firestore_database.default]
}

resource "google_firebaserules_release" "firestore" {
  provider     = google-beta
  project      = var.project_id
  name         = "cloud.firestore"
  ruleset_name = google_firebaserules_ruleset.firestore.name
}

# インデックス
resource "google_firestore_index" "history_user_created" {
  provider    = google-beta
  project     = var.project_id
  database    = google_firestore_database.default.name
  collection  = "history"

  fields {
    field_path = "userId"
    order      = "ASCENDING"
  }

  fields {
    field_path = "createdAt"
    order      = "DESCENDING"
  }
}
```

### Cloud Functions モジュール

```hcl
# modules/cloud-functions/main.tf

# サービスアカウント
resource "google_service_account" "functions" {
  project      = var.project_id
  account_id   = "cloud-functions-${var.environment}"
  display_name = "Cloud Functions Service Account"
}

# IAM
resource "google_project_iam_member" "functions_firestore" {
  project = var.project_id
  role    = "roles/datastore.user"
  member  = "serviceAccount:${google_service_account.functions.email}"
}

# Cloud Functions (2nd gen)
resource "google_cloudfunctions2_function" "calculate_score" {
  provider = google-beta
  project  = var.project_id
  name     = "calculateScore"
  location = var.region

  build_config {
    runtime     = "nodejs20"
    entry_point = "calculateScore"
    source {
      storage_source {
        bucket = google_storage_bucket.functions_source.name
        object = google_storage_bucket_object.functions_zip.name
      }
    }
  }

  service_config {
    min_instance_count               = var.min_instance_count
    max_instance_count               = var.max_instance_count
    available_memory                 = "256Mi"
    timeout_seconds                  = 30
    service_account_email            = google_service_account.functions.email
    ingress_settings                 = "ALLOW_ALL"
    all_traffic_on_latest_revision   = true
  }
}

resource "google_cloudfunctions2_function" "get_history" {
  provider = google-beta
  project  = var.project_id
  name     = "getHistory"
  location = var.region

  build_config {
    runtime     = "nodejs20"
    entry_point = "getHistory"
    source {
      storage_source {
        bucket = google_storage_bucket.functions_source.name
        object = google_storage_bucket_object.functions_zip.name
      }
    }
  }

  service_config {
    min_instance_count               = var.min_instance_count
    max_instance_count               = var.max_instance_count
    available_memory                 = "256Mi"
    timeout_seconds                  = 30
    service_account_email            = google_service_account.functions.email
    ingress_settings                 = "ALLOW_ALL"
    all_traffic_on_latest_revision   = true
  }
}

resource "google_cloudfunctions2_function" "save_history" {
  provider = google-beta
  project  = var.project_id
  name     = "saveHistory"
  location = var.region

  build_config {
    runtime     = "nodejs20"
    entry_point = "saveHistory"
    source {
      storage_source {
        bucket = google_storage_bucket.functions_source.name
        object = google_storage_bucket_object.functions_zip.name
      }
    }
  }

  service_config {
    min_instance_count               = var.min_instance_count
    max_instance_count               = var.max_instance_count
    available_memory                 = "256Mi"
    timeout_seconds                  = 30
    service_account_email            = google_service_account.functions.email
    ingress_settings                 = "ALLOW_ALL"
    all_traffic_on_latest_revision   = true
  }
}

# ソースコード用 Storage
resource "google_storage_bucket" "functions_source" {
  project       = var.project_id
  name          = "${var.project_id}-functions-source"
  location      = var.region
  force_destroy = var.environment != "prod"

  versioning {
    enabled = true
  }
}
```

```hcl
# modules/cloud-functions/variables.tf
variable "project_id" {
  type = string
}

variable "region" {
  type    = string
  default = "asia-northeast1"
}

variable "environment" {
  type = string
}

variable "min_instance_count" {
  type    = number
  default = 0
}

variable "max_instance_count" {
  type    = number
  default = 100
}
```

### Monitoring モジュール

```hcl
# modules/monitoring/main.tf

# 通知チャンネル
resource "google_monitoring_notification_channel" "email" {
  project      = var.project_id
  display_name = "Email Alerts"
  type         = "email"
  
  labels = {
    email_address = var.alert_email
  }
}

# アラートポリシー: エラー率
resource "google_monitoring_alert_policy" "function_errors" {
  project      = var.project_id
  display_name = "Cloud Functions Error Rate"
  combiner     = "OR"

  conditions {
    display_name = "Error rate > 1%"

    condition_threshold {
      filter          = "resource.type=\"cloud_run_revision\" AND metric.type=\"run.googleapis.com/request_count\" AND metric.label.response_code_class!=\"2xx\""
      duration        = "300s"
      threshold_value = 0.01
      comparison      = "COMPARISON_GT"

      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_RATE"
      }
    }
  }

  notification_channels = [google_monitoring_notification_channel.email.name]

  alert_strategy {
    auto_close = "1800s"
  }
}

# アラートポリシー: レイテンシ
resource "google_monitoring_alert_policy" "function_latency" {
  project      = var.project_id
  display_name = "Cloud Functions High Latency"
  combiner     = "OR"

  conditions {
    display_name = "p99 Latency > 2s"

    condition_threshold {
      filter          = "resource.type=\"cloud_run_revision\" AND metric.type=\"run.googleapis.com/request_latencies\""
      duration        = "300s"
      threshold_value = 2000
      comparison      = "COMPARISON_GT"

      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_PERCENTILE_99"
      }
    }
  }

  notification_channels = [google_monitoring_notification_channel.email.name]
}

# ダッシュボード
resource "google_monitoring_dashboard" "main" {
  project        = var.project_id
  dashboard_json = file("${path.module}/dashboards/main.json")
}
```

---

## 運用コマンド

### 初期化

```bash
cd terraform/environments/dev

# 初期化
terraform init

# プラン確認
terraform plan

# 適用
terraform apply
```

### 環境別デプロイ

```bash
# 開発環境
cd terraform/environments/dev
terraform apply -auto-approve

# 本番環境 (確認必須)
cd terraform/environments/prod
terraform plan -out=plan.tfplan
terraform apply plan.tfplan
```

### 状態管理

```bash
# 状態の確認
terraform state list

# リソースのインポート (既存リソース取込)
terraform import google_firestore_database.default projects/PROJECT_ID/databases/(default)

# 状態の更新
terraform refresh
```

### ロールバック

```bash
# 過去の状態に戻す
terraform state pull > current.tfstate
# 戻したい状態を current.tfstate に編集
terraform state push current.tfstate
terraform apply
```

---

## CI/CD 統合

### GitHub Actions

```yaml
# .github/workflows/terraform.yml
name: Terraform

on:
  push:
    branches: [main]
    paths:
      - 'terraform/**'
  pull_request:
    paths:
      - 'terraform/**'

jobs:
  plan:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - uses: hashicorp/setup-terraform@v3
        with:
          terraform_version: "1.6.0"
      
      - uses: google-github-actions/auth@v1
        with:
          credentials_json: ${{ secrets.GCP_SA_KEY }}
      
      - name: Terraform Init
        run: terraform init
        working-directory: terraform/environments/dev
      
      - name: Terraform Plan
        run: terraform plan -no-color
        working-directory: terraform/environments/dev

  apply:
    needs: plan
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    environment: production
    steps:
      - uses: actions/checkout@v4
      
      - uses: hashicorp/setup-terraform@v3
      
      - uses: google-github-actions/auth@v1
        with:
          credentials_json: ${{ secrets.GCP_SA_KEY }}
      
      - name: Terraform Apply
        run: |
          terraform init
          terraform apply -auto-approve
        working-directory: terraform/environments/prod
```

---

## セキュリティ考慮

### 状態ファイル保護

```hcl
# GCS バケット暗号化
resource "google_storage_bucket" "terraform_state" {
  name     = "${var.project_id}-terraform-state"
  location = var.region
  
  versioning {
    enabled = true
  }
  
  encryption {
    default_kms_key_name = google_kms_crypto_key.terraform.id
  }
}
```

### シークレット管理

```hcl
# Secret Manager 使用
data "google_secret_manager_secret_version" "api_key" {
  secret = "api-key"
}

resource "google_cloudfunctions2_function" "example" {
  # ...
  service_config {
    environment_variables = {
      API_KEY = data.google_secret_manager_secret_version.api_key.secret_data
    }
  }
}
```
