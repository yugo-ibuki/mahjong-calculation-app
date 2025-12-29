# 麻雀符計算練習アプリ - プロジェクトアーキテクチャ

## 概要

麻雀の符計算を練習するためのWebアプリケーション。pnpmによるモノレポ構成で、Flutter（フロントエンド）とFirebase Functions（バックエンド）を統合管理している。

---

## モノレポ構成

### パッケージマネージャー

- **pnpm** v9.0.0 以上
- ワークスペース機能を使用した依存関係の共有

### ワークスペース設定

```yaml
# pnpm-workspace.yaml
packages:
  - 'apps/*'      # アプリケーション（frontend, backend）
  - 'packages/*'  # 共有パッケージ
```

### ディレクトリ構造

```
mahjong-calculation-app/
├── apps/                      # アプリケーション
│   ├── frontend/              # Flutter (Dart) フロントエンド
│   └── backend/               # Firebase Functions (TypeScript)
├── packages/                  # 共有パッケージ
│   ├── shared-types/          # 共通型定義
│   ├── shared-config/         # ESLint/Prettier/TSConfig設定
│   └── mahjong-core/          # 麻雀計算ロジック
├── infrastructure/            # インフラ構成
│   └── terraform/             # GCP/Firebase IaC
├── package.json               # ルートパッケージ設定
├── pnpm-workspace.yaml        # ワークスペース定義
├── tsconfig.base.json         # 基本TypeScript設定
└── .prettierrc                # コードフォーマット設定
```

### ルートスクリプト

```json
{
  "scripts": {
    "build": "pnpm -r build",    // 全パッケージビルド
    "test": "pnpm -r test",      // 全テスト実行
    "lint": "pnpm -r lint",      // 全Lint実行
    "format": "prettier --write .",
    "clean": "pnpm -r clean"
  }
}
```

---

## フロントエンド構成

### 技術スタック

| 項目 | 技術 |
|------|------|
| フレームワーク | Flutter 3.x |
| 言語 | Dart (SDK ^3.9.2) |
| 状態管理 | flutter_riverpod ^2.5.1 |
| ルーティング | go_router ^14.2.0 |
| HTTP通信 | dio ^5.4.3 |
| Firebase | firebase_core, firebase_app_check |

### ディレクトリ構造

```
apps/frontend/
├── lib/
│   ├── main.dart                    # エントリーポイント
│   ├── app/
│   │   └── routes.dart              # ルーティング定義
│   ├── features/                    # 機能別モジュール
│   │   ├── home/                    # ホーム画面
│   │   │   └── presentation/pages/
│   │   ├── explanation/             # 符の種類解説
│   │   │   └── presentation/pages/
│   │   ├── practice/                # 練習問題
│   │   │   ├── data/repositories/   # データ層
│   │   │   ├── domain/              # ドメイン層
│   │   │   │   ├── models/          # モデル定義
│   │   │   │   └── services/        # ビジネスロジック
│   │   │   └── presentation/        # プレゼンテーション層
│   │   │       ├── pages/
│   │   │       ├── providers/       # Riverpod Providers
│   │   │       └── widgets/
│   │   └── calculation/             # 計算ページ
│   │       └── presentation/pages/
│   └── shared/                      # 共通コンポーネント
│       ├── providers/               # 共通Provider (dio等)
│       ├── themes/                  # テーマ設定
│       └── widgets/                 # 共通ウィジェット
├── android/                         # Android設定
├── ios/                             # iOS設定
├── test/                            # テストファイル
└── pubspec.yaml                     # Dart依存関係
```

### アーキテクチャパターン

機能ベースのクリーンアーキテクチャを採用：

1. **presentation** - UI層（pages, widgets, providers）
2. **domain** - ビジネスロジック層（models, services）
3. **data** - データ層（repositories）

### 主要画面

| 画面 | パス | 説明 |
|------|------|------|
| ホーム | `/` | アプリ概要とナビゲーション |
| 解説 | `/explanation` | 符の種類と計算方法 |
| 練習 | `/practice` | 4択クイズ形式の練習 |
| 計算 | `/calculation` | 点数計算 |

---

## バックエンド構成

### 技術スタック

| 項目 | 技術 |
|------|------|
| ランタイム | Node.js 20 |
| フレームワーク | Firebase Functions v5 |
| 言語 | TypeScript 5.x (ESM) |
| バリデーション | Zod |
| テスト | Vitest |
| データベース | Firestore |

### ディレクトリ構造

```
apps/backend/
├── src/
│   ├── index.ts                     # エントリーポイント・ルーティング
│   ├── functions/                   # Cloud Functions
│   │   ├── calculation.ts           # 点数計算API
│   │   ├── health.ts                # ヘルスチェック
│   │   └── history.ts               # 履歴管理
│   ├── middleware/
│   │   └── error-handler.ts         # エラーハンドリング
│   ├── schemas/
│   │   └── calculation.schema.ts    # Zodスキーマ
│   ├── services/
│   │   ├── mahjong.service.ts       # 麻雀計算ロジック
│   │   └── history.service.ts       # 履歴サービス
│   └── utils/
│       ├── logger.ts                # ロギング
│       └── response.ts              # レスポンス整形
├── tests/                           # テストファイル
├── dist/                            # ビルド出力
├── firebase.json                    # Firebase設定
├── firestore.rules                  # Firestoreセキュリティルール
├── firestore.indexes.json           # Firestoreインデックス
├── tsconfig.json                    # TypeScript設定
├── vitest.config.ts                 # Vitestテスト設定
└── package.json
```

### APIエンドポイント

| エンドポイント | メソッド | 説明 |
|--------------|---------|------|
| `/health` | GET | ヘルスチェック |
| `/calculation` | POST | 点数計算 |
| `/history` | GET/POST | 履歴取得・保存 |

### 開発コマンド

```bash
cd apps/backend

# TypeScriptウォッチモード
pnpm dev

# エミュレータ起動
pnpm build && pnpm serve

# テスト
pnpm test
pnpm test:watch

# デプロイ
pnpm deploy
```

### Firebaseエミュレータ

| サービス | ポート | URL |
|----------|--------|-----|
| Functions | 5001 | http://localhost:5001 |
| Firestore | 8080 | http://localhost:8080 |
| Auth | 9099 | http://localhost:9099 |
| Emulator UI | 4000 | http://localhost:4000 |

---

## 共有パッケージ

### @mahjong/shared-types

フロントエンド・バックエンド間で共有する型定義。

```
packages/shared-types/
├── src/
│   ├── index.ts
│   ├── api/                    # API関連型
│   │   ├── calculation.ts      # 計算リクエスト/レスポンス
│   │   └── history.ts          # 履歴API型
│   └── domain/                 # ドメイン型
│       ├── tile.ts             # 牌の型
│       ├── hand.ts             # 手牌の型
│       ├── question.ts         # 問題の型
│       └── score.ts            # 点数の型
└── package.json
```

### @mahjong/shared-config

プロジェクト全体で共有する設定ファイル。

```
packages/shared-config/
├── eslint/
│   ├── base.js                 # 基本ESLint設定
│   └── typescript.js           # TypeScript用設定
├── prettier/
│   └── index.js                # Prettier設定
├── typescript/
│   └── base.json               # 基本tsconfig
└── package.json
```

### @mahjong-app/core

麻雀計算のコアロジック。

```
packages/mahjong-core/
├── src/
│   ├── index.ts
│   └── questions/
│       ├── index.ts
│       └── data.ts             # 問題データ（20種類以上）
└── package.json
```

---

## インフラストラクチャ

### Terraform構成

```
infrastructure/terraform/
├── modules/
│   ├── firebase/               # Firebase設定（App Check等）
│   ├── firestore/              # Firestore DB設定
│   └── monitoring/             # アラート・通知設定
├── environments/
│   └── dev/                    # 開発環境
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── backend.tf
└── shared/
    ├── providers.tf            # プロバイダ設定
    └── versions.tf             # バージョン制約
```

### GCPリソース

- **Firebase Project**: プロジェクト有効化
- **App Check**: Cloud Functions保護
- **Firestore**: データベース + インデックス
- **Monitoring**: エラー率・レイテンシアラート

### Terraformコマンド

```bash
cd infrastructure/terraform/environments/dev

# 初期化
terraform init

# プラン確認
terraform plan

# 適用
terraform apply
```

---

## 開発ワークフロー

### セットアップ

```bash
# 1. リポジトリクローン
git clone https://github.com/yugo-ibuki/mahjong-calculation-app.git
cd mahjong-calculation-app

# 2. 依存関係インストール
pnpm install

# 3. 全パッケージビルド
pnpm build
```

### パッケージ間の依存関係

```
@mahjong/shared-types
    ↑
    ├── @mahjong/backend
    └── @mahjong-app/core
            ↑
            └── (フロントエンドでは直接参照せずモックで代替)
```

### 型の共有方法

バックエンドは `@mahjong/shared-types` をworkspace参照：

```json
{
  "dependencies": {
    "@mahjong/shared-types": "workspace:*"
  }
}
```

---

## 前提条件

- **Node.js** v20.0.0 以上
- **pnpm** v9.0.0 以上
- **Flutter** SDK ^3.9.2
- **Firebase CLI** (`npm install -g firebase-tools`)
- **Terraform** v1.6.0 以上（インフラ操作時）
