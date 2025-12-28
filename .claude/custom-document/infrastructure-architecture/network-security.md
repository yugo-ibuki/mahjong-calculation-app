# ネットワーク・セキュリティ構成

## ネットワーク構成

### 全体図

```
                                    インターネット
                                         │
                    ┌────────────────────┼────────────────────┐
                    │                    │                    │
               ┌────┴────┐          ┌────┴────┐          ┌────┴────┐
               │   iOS   │          │ Android │          │   Web   │
               │   App   │          │   App   │          │  App    │
               └────┬────┘          └────┬────┘          └────┬────┘
                    │                    │                    │
                    └────────────────────┼────────────────────┘
                                         │
                                    HTTPS (TLS 1.3)
                                         │
                    ┌────────────────────┼────────────────────┐
                    │                    ▼                    │
                    │   ┌────────────────────────────────┐   │
                    │   │      Google Front End          │   │
                    │   │      (GFE / Load Balancer)     │   │
                    │   └────────────────┬───────────────┘   │
                    │                    │                    │
                    │                    ▼                    │
                    │   ┌────────────────────────────────┐   │
                    │   │       Cloud Functions          │   │
                    │   │       (asia-northeast1)        │   │
                    │   └────────────────┬───────────────┘   │
                    │                    │                    │
                    │              内部通信 (VPC)              │
                    │                    │                    │
                    │                    ▼                    │
                    │   ┌────────────────────────────────┐   │
                    │   │         Firestore              │   │
                    │   │       (asia-northeast1)        │   │
                    │   └────────────────────────────────┘   │
                    │                                         │
                    │              Google Cloud Platform      │
                    └─────────────────────────────────────────┘
```

### 通信プロトコル

| 経路 | プロトコル | ポート | 暗号化 |
|------|----------|--------|--------|
| Client → GFE | HTTPS | 443 | TLS 1.3 |
| GFE → Functions | HTTP/2 | 内部 | Google 内部 |
| Functions → Firestore | gRPC | 内部 | Google 内部 |

---

## セキュリティ層

### 多層防御構成

```
┌─────────────────────────────────────────────────────┐
│                    Layer 1: App Check                │
│  アプリ正当性検証 (App Attest / Play Integrity)       │
├─────────────────────────────────────────────────────┤
│                    Layer 2: Firebase Auth            │
│  ユーザー認証 (履歴アクセス時)                        │
├─────────────────────────────────────────────────────┤
│                    Layer 3: HTTPS/TLS               │
│  通信暗号化                                          │
├─────────────────────────────────────────────────────┤
│                    Layer 4: Validation              │
│  入力バリデーション (Zod スキーマ)                    │
├─────────────────────────────────────────────────────┤
│                    Layer 5: Firestore Rules         │
│  データアクセス制御                                   │
└─────────────────────────────────────────────────────┘
```

---

## App Check (アプリ検証)

### iOS: App Attest

```yaml
検証内容:
  - アプリ署名の正当性
  - デバイスの整合性
  - 改ざん検知
  
要件:
  - iOS 14.0+
  - Apple Developer Program メンバーシップ
```

### Android: Play Integrity

```yaml
検証内容:
  - APK 署名検証
  - Play Store 配信確認
  - デバイス整合性

要件:
  - Google Play 開発者サービス
  - Play Console へのアプリ登録
```

### 検証フロー詳細

```
1. アプリ起動
   │
   ▼
2. OS レベル検証 (App Attest / Play Integrity)
   │
   ▼
3. Firebase SDK がトークン取得
   │
   ▼
4. API 呼び出し時にトークン自動付与
   │
   ▼
5. Cloud Functions がトークン検証
   │
   ├── 有効 → 処理続行
   │
   └── 無効 → 401 Unauthorized
```

---

## Firebase Authentication

### 認証フロー

```
┌──────────┐     ┌──────────────┐     ┌──────────┐
│  Client  │────▶│ Firebase Auth │────▶│  ID Token │
└──────────┘     └──────────────┘     └──────────┘
                                            │
                                            ▼
                                   ┌─────────────────┐
                                   │ Cloud Functions │
                                   │ request.auth    │
                                   └─────────────────┘
```

### 認証方式

| 方式 | 用途 | セキュリティレベル |
|------|------|-------------------|
| 匿名認証 | 計算機能のみ利用 | 低 |
| メール/パスワード | 履歴保存 | 中 |
| OAuth (Google) | ソーシャルログイン | 高 |

---

## 入力バリデーション

### Zod スキーマによる検証

```typescript
// 全リクエストを厳密に検証
const calculateScoreSchema = z.object({
  hand: handSchema,      // 手牌
  context: contextSchema // ゲームコンテキスト
});

// 不正なデータ → 400 Bad Request
```

### 検証項目

| 項目 | 検証内容 |
|------|---------|
| tiles | 牌の種類・数値範囲 |
| melds | 面子の構成妥当性 |
| context | 場況パラメータ範囲 |

---

## Firestore Security Rules

### アクセス制御ポリシー

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // 履歴コレクション
    match /history/{historyId} {
      // 読み取り: 自分のデータのみ
      allow read: if isAuthenticated() 
                  && isOwner(resource.data.userId);
      
      // 作成: 認証済み & 自分のUID設定のみ
      allow create: if isAuthenticated() 
                    && isOwner(request.resource.data.userId);
      
      // 更新・削除: 禁止 (履歴は不変)
      allow update, delete: if false;
    }
    
    // ヘルパー関数
    function isAuthenticated() {
      return request.auth != null;
    }
    
    function isOwner(userId) {
      return request.auth.uid == userId;
    }
  }
}
```

---

## 脅威対策

### 対策済み攻撃ベクター

| 攻撃 | 対策 |
|------|------|
| API 不正呼出 | App Check |
| 中間者攻撃 | TLS 1.3 |
| インジェクション | Zod バリデーション |
| 権限昇格 | Firestore Rules |
| 総当たり攻撃 | レート制限 (Functions) |
| 他ユーザーデータ | Security Rules で UID 検証 |

### 未対策 / 許容リスク

| リスク | 対応方針 |
|--------|---------|
| DDoS | Cloud Armor 導入検討 (大規模化時) |
| 脱獄/root端末 | App Attest/Play Integrity で軽減 |
| リバースエンジニアリング | 難読化 + サーバーサイドロジック |

---

## 監査ログ

### 収集対象

| イベント | 保存先 | 保持期間 |
|---------|--------|---------|
| Functions 呼出 | Cloud Logging | 30日 |
| Auth イベント | Firebase | 30日 |
| Firestore アクセス | Cloud Logging | 30日 |

### ログ形式例

```json
{
  "timestamp": "2024-01-15T10:30:00Z",
  "severity": "INFO",
  "function": "calculateScore",
  "userId": "anonymous-xxxx",
  "appCheckToken": "valid",
  "latency": "150ms"
}
```
