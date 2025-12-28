# App Check の概要と仕組み

## 検証フロー

1. アプリ起動時、OSがアプリの正当性を検証
2. 検証結果をもとに Firebase がトークンを発行
3. callable function 呼び出し時、トークンが自動で付与される
4. Cloud Functions 側でトークンを自動検証
5. 不正なトークン or トークンなし → 401 エラー

## プラットフォーム別プロバイダー

| Platform | Provider | 特徴 |
|----------|----------|------|
| iOS | App Attest | iOS 14+ 対応、高いセキュリティ |
| iOS (fallback) | DeviceCheck | iOS 11+ 対応、App Attest 非対応端末用 |
| Android | Play Integrity | Google Play 開発者サービス必須 |

## Firebase プロジェクトセットアップ

### 1. プロジェクト作成

1. [Firebase Console](https://console.firebase.google.com/) でプロジェクト作成
2. iOS / Android アプリを登録
3. `google-services.json` (Android) / `GoogleService-Info.plist` (iOS) をダウンロード

### 2. App Check 有効化

Firebase Console → App Check → アプリを選択

- **iOS**: App Attest を有効化
- **Android**: Play Integrity を有効化
