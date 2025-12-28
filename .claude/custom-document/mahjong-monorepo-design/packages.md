# 共通パッケージ設計

## パッケージ一覧

| パッケージ | 目的 | 依存先 |
|-----------|------|--------|
| `@mahjong/shared-types` | API・ドメイン型定義 | なし |
| `@mahjong/shared-config` | ESLint/Prettier/TS設定 | なし |
| `@mahjong/mahjong-core` | 麻雀計算ロジック | `@mahjong/shared-types` |

## @mahjong/shared-types

### 目的
バックエンド (TypeScript) で定義した型を、フロントエンド (Flutter/Dart) でも参照可能な形で管理する。

### 型定義

#### domain/tile.ts
```typescript
// 牌の種類
export type TileSuit = 'man' | 'pin' | 'sou' | 'honor';

// 字牌の種類
export type HonorType = 'east' | 'south' | 'west' | 'north' | 'white' | 'green' | 'red';

// 牌
export interface Tile {
  suit: TileSuit;
  number?: number;      // 1-9 (数牌のみ)
  honor?: HonorType;    // 字牌のみ
  isRed?: boolean;      // 赤ドラ
}

// 牌のグループ (面子・雀頭)
export interface TileGroup {
  type: 'sequence' | 'triplet' | 'quad' | 'pair';
  tiles: Tile[];
  isOpen: boolean;      // 鳴きか否か
}
```

#### domain/hand.ts
```typescript
import type { Tile, TileGroup } from './tile';

// 手牌
export interface Hand {
  tiles: Tile[];           // 手牌 (13枚 or 14枚)
  melds: TileGroup[];      // 鳴き
  winningTile: Tile;       // 和了牌
  isTsumo: boolean;        // ツモか否か
}

// 場の情報
export interface GameContext {
  roundWind: 'east' | 'south' | 'west' | 'north';
  seatWind: 'east' | 'south' | 'west' | 'north';
  dora: Tile[];
  uraDora?: Tile[];
  honba: number;          // 本場
  riichi: boolean;        // リーチ
  doubleRiichi?: boolean; // ダブルリーチ
  ippatsu?: boolean;      // 一発
  rinshan?: boolean;      // 嶺上開花
  chankan?: boolean;      // 槍槓
  haitei?: boolean;       // 海底/河底
}
```

#### domain/score.ts
```typescript
// 役
export interface Yaku {
  name: string;           // 役名
  nameJa: string;         // 日本語名
  han: number;            // 翻数
  isYakuman?: boolean;    // 役満か
}

// 計算結果
export interface ScoreResult {
  yaku: Yaku[];
  han: number;            // 合計翻数
  fu: number;             // 符
  score: {
    total: number;        // 合計点
    dealer?: number;      // 親の支払い (ツモ時)
    nonDealer?: number;   // 子の支払い (ツモ時)
  };
  isYakuman: boolean;
}
```

#### api/calculation.ts
```typescript
import type { Hand, GameContext, ScoreResult } from '../domain';

// リクエスト
export interface CalculateScoreRequest {
  hand: Hand;
  context: GameContext;
}

// レスポンス
export interface CalculateScoreResponse {
  success: boolean;
  result?: ScoreResult;
  error?: {
    code: string;
    message: string;
  };
}
```

### Flutter (Dart) との連携

TypeScript の型定義から Dart のクラスを自動生成するアプローチ:

1. **JSON Schema 経由**: `typescript-json-schema` で JSON Schema を生成し、`quicktype` で Dart クラスを生成
2. **手動同期**: TypeScript の型定義を参考に Dart クラスを手動で作成

推奨は **手動同期** + **テストでの検証**。

```dart
// lib/shared/types/tile.dart (Dart側)
enum TileSuit { man, pin, sou, honor }
enum HonorType { east, south, west, north, white, green, red }

class Tile {
  final TileSuit suit;
  final int? number;
  final HonorType? honor;
  final bool isRed;

  Tile({
    required this.suit,
    this.number,
    this.honor,
    this.isRed = false,
  });

  factory Tile.fromJson(Map<String, dynamic> json) => Tile(
    suit: TileSuit.values.byName(json['suit']),
    number: json['number'],
    honor: json['honor'] != null
      ? HonorType.values.byName(json['honor'])
      : null,
    isRed: json['isRed'] ?? false,
  );
}
```

## @mahjong/shared-config

### ESLint 設定

```javascript
// eslint/base.js
export default {
  rules: {
    'no-console': 'warn',
    'no-unused-vars': 'error',
  },
};
```

```javascript
// eslint/typescript.js
import baseConfig from './base.js';

export default {
  ...baseConfig,
  parser: '@typescript-eslint/parser',
  plugins: ['@typescript-eslint'],
  rules: {
    ...baseConfig.rules,
    '@typescript-eslint/explicit-function-return-type': 'warn',
    '@typescript-eslint/no-explicit-any': 'error',
  },
};
```

### Prettier 設定

```javascript
// prettier/index.js
export default {
  semi: true,
  singleQuote: true,
  tabWidth: 2,
  trailingComma: 'es5',
  printWidth: 100,
};
```

### 使用方法 (apps/backend)

```javascript
// apps/backend/eslint.config.js
import { typescript } from '@mahjong/shared-config/eslint';

export default [
  ...typescript,
  // プロジェクト固有の設定
];
```

## @mahjong/mahjong-core

### 目的
麻雀の点数計算ロジックを独立したパッケージとして実装。将来的に:
- バックエンド (Cloud Functions) で使用
- Web Worker でクライアントサイド計算に使用
- npm パッケージとして公開

### 設計方針

```typescript
// src/calculator/score.ts
import type { Hand, GameContext, ScoreResult, Yaku } from '@mahjong/shared-types';
import { calculateFu } from './fu';
import { detectYaku } from './yaku';

export function calculateScore(hand: Hand, context: GameContext): ScoreResult {
  const yaku = detectYaku(hand, context);
  const fu = calculateFu(hand, context);
  const han = yaku.reduce((sum, y) => sum + y.han, 0);

  const score = computePayment(han, fu, context.seatWind === 'east');

  return {
    yaku,
    han,
    fu,
    score,
    isYakuman: yaku.some(y => y.isYakuman),
  };
}
```

### テスト戦略

```typescript
// tests/calculator/score.test.ts
import { describe, it, expect } from 'vitest';
import { calculateScore } from '../src/calculator/score';

describe('calculateScore', () => {
  it('should calculate riichi tsumo correctly', () => {
    const hand = { /* ... */ };
    const context = { riichi: true, /* ... */ };

    const result = calculateScore(hand, context);

    expect(result.yaku).toContainEqual(
      expect.objectContaining({ name: 'riichi' })
    );
  });
});
```

## パッケージ間の依存関係

```
┌──────────────────┐
│  shared-config   │  ← 他パッケージから参照
└──────────────────┘
         │
         ▼
┌──────────────────┐
│  shared-types    │  ← 他パッケージから参照
└──────────────────┘
         │
         ▼
┌──────────────────┐     ┌──────────────────┐
│  mahjong-core    │ ←── │  apps/backend    │
└──────────────────┘     └──────────────────┘
                                  │
                                  ▼
                         ┌──────────────────┐
                         │  apps/frontend   │
                         │  (Dart types)    │
                         └──────────────────┘
```

## ビルド設定

### package.json (shared-types)

```json
{
  "name": "@mahjong/shared-types",
  "version": "0.0.1",
  "type": "module",
  "main": "./dist/index.js",
  "types": "./dist/index.d.ts",
  "exports": {
    ".": {
      "types": "./dist/index.d.ts",
      "import": "./dist/index.js"
    }
  },
  "scripts": {
    "build": "tsc",
    "dev": "tsc --watch"
  },
  "devDependencies": {
    "typescript": "^5.0.0"
  }
}
```
