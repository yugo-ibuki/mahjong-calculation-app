# GCP / Firebase サービス詳細

## サービス一覧

```
┌───────────────────────────────────────────────────────┐
│                 Firebase (GCP上で動作)                  │
├───────────────────────────────────────────────────────┤
│  Cloud Functions 2nd gen     │  サーバーレスAPI         │
│  Cloud Firestore             │  NoSQL データベース      │
│  Firebase Authentication     │  認証サービス            │
│  Firebase App Check          │  アプリ検証              │
│  Firebase Hosting            │  静的ホスティング        │
└───────────────────────────────────────────────────────┘
```

---

## Cloud Functions (2nd gen)

### 基本情報

| 項目 | 設定値 |
|------|--------|
| 世代 | 2nd generation |
| リージョン | asia-northeast1 (東京) |
| ランタイム | Node.js 20 |
| メモリ | 256 MiB (デフォルト) |
| タイムアウト | 30秒 |
| インスタンス数 | 0 - 100 (自動スケーリング) |

### エンドポイント一覧

| 関数名 | 種類 | 用途 | 認証 |
|--------|------|------|------|
| calculateScore | onCall | 点数計算 | App Check |
| getHistory | onCall | 履歴取得 | App Check + Auth |
| saveHistory | onCall | 履歴保存 | App Check + Auth |
| healthCheck | onRequest | ヘルスチェック | なし |

### 構成図

```
                    ┌─────────────────────────────┐
                    │      Cloud Functions         │
                    │      (asia-northeast1)       │
                    ├─────────────────────────────┤
  HTTPS Request ──▶ │  ┌───────────────────────┐  │
  (Callable)        │  │   calculateScore      │  │
                    │  │   - App Check 検証    │  │
                    │  │   - Zod バリデーション │  │
                    │  │   - mahjong-core 呼出 │  │
                    │  └───────────────────────┘  │
                    │                             │
                    │  ┌───────────────────────┐  │
                    │  │   getHistory          │──┼──▶ Firestore
                    │  │   saveHistory         │  │    読み取り/書込み
                    │  └───────────────────────┘  │
                    └─────────────────────────────┘
```

### スケーリング設定

```yaml
# 最小インスタンス (コールドスタート回避)
minInstances: 0  # 開発環境
minInstances: 1  # 本番環境 (推奨)

# 最大インスタンス
maxInstances: 100

# 同時実行数
concurrency: 80
```

---

## Cloud Firestore

### 基本情報

| 項目 | 設定値 |
|------|--------|
| モード | Native Mode |
| リージョン | asia-northeast1 (東京) |
| 課金 | 使用量ベース |

### コレクション設計

```
firestore/
├── history/                    # 履歴コレクション
│   └── {historyId}
│       ├── userId: string      # ユーザーID
│       ├── hand: object        # 手牌データ
│       ├── context: object     # 場の情報
│       ├── result: object      # 計算結果
│       └── createdAt: timestamp
```

### インデックス

```json
// firestore.indexes.json
{
  "indexes": [
    {
      "collectionGroup": "history",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "userId", "order": "ASCENDING" },
        { "fieldPath": "createdAt", "order": "DESCENDING" }
      ]
    }
  ]
}
```

### Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /history/{historyId} {
      // 読み取り: 自分のデータのみ
      allow read: if request.auth != null
                  && request.auth.uid == resource.data.userId;
      
      // 作成: 認証済み & 自分のuserIdのみ
      allow create: if request.auth != null
                    && request.auth.uid == request.resource.data.userId;
      
      // 更新・削除: 不可
      allow update, delete: if false;
    }
  }
}
```

---

## Firebase Authentication

### 基本情報

| 項目 | 設定値 |
|------|--------|
| 認証方式 | Anonymous (匿名認証) |
| 用途 | 履歴保存時のユーザー識別 |

### フロー

```
1. アプリ起動
2. 匿名認証で自動サインイン
3. UID を履歴保存時に使用
4. (オプション) 後からメール連携でアカウント変換
```

---

## Firebase App Check

### 基本情報

| 項目 | 設定値 |
|------|--------|
| 用途 | 正規アプリからのみ API アクセスを許可 |
| iOS プロバイダー | App Attest |
| Android プロバイダー | Play Integrity |

### 検証フロー

```
┌─────────────┐    ┌─────────────┐    ┌─────────────────┐
│ Flutter App │───▶│  App Check  │───▶│ Cloud Functions │
│             │    │   Token     │    │ enforceAppCheck │
└─────────────┘    └─────────────┘    └─────────────────┘
                          │                    │
                          │                    ▼
                   トークン検証 ─────────▶ 処理実行 or 401
```

### Cloud Functions 設定

```typescript
export const calculateScore = onCall(
  {
    region: 'asia-northeast1',
    enforceAppCheck: true,  // App Check 必須
  },
  async (request) => { /* ... */ }
);
```

---

## Firebase Hosting

### 基本情報

| 項目 | 設定値 |
|------|--------|
| 用途 | Flutter Web アプリ配信 |
| CDN | グローバルエッジキャッシュ |
| SSL | 自動 (Let's Encrypt) |

### デプロイ成果物

```
build/web/
├── index.html
├── main.dart.js
├── flutter.js
├── assets/
└── canvaskit/
```

### firebase.json

```json
{
  "hosting": {
    "public": "build/web",
    "ignore": ["firebase.json", "**/.*", "**/node_modules/**"],
    "rewrites": [
      {
        "source": "**",
        "destination": "/index.html"
      }
    ]
  }
}
```

---

## 料金見積もり

### 無料枠 (Spark プラン)

| サービス | 無料枠 |
|---------|--------|
| Cloud Functions | 200万回/月 |
| Firestore | 1GB ストレージ, 5万読取/日, 2万書込/日 |
| Firebase Auth | 無制限 (匿名) |
| App Check | 無料 |
| Hosting | 10GB ストレージ, 360MB/日 転送 |

### Blaze プラン (従量課金)

| サービス | 料金 |
|---------|------|
| Cloud Functions | $0.40/100万回 |
| Firestore | $0.18/10万読取 |
| Hosting | $0.15/GB |

> [!NOTE]
> 開発初期は Spark プランで十分。ユーザー増加に応じて Blaze に移行。
