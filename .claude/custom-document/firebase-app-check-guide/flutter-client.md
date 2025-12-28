# Flutter クライアント実装

## 依存関係

```yaml
# pubspec.yaml
dependencies:
  firebase_core: ^3.0.0
  firebase_app_check: ^0.3.0
  cloud_functions: ^5.0.0
```

## 初期化

```dart
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
    appleProvider: AppleProvider.appAttest,
  );
  
  runApp(const MyApp());
}
```

## API呼び出しクラス

```dart
// lib/services/api_service.dart
import 'package:cloud_functions/cloud_functions.dart';

class ApiService {
  final _functions = FirebaseFunctions.instance;

  Future<Map<String, dynamic>> getData(String id) async {
    final callable = _functions.httpsCallable('getData');
    final result = await callable.call({'id': id});
    return Map<String, dynamic>.from(result.data);
  }

  Future<bool> postData(String content) async {
    final callable = _functions.httpsCallable('postData');
    final result = await callable.call({'content': content});
    return result.data['success'] as bool;
  }

  Future<String> otherEndpoint() async {
    final callable = _functions.httpsCallable('otherEndpoint');
    final result = await callable.call();
    return result.data['message'] as String;
  }
}
```

## エラーハンドリング

```dart
try {
  final result = await apiService.getData('123');
} on FirebaseFunctionsException catch (e) {
  switch (e.code) {
    case 'unauthenticated':
      // App Check 検証失敗
      print('App Check failed');
      break;
    case 'invalid-argument':
      print('Invalid argument: ${e.message}');
      break;
    default:
      print('Error: ${e.message}');
  }
}
```
