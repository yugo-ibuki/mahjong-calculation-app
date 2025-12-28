# Mahjong Calculation App - Monorepo設計概要

## プロジェクト概要

麻雀の点数計算を支援するアプリケーション。Flutter によるクロスプラットフォームフロントエンドと、Cloud Functions によるサーバーレスバックエンドで構成される。

## 技術スタック

### Frontend
- **Framework**: Flutter (Dart)
- **対象プラットフォーム**: iOS, Android, Web
- **状態管理**: Riverpod (推奨)

### Backend
- **Runtime**: Cloud Functions for Firebase
- **Language**: TypeScript
- **Database**: Firestore (推奨)

### 共通基盤
- **パッケージ管理**: pnpm workspaces
- **言語**: TypeScript (バックエンド・共通パッケージ)
- **Linter/Formatter**: ESLint, Prettier
- **テスト**: Vitest

## Monorepo採用理由

1. **型の共有**: バックエンドとフロントエンド間で型定義を共有
2. **設定の一元管理**: ESLint, Prettier, TypeScript設定を統一
3. **開発効率**: 単一リポジトリでの一括管理・デプロイ
4. **依存関係管理**: 共通パッケージのバージョン管理が容易

## アーキテクチャ図

```
┌─────────────────────────────────────────────────────────────┐
│                        Monorepo                              │
├─────────────────────────────────────────────────────────────┤
│  apps/                                                       │
│  ├── frontend/          # Flutter アプリケーション           │
│  │   └── (Dart プロジェクト)                                 │
│  └── backend/           # Cloud Functions                    │
│      └── (TypeScript プロジェクト)                           │
├─────────────────────────────────────────────────────────────┤
│  packages/                                                   │
│  ├── shared-types/      # 共通型定義                         │
│  ├── shared-config/     # 共通設定                           │
│  └── mahjong-core/      # 麻雀ロジック (将来的な共有用)      │
└─────────────────────────────────────────────────────────────┘
```

## ドキュメント構成

| ファイル | 内容 |
|---------|------|
| `overview.md` | 本ファイル。プロジェクト全体の概要 |
| `directory-structure.md` | 詳細なディレクトリ構造 |
| `packages.md` | 共通パッケージの設計詳細 |
| `frontend.md` | Flutter フロントエンドの設計 |
| `backend.md` | Cloud Functions バックエンドの設計 |
| `development-workflow.md` | 開発ワークフローと運用手順 |
