# 麻雀符計算練習アプリ

麻雀の符計算を練習するためのWebアプリケーションです。満貫未満の手牌に対して点数計算を効率的にマスターできます。

## 🎯 概要

麻雀の点数計算、特に**符計算**は初心者にとって大きなハードルです。本アプリでは、実践的な問題を通じて符計算のスキルを身につけることができます。

### 特徴

- **4択クイズ形式** - 問題ごとに正解・不正解がすぐにわかる
- **20種類以上の問題パターン** - 様々なケースに対応
- **ランダムな牌バリエーション** - 何度でも新鮮な問題にチャレンジ
- **満貫未満の手牌に特化** - 4翻で満貫にならないケースなど、計算力が問われる問題
- **計算方法の解説付き** - 正誤がわかった後に詳しい説明で復習

## 📱 ページ構成

| ページ | 説明 |
|--------|------|
| トップページ | アプリの説明と各機能へのナビゲーション |
| 符計算の種類紹介 | 符の種類と計算方法の解説ページ |
| 練習問題 | 4択形式で点数計算を練習 |

## 📚 学習コンテンツ

### 解答後の解説

問題に回答すると、以下の情報が表示されます：

- **符の内訳** - どの要素が何符になるか
- **翻数の確認** - 今回の手牌の役と翻数
- **点数計算の手順** - 符×翻からの点数導出方法
- **親の場合の点数** - 親の和了時の支払い
- **ツモの場合の点数配分** - 各プレイヤーの支払い内訳
- **関連する説明ページへのリンク** - より詳しく学びたい場合に

## 🚀 技術スタック

| 項目 | 技術 |
|------|------|
| パッケージ管理 | pnpm (モノレポ構成) |
| 言語 | TypeScript |
| ランタイム | Node.js 20+ |
| バックエンド | Firebase Functions |
| データベース | Firestore |
| テストフレームワーク | Vitest |

## 📋 前提条件

以下のツールがインストールされている必要があります：

- **Node.js** v20.0.0 以上
- **pnpm** v9.0.0 以上
- **Firebase CLI** (`npm install -g firebase-tools`)

```bash
# Node.jsのバージョン確認
node -v  # v20.x.x

# pnpmのインストール（未インストールの場合）
npm install -g pnpm

# Firebase CLIのインストール
npm install -g firebase-tools

# Firebase認証（初回のみ）
firebase login
```

## 📦 セットアップ

```bash
# リポジトリのクローン
git clone https://github.com/yugo-ibuki/mahjong-calculation-app.git
cd mahjong-calculation-app

# 依存関係のインストール
pnpm install

# 全パッケージのビルド
pnpm build
```

## 🔧 開発

### 全体ビルド

```bash
# 全パッケージをビルド
pnpm build

# コードフォーマット
pnpm format

# テスト実行
pnpm test
```

### バックエンド開発

```bash
# バックエンドディレクトリへ移動
cd apps/backend

# TypeScriptのウォッチモード（変更を自動検知してビルド）
pnpm dev

# テスト実行
pnpm test

# テストをウォッチモードで実行
pnpm test:watch
```

### Firebase エミュレータの起動

ローカル環境でFirebase Functions、Firestore、Authを動かすには：

```bash
cd apps/backend

# エミュレータ起動（事前にビルドが必要）
pnpm build
pnpm serve
```

エミュレータが起動すると以下のポートで利用可能になります：

| サービス | ポート | URL |
|----------|--------|-----|
| Functions | 5001 | http://localhost:5001 |
| Firestore | 8080 | http://localhost:8080 |
| Auth | 9099 | http://localhost:9099 |
| Emulator UI | 4000 | http://localhost:4000 |

> **Tip**: Emulator UI (http://localhost:4000) にアクセスすると、各エミュレータの状態をGUIで確認できます。

## ✅ 動作確認

### 1. テストの実行

```bash
# ルートディレクトリから全テスト実行
pnpm test

# バックエンドのみテスト
cd apps/backend && pnpm test
```

### 2. APIエンドポイントの確認

Firebaseエミュレータ起動後、curlやブラウザで確認：

```bash
# ヘルスチェック（APIが動作しているか確認）
curl http://localhost:5001/{PROJECT_ID}/us-central1/api/health

# 問題一覧取得（例）
curl http://localhost:5001/{PROJECT_ID}/us-central1/api/questions
```

### 3. Firestoreデータの確認

Emulator UI (http://localhost:4000) から：
1. **Firestore** タブを選択
2. コレクション・ドキュメントの閲覧・編集が可能

## 🚀 デプロイ

```bash
cd apps/backend

# Firebase Functionsへデプロイ
pnpm deploy
```

> **Note**: デプロイ前に `.firebaserc` でプロジェクトIDが正しく設定されていることを確認してください。

## 📁 プロジェクト構造

```
mahjong-calculation-app/
├── apps/                   # アプリケーション
│   ├── frontend/           # フロントエンド
│   └── backend/            # バックエンド (Cloud Functions)
├── packages/               # 共通パッケージ
│   ├── shared-types/       # 共通型定義
│   ├── shared-config/      # ESLint/Prettier/TS設定
│   └── mahjong-core/       # 麻雀計算ロジック
└── README.md
```

## 📄 ライセンス

MIT
