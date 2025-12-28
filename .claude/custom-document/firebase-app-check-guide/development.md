# 開発環境での設定

## デバッグプロバイダーの使用

本番用の App Attest / Play Integrity はデバッグビルドでは動作しない。

### Flutter側

```dart
// 開発時のみ
await FirebaseAppCheck.instance.activate(
  androidProvider: AndroidProvider.debug,
  appleProvider: AppleProvider.debug,
);
```

### デバッグトークンの登録

1. アプリを起動するとコンソールにデバッグトークンが出力される
2. Firebase Console → App Check → デバッグトークンを管理 → トークンを追加

## 環境分岐

```dart
import 'package:flutter/foundation.dart';

Future<void> initializeAppCheck() async {
  if (kDebugMode) {
    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.debug,
      appleProvider: AppleProvider.debug,
    );
  } else {
    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.playIntegrity,
      appleProvider: AppleProvider.appAttest,
    );
  }
}
```

## 注意点

- デバッグトークンは開発者のみが使用し、外部に漏洩しないよう管理する
- 本番ビルドでは必ず `kDebugMode` が `false` になることを確認する
- CI/CD環境では適切な環境変数で切り替えを行う
