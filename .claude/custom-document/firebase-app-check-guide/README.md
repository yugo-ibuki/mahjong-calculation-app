# Firebase App Check + Cloud Functions + Flutter 構成ガイド

アプリ以外からのAPIアクセスを防ぎ、正規アプリからのみリクエストを受け付ける構成。

## 📚 ドキュメント構成

| ファイル | 内容 |
|---------|------|
| [overview.md](./overview.md) | App Checkの概要と仕組み |
| [cloud-functions.md](./cloud-functions.md) | Cloud Functions実装 |
| [flutter-client.md](./flutter-client.md) | Flutterクライアント実装 |
| [development.md](./development.md) | 開発環境設定・デバッグ |
| [security.md](./security.md) | セキュリティ対策・注意点 |

## 🎯 目的

- ログイン不要のアプリでも、APIへの不正アクセスを防ぐ
- 自分が配信しているアプリからのみAPIを呼び出せるようにする

## 🏗️ 構成図

```
┌─────────────┐
│  Flutter App │
│  (iOS/Android)│
└──────┬──────┘
       │ App Check Token 自動付与
       ▼
┌─────────────────┐
│  Cloud Functions │
│  (callable)      │
│  enforceAppCheck │
└──────┬──────────┘
       │ トークン検証（自動）
       ▼
   正規アプリ → 処理実行
   不正アクセス → 401 拒否
```

## 🛠️ 技術スタック

| レイヤー | 技術 |
|---------|------|
| クライアント | Flutter + Firebase SDK |
| 認証方式 | App Check (App Attest / Play Integrity) |
| API | Cloud Functions for Firebase (2nd gen) |
| 言語 | TypeScript |

## 💰 料金

| サービス | 料金 |
|---------|------|
| App Check | 無料 |
| Cloud Functions | 無料枠あり（月200万回呼び出しまで） |
| Play Integrity API | 1日1万回まで無料、超過分は課金 |

※ 最新の料金は公式ドキュメントを確認

## 🔗 参考リンク

- [Firebase App Check 公式ドキュメント](https://firebase.google.com/docs/app-check)
- [Cloud Functions for Firebase](https://firebase.google.com/docs/functions)
- [FlutterFire App Check](https://firebase.flutter.dev/docs/app-check/overview)
- [Play Integrity API](https://developer.android.com/google/play/integrity)
- [App Attest](https://developer.apple.com/documentation/devicecheck/establishing_your_app_s_integrity)
