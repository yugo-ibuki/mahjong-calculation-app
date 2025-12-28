# セキュリティ上の注意点

## App Check の限界

- **完璧ではない**: 高度な攻撃（rooted端末、リバースエンジニアリング）には突破される可能性あり
- **多層防御が重要**: App Check だけに頼らない

## 推奨される追加対策

| 対策 | 目的 |
|------|------|
| レート制限 | 大量リクエストによる攻撃を防ぐ |
| 入力バリデーション | 不正なデータの処理を防ぐ |
| ログ・モニタリング | 異常なアクセスパターンを検知 |
| Cloud Armor | DDoS対策（大規模な場合） |

## レート制限の実装例（Functions側）

```typescript
import { onCall, HttpsError } from "firebase-functions/v2/https";

const rateLimitMap = new Map<string, number[]>();
const RATE_LIMIT = 10; // 10リクエスト
const WINDOW_MS = 60000; // 1分間

const checkRateLimit = (ip: string): boolean => {
  const now = Date.now();
  const timestamps = rateLimitMap.get(ip) || [];
  const recentTimestamps = timestamps.filter(t => now - t < WINDOW_MS);
  
  if (recentTimestamps.length >= RATE_LIMIT) {
    return false;
  }
  
  recentTimestamps.push(now);
  rateLimitMap.set(ip, recentTimestamps);
  return true;
};

export const myEndpoint = onCall(
  { enforceAppCheck: true },
  async (request) => {
    const ip = request.rawRequest.ip || "unknown";
    
    if (!checkRateLimit(ip)) {
      throw new HttpsError("resource-exhausted", "Too many requests");
    }
    
    // 処理
  }
);
```

## セキュリティチェックリスト

- [ ] App Check を全ての callable functions で有効化
- [ ] レート制限を適切に設定
- [ ] 入力バリデーションを実装
- [ ] エラーメッセージで内部情報を漏洩しない
- [ ] ログとモニタリングを設定
- [ ] 定期的にセキュリティレビューを実施
