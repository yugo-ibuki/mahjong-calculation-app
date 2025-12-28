# Cloud Functions バックエンド設計

## 技術選定

| カテゴリ | 選定 | 理由 |
|---------|------|------|
| Runtime | Cloud Functions for Firebase (2nd gen) | サーバーレス、自動スケーリング |
| 言語 | TypeScript | 型安全、共通パッケージとの連携 |
| データベース | Firestore | Firebase統合、リアルタイム対応 |
| 認証 | Firebase Authentication | Flutter SDKとの連携容易 |
| テスト | Vitest | 高速、TypeScript対応 |
| バリデーション | Zod | 型推論、ランタイムバリデーション |

## ディレクトリ構造

```
apps/backend/
├── src/
│   ├── index.ts                    # エントリーポイント
│   ├── functions/                  # Cloud Functions
│   │   ├── calculation.ts          # 点数計算 API
│   │   ├── history.ts              # 履歴管理 API
│   │   └── health.ts               # ヘルスチェック
│   ├── services/                   # ビジネスロジック
│   │   ├── mahjong.service.ts      # 麻雀計算サービス
│   │   └── history.service.ts      # 履歴サービス
│   ├── repositories/               # データアクセス
│   │   └── firestore.repository.ts
│   ├── middleware/                 # ミドルウェア
│   │   ├── auth.ts                 # 認証
│   │   ├── validation.ts           # バリデーション
│   │   └── error-handler.ts        # エラーハンドリング
│   ├── schemas/                    # Zod スキーマ
│   │   └── calculation.schema.ts
│   └── utils/                      # ユーティリティ
│       ├── logger.ts
│       └── response.ts
├── tests/                          # テスト
│   ├── functions/
│   ├── services/
│   └── setup.ts
├── package.json
├── tsconfig.json
├── vitest.config.ts
├── firebase.json
└── .firebaserc
```

## エントリーポイント

```typescript
// src/index.ts
// NOTE: 現在はFirestoreを使用せずハードコードでデータを管理しているため、
// Firebase Admin初期化は不要です。Firestore使用時は以下を有効化してください。
// import { initializeApp } from 'firebase-admin/app';
// initializeApp();

// 関数のエクスポート
export { calculateScore } from './functions/calculation';
export { getHistory, saveHistory } from './functions/history';
export { healthCheck } from './functions/health';
```

## Cloud Functions

### 点数計算 API

```typescript
// src/functions/calculation.ts
import { onCall, HttpsError } from 'firebase-functions/v2/https';
import { logger } from 'firebase-functions/v2';
import type { CalculateScoreRequest, CalculateScoreResponse } from '@mahjong/shared-types';
import { MahjongService } from '../services/mahjong.service';
import { calculateScoreSchema } from '../schemas/calculation.schema';

const mahjongService = new MahjongService();

export const calculateScore = onCall<CalculateScoreRequest, CalculateScoreResponse>(
  {
    region: 'asia-northeast1',
    memory: '256MiB',
    timeoutSeconds: 30,
  },
  async (request) => {
    try {
      // バリデーション
      const validatedData = calculateScoreSchema.parse(request.data);

      // 計算実行
      const result = await mahjongService.calculate(
        validatedData.hand,
        validatedData.context
      );

      logger.info('Score calculated', {
        han: result.han,
        fu: result.fu,
        score: result.score.total
      });

      return {
        success: true,
        result,
      };
    } catch (error) {
      logger.error('Calculation error', { error });

      if (error instanceof HttpsError) {
        throw error;
      }

      throw new HttpsError('internal', 'Failed to calculate score');
    }
  }
);
```

### 履歴管理 API

```typescript
// src/functions/history.ts
import { onCall, HttpsError } from 'firebase-functions/v2/https';
import { HistoryService } from '../services/history.service';

const historyService = new HistoryService();

export const getHistory = onCall(
  {
    region: 'asia-northeast1',
  },
  async (request) => {
    // 認証チェック
    if (!request.auth) {
      throw new HttpsError('unauthenticated', 'User must be authenticated');
    }

    const userId = request.auth.uid;
    const limit = request.data?.limit ?? 20;

    const history = await historyService.getByUserId(userId, limit);

    return { history };
  }
);

export const saveHistory = onCall(
  {
    region: 'asia-northeast1',
  },
  async (request) => {
    if (!request.auth) {
      throw new HttpsError('unauthenticated', 'User must be authenticated');
    }

    const userId = request.auth.uid;
    const { hand, context, result } = request.data;

    const id = await historyService.save(userId, { hand, context, result });

    return { id };
  }
);
```

### ヘルスチェック

```typescript
// src/functions/health.ts
import { onRequest } from 'firebase-functions/v2/https';

export const healthCheck = onRequest(
  {
    region: 'asia-northeast1',
  },
  (req, res) => {
    res.json({
      status: 'healthy',
      timestamp: new Date().toISOString(),
      version: process.env.npm_package_version,
    });
  }
);
```

## サービス層

### 麻雀計算サービス

```typescript
// src/services/mahjong.service.ts
import { calculateScore as calculateScoreCore } from '@mahjong/mahjong-core';
import type { Hand, GameContext, ScoreResult } from '@mahjong/shared-types';

export class MahjongService {
  async calculate(hand: Hand, context: GameContext): Promise<ScoreResult> {
    // mahjong-core パッケージを使用
    return calculateScoreCore(hand, context);
  }
}
```

### 履歴サービス（ハードコード版）

> **NOTE**: 現在はFirestoreを使用せず、インメモリでデータを管理するモック実装です。
> 将来的にFirestoreに置き換え可能です。

```typescript
// src/services/history.service.ts
interface HistoryEntry {
  id: string;
  userId: string;
  hand: unknown;
  context: unknown;
  result: unknown;
  createdAt: Date;
}

// インメモリで履歴を管理
const inMemoryHistory: HistoryEntry[] = [];

export class HistoryService {
  async getByUserId(userId: string, limit: number): Promise<HistoryEntry[]> {
    return inMemoryHistory
      .filter((entry) => entry.userId === userId)
      .sort((a, b) => b.createdAt.getTime() - a.createdAt.getTime())
      .slice(0, limit);
  }

  async save(
    userId: string,
    data: { hand: unknown; context: unknown; result: unknown }
  ): Promise<string> {
    const id = `${Date.now()}`;
    const newEntry: HistoryEntry = {
      id,
      userId,
      ...data,
      createdAt: new Date(),
    };
    inMemoryHistory.push(newEntry);
    return id;
  }
}
```

## バリデーション

```typescript
// src/schemas/calculation.schema.ts
import { z } from 'zod';

const tileSchema = z.object({
  suit: z.enum(['man', 'pin', 'sou', 'honor']),
  number: z.number().min(1).max(9).optional(),
  honor: z.enum(['east', 'south', 'west', 'north', 'white', 'green', 'red']).optional(),
  isRed: z.boolean().optional(),
});

const tileGroupSchema = z.object({
  type: z.enum(['sequence', 'triplet', 'quad', 'pair']),
  tiles: z.array(tileSchema),
  isOpen: z.boolean(),
});

const handSchema = z.object({
  tiles: z.array(tileSchema).min(1).max(14),
  melds: z.array(tileGroupSchema).max(4),
  winningTile: tileSchema,
  isTsumo: z.boolean(),
});

const gameContextSchema = z.object({
  roundWind: z.enum(['east', 'south', 'west', 'north']),
  seatWind: z.enum(['east', 'south', 'west', 'north']),
  dora: z.array(tileSchema),
  uraDora: z.array(tileSchema).optional(),
  honba: z.number().min(0),
  riichi: z.boolean(),
  doubleRiichi: z.boolean().optional(),
  ippatsu: z.boolean().optional(),
  rinshan: z.boolean().optional(),
  chankan: z.boolean().optional(),
  haitei: z.boolean().optional(),
});

export const calculateScoreSchema = z.object({
  hand: handSchema,
  context: gameContextSchema,
});
```

## エラーハンドリング

```typescript
// src/middleware/error-handler.ts
import { HttpsError } from 'firebase-functions/v2/https';
import { ZodError } from 'zod';
import { logger } from 'firebase-functions/v2';

export function handleError(error: unknown): never {
  logger.error('Error occurred', { error });

  if (error instanceof ZodError) {
    throw new HttpsError('invalid-argument', 'Validation failed', {
      errors: error.errors,
    });
  }

  if (error instanceof HttpsError) {
    throw error;
  }

  throw new HttpsError('internal', 'An unexpected error occurred');
}
```

## テスト

### サービステスト

```typescript
// tests/services/mahjong.service.test.ts
import { describe, it, expect, beforeEach } from 'vitest';
import { MahjongService } from '../../src/services/mahjong.service';

describe('MahjongService', () => {
  let service: MahjongService;

  beforeEach(() => {
    service = new MahjongService();
  });

  it('should calculate riichi tsumo correctly', async () => {
    const hand = {
      tiles: [/* 手牌データ */],
      melds: [],
      winningTile: { suit: 'man', number: 1 },
      isTsumo: true,
    };

    const context = {
      roundWind: 'east',
      seatWind: 'east',
      dora: [],
      honba: 0,
      riichi: true,
    };

    const result = await service.calculate(hand, context);

    expect(result.yaku).toContainEqual(
      expect.objectContaining({ name: 'riichi' })
    );
    expect(result.yaku).toContainEqual(
      expect.objectContaining({ name: 'tsumo' })
    );
  });
});
```

### 関数テスト

```typescript
// tests/functions/calculation.test.ts
import { describe, it, expect, vi } from 'vitest';
import { calculateScore } from '../../src/functions/calculation';

describe('calculateScore function', () => {
  it('should return score result for valid input', async () => {
    const mockRequest = {
      data: {
        hand: { /* ... */ },
        context: { /* ... */ },
      },
      auth: { uid: 'test-user' },
    };

    // Firebase Functions のモック
    const result = await calculateScore(mockRequest as any);

    expect(result.success).toBe(true);
    expect(result.result).toBeDefined();
  });
});
```

## 設定ファイル

### package.json

```json
{
  "name": "@mahjong/backend",
  "version": "0.0.1",
  "type": "module",
  "main": "dist/index.js",
  "scripts": {
    "build": "tsc",
    "dev": "tsc --watch",
    "serve": "firebase emulators:start --only functions",
    "deploy": "firebase deploy --only functions",
    "test": "vitest run",
    "test:watch": "vitest"
  },
  "dependencies": {
    "@mahjong/mahjong-core": "workspace:*",
    "@mahjong/shared-types": "workspace:*",
    "firebase-admin": "^12.0.0",
    "firebase-functions": "^5.0.0",
    "zod": "^3.22.0"
  },
  "devDependencies": {
    "@types/node": "^20.0.0",
    "typescript": "^5.0.0",
    "vitest": "^1.0.0"
  },
  "engines": {
    "node": "20"
  }
}
```

### tsconfig.json

```json
{
  "extends": "../../tsconfig.base.json",
  "compilerOptions": {
    "outDir": "./dist",
    "rootDir": "./src"
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist", "tests"]
}
```

### firebase.json

```json
{
  "functions": {
    "source": ".",
    "runtime": "nodejs20",
    "predeploy": ["pnpm run build"]
  },
  "firestore": {
    "rules": "firestore.rules",
    "indexes": "firestore.indexes.json"
  },
  "emulators": {
    "functions": {
      "port": 5001
    },
    "firestore": {
      "port": 8080
    },
    "auth": {
      "port": 9099
    },
    "ui": {
      "enabled": true
    }
  }
}
```

### vitest.config.ts

```typescript
import { defineConfig } from 'vitest/config';

export default defineConfig({
  test: {
    globals: true,
    environment: 'node',
    setupFiles: ['./tests/setup.ts'],
    include: ['tests/**/*.test.ts'],
  },
});
```

## セキュリティ

### Firestore Rules

```
// firestore.rules
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // 履歴コレクション
    match /history/{historyId} {
      allow read: if request.auth != null
                  && request.auth.uid == resource.data.userId;
      allow create: if request.auth != null
                    && request.auth.uid == request.resource.data.userId;
      allow update, delete: if false; // 履歴は変更・削除不可
    }
  }
}
```

## デプロイ

### 環境別デプロイ

```bash
# 開発環境
firebase use development
pnpm run deploy

# 本番環境
firebase use production
pnpm run deploy
```

### CI/CD (GitHub Actions)

```yaml
# .github/workflows/backend.yml
name: Backend CI/CD

on:
  push:
    branches: [main]
    paths:
      - 'apps/backend/**'
      - 'packages/**'

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: pnpm/action-setup@v2
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'pnpm'
      - run: pnpm install
      - run: pnpm --filter @mahjong/backend test

  deploy:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: pnpm/action-setup@v2
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
      - run: pnpm install
      - run: pnpm --filter @mahjong/backend build
      - uses: FirebaseExtended/action-hosting-deploy@v0
        with:
          repoToken: '${{ secrets.GITHUB_TOKEN }}'
          firebaseServiceAccount: '${{ secrets.FIREBASE_SERVICE_ACCOUNT }}'
          channelId: live
```
