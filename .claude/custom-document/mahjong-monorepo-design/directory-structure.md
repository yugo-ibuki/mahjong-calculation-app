# ディレクトリ構造

## 全体構造

```
mahjong-calculation-app/
├── .claude/                    # Claude設定
│   └── custom-document/        # 設計ドキュメント
├── .github/                    # GitHub Actions
│   └── workflows/
│       ├── frontend.yml        # Flutter CI/CD
│       └── backend.yml         # Cloud Functions CI/CD
├── apps/
│   ├── frontend/               # Flutter アプリ
│   └── backend/                # Cloud Functions
├── packages/
│   ├── shared-types/           # 共通型定義
│   ├── shared-config/          # 共通設定
│   └── mahjong-core/           # 麻雀ロジック
├── .gitignore
├── .prettierrc
├── eslint.config.js
├── package.json                # ルート package.json (workspaces)
├── pnpm-workspace.yaml         # pnpm workspace 設定
├── tsconfig.base.json          # 共通 TypeScript 設定
└── README.md
```

## apps/frontend (Flutter)

```
apps/frontend/
├── android/                    # Android プラットフォーム
├── ios/                        # iOS プラットフォーム
├── lib/
│   ├── main.dart               # エントリーポイント
│   ├── app/                    # アプリ設定
│   │   ├── app.dart
│   │   └── routes.dart
│   ├── features/               # 機能別モジュール
│   │   ├── calculation/        # 点数計算機能
│   │   │   ├── presentation/   # UI層
│   │   │   ├── domain/         # ドメイン層
│   │   │   └── data/           # データ層
│   │   └── history/            # 履歴機能
│   ├── shared/                 # 共通コンポーネント
│   │   ├── widgets/
│   │   ├── themes/
│   │   └── utils/
│   └── generated/              # 自動生成ファイル
├── test/                       # テスト
├── web/                        # Web プラットフォーム
├── pubspec.yaml                # Flutter 依存関係
└── analysis_options.yaml       # Dart リンター設定
```

## apps/backend (Cloud Functions)

```
apps/backend/
├── src/
│   ├── index.ts                # Cloud Functions エントリーポイント
│   ├── functions/              # 各関数
│   │   ├── calculation.ts      # 点数計算 API
│   │   └── history.ts          # 履歴管理 API
│   ├── services/               # ビジネスロジック
│   │   └── mahjong.service.ts
│   ├── repositories/           # データアクセス
│   │   └── firestore.repository.ts
│   ├── types/                  # ローカル型定義
│   └── utils/                  # ユーティリティ
├── tests/                      # テスト
├── package.json
├── tsconfig.json               # extends tsconfig.base.json
├── firebase.json               # Firebase 設定
└── .firebaserc                 # Firebase プロジェクト設定
```

## packages/shared-types

```
packages/shared-types/
├── src/
│   ├── index.ts                # エクスポート
│   ├── api/                    # API リクエスト/レスポンス型
│   │   ├── calculation.ts
│   │   └── history.ts
│   └── domain/                 # ドメイン型
│       ├── tile.ts             # 牌の型
│       ├── hand.ts             # 手牌の型
│       └── score.ts            # 点数の型
├── package.json
└── tsconfig.json
```

## packages/shared-config

```
packages/shared-config/
├── eslint/                     # ESLint 設定
│   ├── base.js
│   └── typescript.js
├── typescript/                 # TypeScript 設定
│   └── base.json
├── prettier/                   # Prettier 設定
│   └── index.js
├── package.json
└── index.js                    # エクスポート
```

## packages/mahjong-core

```
packages/mahjong-core/
├── src/
│   ├── index.ts
│   ├── calculator/             # 点数計算ロジック
│   │   ├── score.ts
│   │   ├── yaku.ts             # 役判定
│   │   └── fu.ts               # 符計算
│   ├── parser/                 # 手牌パース
│   │   └── hand-parser.ts
│   └── constants/              # 定数
│       └── tiles.ts
├── tests/
├── package.json
└── tsconfig.json
```

## 重要ファイル

### pnpm-workspace.yaml

```yaml
packages:
  - 'apps/*'
  - 'packages/*'
```

### package.json (ルート)

```json
{
  "name": "mahjong-calculation-app",
  "private": true,
  "scripts": {
    "build": "pnpm -r build",
    "test": "pnpm -r test",
    "lint": "pnpm -r lint",
    "format": "prettier --write ."
  },
  "devDependencies": {
    "prettier": "^3.0.0",
    "typescript": "^5.0.0"
  }
}
```

### tsconfig.base.json

```json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "NodeNext",
    "moduleResolution": "NodeNext",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true
  }
}
```
