# 監視・運用

## 監視サービス構成

```
┌─────────────────────────────────────────────────────────┐
│                    監視スタック                          │
├─────────────────────────────────────────────────────────┤
│  Cloud Logging      │  ログ収集・分析                    │
│  Cloud Monitoring   │  メトリクス・アラート               │
│  Error Reporting    │  エラー集約                       │
│  Firebase Crashlytics│  クライアントクラッシュ            │
│  Firebase Analytics │  ユーザー行動分析                  │
└─────────────────────────────────────────────────────────┘
```

---

## Cloud Functions 監視

### メトリクス

| メトリクス | 説明 | しきい値 |
|-----------|------|---------|
| execution_count | 実行回数 | - |
| execution_times | レイテンシ | p99 < 1s |
| active_instances | アクティブインスタンス | < 100 |
| memory_usage | メモリ使用量 | < 80% |

### ダッシュボード例

```
┌───────────────────────────────────────────┐
│  Cloud Functions Dashboard                 │
├───────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────────────┐ │
│  │ Invocations │  │ Latency (p50/p99)   │ │
│  │   12,345    │  │  50ms / 200ms       │ │
│  └─────────────┘  └─────────────────────┘ │
│                                            │
│  ┌─────────────┐  ┌─────────────────────┐ │
│  │ Error Rate  │  │ Active Instances    │ │
│  │    0.1%     │  │        3            │ │
│  └─────────────┘  └─────────────────────┘ │
└───────────────────────────────────────────┘
```

---

## ログ設計

### 構造化ログ

```typescript
// Cloud Functions でのログ出力
import { logger } from 'firebase-functions/v2';

logger.info('Score calculated', {
  userId: request.auth?.uid ?? 'anonymous',
  han: result.han,
  fu: result.fu,
  score: result.score.total,
  latencyMs: endTime - startTime,
});

logger.error('Calculation failed', {
  userId: request.auth?.uid,
  error: error.message,
  stack: error.stack,
});
```

### ログレベル

| レベル | 用途 |
|--------|------|
| DEBUG | 開発時の詳細情報 |
| INFO | 正常な処理完了 |
| WARNING | 注意が必要な状況 |
| ERROR | エラー発生 |
| CRITICAL | サービス停止レベル |

### ログフィルター例

```
# calculateScore のエラーログのみ
resource.type="cloud_function"
resource.labels.function_name="calculateScore"
severity>=ERROR

# 特定ユーザーのログ
jsonPayload.userId="user-123"
```

---

## アラート設定

### アラートポリシー

| 条件 | しきい値 | 通知先 |
|------|---------|--------|
| エラー率 | > 1% (5分間) | Slack / Email |
| レイテンシ p99 | > 2秒 | Slack |
| 実行回数 | > 10,000/時 | Email |
| メモリ使用率 | > 90% | Slack |

### 設定例 (Terraform)

```hcl
resource "google_monitoring_alert_policy" "function_errors" {
  display_name = "Cloud Functions Error Rate"
  
  conditions {
    display_name = "Error rate > 1%"
    condition_threshold {
      filter          = "resource.type=\"cloud_function\" AND metric.type=\"cloudfunctions.googleapis.com/function/execution_count\" AND metric.label.status!=\"ok\""
      duration        = "300s"
      threshold_value = 0.01
      comparison      = "COMPARISON_GT"
      
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_RATE"
      }
    }
  }
  
  notification_channels = [google_monitoring_notification_channel.slack.name]
}
```

---

## Firebase Crashlytics

### 設定

```dart
// main.dart
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  // クラッシュレポート有効化
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  
  runApp(const MyApp());
}
```

### カスタムログ

```dart
// エラー発生時
try {
  await calculateScore();
} catch (e, stack) {
  await FirebaseCrashlytics.instance.recordError(
    e,
    stack,
    reason: 'Failed to calculate score',
  );
}
```

---

## Firebase Analytics

### イベント追跡

```dart
// 計算実行イベント
await FirebaseAnalytics.instance.logEvent(
  name: 'calculate_score',
  parameters: {
    'han': result.han,
    'is_yakuman': result.isYakuman,
  },
);
```

### 標準イベント

| イベント | 説明 |
|---------|------|
| app_open | アプリ起動 |
| screen_view | 画面表示 |
| calculate_score | 点数計算 |
| save_history | 履歴保存 |

---

## SLI / SLO

### サービスレベル指標 (SLI)

| SLI | 計測方法 |
|-----|---------|
| 可用性 | 成功リクエスト / 総リクエスト |
| レイテンシ | p50, p95, p99 レスポンスタイム |
| エラー率 | エラーリクエスト / 総リクエスト |

### サービスレベル目標 (SLO)

| 指標 | 目標 |
|------|------|
| 可用性 | 99.5% |
| レイテンシ p99 | < 500ms |
| エラー率 | < 0.5% |

---

## オンコール/インシデント対応

### エスカレーションフロー

```
1. アラート発火
   │
   ▼
2. オンコール担当者へ通知 (Slack)
   │
   ├── 対応可能 → 調査開始
   │
   └── 未対応 (15分) → SMS 通知
       │
       └── 未対応 (30分) → 電話通知
```

### インシデント対応チェックリスト

1. [ ] 影響範囲の確認
2. [ ] 一時対応 (ロールバック等)
3. [ ] 根本原因の調査
4. [ ] 恒久対策の実施
5. [ ] ポストモーテム作成

---

## 運用タスク

### 定期タスク

| タスク | 頻度 | 担当 |
|--------|------|------|
| ログレビュー | 日次 | 自動 |
| メトリクス確認 | 日次 | DevOps |
| セキュリティスキャン | 週次 | 自動 |
| コスト確認 | 月次 | DevOps |
| 依存関係更新 | 月次 | Dev |

### コスト監視

```bash
# 現在の利用状況確認
gcloud billing budgets describe BUDGET_ID

# 予算アラート設定
gcloud billing budgets update BUDGET_ID \
  --budget-amount=100USD \
  --threshold-rules=percent=50,basis=CURRENT_SPEND \
  --threshold-rules=percent=90,basis=CURRENT_SPEND
```
