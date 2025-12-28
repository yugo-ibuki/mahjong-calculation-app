# 開発ワークフロー

## 初期セットアップ

### 1. リポジトリクローン

```bash
git clone https://github.com/yugo-ibuki/mahjong-calculation-app.git
cd mahjong-calculation-app
```

### 2. 依存関係インストール

```bash
# pnpm インストール (未インストールの場合)
npm install -g pnpm

# 依存関係インストール
pnpm install
```

### 3. Flutter セットアップ

```bash
cd apps/frontend
flutter pub get
```

### 4. Firebase セットアップ

```bash
# Firebase CLI インストール
npm install -g firebase-tools

# ログイン
firebase login

# プロジェクト選択
firebase use --add
```

## ローカル開発

### パッケージ開発

```bash
# 全パッケージビルド
pnpm build

# 特定パッケージのみ
pnpm --filter @mahjong/shared-types build

# ウォッチモード
pnpm --filter @mahjong/mahjong-core dev
```

### バックエンド開発

```bash
# エミュレータ起動
cd apps/backend
pnpm serve

# エミュレータ UI: http://localhost:4000
# Functions: http://localhost:5001
# Firestore: http://localhost:8080
```

### フロントエンド開発

```bash
cd apps/frontend

# Web で実行 (エミュレータ使用)
flutter run -d chrome --dart-define=API_URL=http://localhost:5001/project-id/asia-northeast1

# iOS シミュレータで実行
flutter run -d ios

# Android エミュレータで実行
flutter run -d android
```

### 並行開発

複数ターミナルで:

```bash
# Terminal 1: パッケージウォッチ
pnpm --filter @mahjong/shared-types dev &
pnpm --filter @mahjong/mahjong-core dev

# Terminal 2: バックエンドエミュレータ
cd apps/backend && pnpm serve

# Terminal 3: フロントエンド
cd apps/frontend && flutter run -d chrome
```

## コマンド一覧

### ルートレベル

| コマンド | 説明 |
|---------|------|
| `pnpm build` | 全パッケージビルド |
| `pnpm test` | 全テスト実行 |
| `pnpm lint` | 全リント実行 |
| `pnpm format` | コードフォーマット |
| `pnpm clean` | ビルド成果物削除 |

### パッケージフィルター

```bash
# 特定パッケージのみ
pnpm --filter @mahjong/backend <command>
pnpm --filter @mahjong/shared-types <command>

# 依存関係含む
pnpm --filter @mahjong/backend... build
```

### Flutter コマンド

| コマンド | 説明 |
|---------|------|
| `flutter pub get` | 依存関係取得 |
| `flutter test` | テスト実行 |
| `flutter analyze` | 静的解析 |
| `flutter build web` | Web ビルド |
| `flutter build apk` | Android ビルド |
| `flutter build ios` | iOS ビルド |

## ブランチ戦略

```
main                  # 本番環境
├── develop           # 開発統合
│   ├── feature/*     # 機能開発
│   └── fix/*         # バグ修正
└── release/*         # リリース準備
```

### ブランチ命名規則

- `feature/add-yaku-detection` - 新機能
- `fix/score-calculation-error` - バグ修正
- `refactor/improve-tile-parser` - リファクタリング
- `docs/update-readme` - ドキュメント

## コミット規約

### Conventional Commits

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Type

| Type | 説明 |
|------|------|
| `feat` | 新機能 |
| `fix` | バグ修正 |
| `docs` | ドキュメント |
| `style` | フォーマット |
| `refactor` | リファクタリング |
| `test` | テスト |
| `chore` | その他 |

### Scope

- `frontend` - Flutter アプリ
- `backend` - Cloud Functions
- `types` - shared-types
- `core` - mahjong-core
- `config` - shared-config
- `ci` - CI/CD

### 例

```
feat(frontend): add tile selection UI

- Implemented TabBar for tile categories
- Added TileButton widget with tap handling
- Connected to handProvider for state management

Closes #123
```

## PR ワークフロー

### 1. ブランチ作成

```bash
git checkout develop
git pull origin develop
git checkout -b feature/my-feature
```

### 2. 開発・コミット

```bash
# 変更をステージング
git add .

# コミット (Conventional Commits)
git commit -m "feat(frontend): add score display widget"
```

### 3. プッシュ・PR作成

```bash
git push origin feature/my-feature
# GitHub で PR 作成
```

### 4. レビュー・マージ

- CI チェック通過確認
- コードレビュー
- Squash and Merge

## CI/CD パイプライン

### プルリクエスト時

```yaml
# 自動実行
- Lint (ESLint, Dart analyze)
- Test (Vitest, Flutter test)
- Build check
```

### マージ時 (develop)

```yaml
# 開発環境デプロイ
- Backend → Firebase (dev)
- Frontend → Firebase Hosting (dev)
```

### マージ時 (main)

```yaml
# 本番環境デプロイ
- Backend → Firebase (prod)
- Frontend → Firebase Hosting (prod)
- App Store / Play Store (手動トリガー)
```

## 環境設定

### 環境変数

```bash
# .env.local (ローカル開発用)
FIREBASE_PROJECT_ID=mahjong-dev
API_URL=http://localhost:5001/mahjong-dev/asia-northeast1

# .env.production
FIREBASE_PROJECT_ID=mahjong-prod
API_URL=https://asia-northeast1-mahjong-prod.cloudfunctions.net
```

### Flutter 環境変数

```bash
# 開発
flutter run --dart-define=API_URL=http://localhost:5001/...

# 本番ビルド
flutter build web --dart-define=API_URL=https://...
```

### Firebase プロジェクト切り替え

```bash
# 開発
firebase use development

# 本番
firebase use production
```

## トラブルシューティング

### 依存関係の問題

```bash
# node_modules 削除して再インストール
rm -rf node_modules
rm -rf apps/*/node_modules
rm -rf packages/*/node_modules
pnpm install
```

### Flutter の問題

```bash
# キャッシュクリア
flutter clean
flutter pub get
```

### Firebase エミュレータの問題

```bash
# ポート使用中エラー
lsof -i :5001
kill -9 <PID>

# データリセット
firebase emulators:start --clear
```

### ビルドエラー

```bash
# TypeScript ビルドエラー
pnpm --filter @mahjong/shared-types build
pnpm --filter @mahjong/mahjong-core build
pnpm --filter @mahjong/backend build
```

## よくある作業

### 新しい型を追加

1. `packages/shared-types/src/domain/` に型定義追加
2. `packages/shared-types/src/index.ts` でエクスポート
3. `pnpm --filter @mahjong/shared-types build`
4. Flutter 側で対応する Dart クラス作成
5. 両方でテスト追加

### 新しい API エンドポイント追加

1. `apps/backend/src/functions/` に関数作成
2. `apps/backend/src/index.ts` でエクスポート
3. スキーマ定義追加
4. テスト追加
5. Flutter 側で API クライアント追加

### 新しい機能モジュール追加 (Flutter)

1. `apps/frontend/lib/features/` に新ディレクトリ作成
2. `presentation/`, `domain/`, `data/` の各層を作成
3. プロバイダー定義
4. ルーティング追加
5. テスト追加
