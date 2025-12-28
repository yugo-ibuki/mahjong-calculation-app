# Infrastructure - Terraform

麻雀点数計算アプリの GCP/Firebase インフラを Terraform で管理します。

## ディレクトリ構成

```
terraform/
├── modules/
│   ├── firebase/      # Firebase プロジェクト、App Check
│   ├── firestore/     # Firestore データベース、インデックス
│   └── monitoring/    # アラート、通知チャンネル
├── environments/
│   └── dev/           # 開発環境
└── shared/            # 共通プロバイダー設定
```

## 前提条件

1. **Terraform** v1.6.0 以上がインストールされていること
2. **GCP プロジェクト** `mahjong-calculation-app` が作成済みであること
3. **gcloud CLI** で認証済みであること

```bash
gcloud auth application-default login
```

## 使用方法

### 1. 設定ファイルの作成

```bash
cd infrastructure/terraform/environments/dev
cp terraform.tfvars.example terraform.tfvars
# terraform.tfvars を編集してメールアドレスを設定
```

### 2. 初期化

```bash
terraform init
```

### 3. プラン確認

```bash
terraform plan
```

### 4. 適用

```bash
terraform apply
```

## モジュール

### Firebase

- Firebase プロジェクトの有効化
- App Check 設定 (Cloud Functions 保護)
- Web アプリ登録

### Firestore

- データベース設定
- インデックス (history コレクション)

### Monitoring

- Email 通知チャンネル
- エラー率アラート (> 1%)
- レイテンシアラート (p99 > 2s)

## 注意事項

> **重要**: Cloud Functions のデプロイは引き続き Firebase CLI (`firebase deploy --only functions`) を使用してください。Terraform は IAM とモニタリングの設定を管理します。

## 既存リソースのインポート

既存の Firestore データベースがある場合:

```bash
terraform import module.firestore.google_firestore_database.default projects/mahjong-calculation-app/databases/\(default\)
```
