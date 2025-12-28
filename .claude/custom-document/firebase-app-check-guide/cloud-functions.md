# Cloud Functions 実装

## プロジェクト初期化

```bash
pnpm add -g firebase-tools
firebase login
firebase init functions
```

初期化時に「パッケージマネージャーを選択」で **pnpm** を選択してください。

## 依存関係

```bash
pnpm add firebase-admin firebase-functions
```

```json
{
  "dependencies": {
    "firebase-admin": "^12.0.0",
    "firebase-functions": "^5.0.0"
  }
}
```

## 実装例

```typescript
// functions/src/index.ts
import { onCall, HttpsError } from "firebase-functions/v2/https";

// エンドポイント1: データ取得
export const getData = onCall(
  { enforceAppCheck: true },
  async (request) => {
    const { id } = request.data;

    if (!id) {
      throw new HttpsError("invalid-argument", "id is required");
    }

    // ビジネスロジック
    return { 
      id,
      data: "some data" 
    };
  }
);

// エンドポイント2: データ送信
export const postData = onCall(
  { enforceAppCheck: true },
  async (request) => {
    const { content } = request.data;

    if (!content) {
      throw new HttpsError("invalid-argument", "content is required");
    }

    // ビジネスロジック
    return { success: true };
  }
);

// エンドポイント3: その他
export const otherEndpoint = onCall(
  { enforceAppCheck: true },
  async (request) => {
    return { message: "ok" };
  }
);
```

## デプロイ

```bash
firebase deploy --only functions
```

## 段階的な導入

### フェーズ1: モニタリングのみ

```typescript
export const myEndpoint = onCall(
  { enforceAppCheck: false }, // 検証しないが、トークンの有無はログに記録
  async (request) => {
    if (request.app) {
      console.log("Valid App Check token");
    } else {
      console.log("No App Check token");
    }
    // 処理続行
  }
);
```

### フェーズ2: 本番適用

```typescript
export const myEndpoint = onCall(
  { enforceAppCheck: true }, // 不正リクエストを拒否
  async (request) => {
    // App Check 検証済みのリクエストのみ到達
  }
);
```
