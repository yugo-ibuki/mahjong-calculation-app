# Flutter フロントエンド設計

## 技術選定

| カテゴリ | 選定 | 理由 |
|---------|------|------|
| 状態管理 | Riverpod | 型安全、テスタビリティ、Provider改良版 |
| ルーティング | go_router | 公式推奨、型安全、Deep Link対応 |
| HTTP | dio | インターセプター、エラーハンドリング充実 |
| DI | riverpod (built-in) | 追加ライブラリ不要 |
| ローカルDB | shared_preferences / Hive | 履歴保存用 |

## アーキテクチャ

Feature-First + Clean Architecture のハイブリッド構成。

```
lib/
├── main.dart
├── app/
│   ├── app.dart              # MaterialApp 設定
│   └── routes.dart           # go_router 設定
├── features/
│   ├── calculation/          # 点数計算機能
│   │   ├── presentation/     # UI層
│   │   │   ├── pages/
│   │   │   │   └── calculation_page.dart
│   │   │   ├── widgets/
│   │   │   │   ├── tile_selector.dart
│   │   │   │   └── score_display.dart
│   │   │   └── providers/
│   │   │       └── calculation_provider.dart
│   │   ├── domain/           # ドメイン層
│   │   │   ├── entities/
│   │   │   │   └── hand.dart
│   │   │   └── usecases/
│   │   │       └── calculate_score.dart
│   │   └── data/             # データ層
│   │       ├── repositories/
│   │       │   └── calculation_repository.dart
│   │       └── datasources/
│   │           └── calculation_api.dart
│   └── history/              # 履歴機能
│       └── ...
├── shared/
│   ├── types/                # 型定義 (TypeScriptと同期)
│   ├── widgets/              # 共通ウィジェット
│   ├── themes/               # テーマ設定
│   ├── utils/                # ユーティリティ
│   └── providers/            # 共通プロバイダー
└── generated/                # コード生成物
```

## 主要コンポーネント

### エントリーポイント

```dart
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/app.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MahjongApp(),
    ),
  );
}
```

### アプリ設定

```dart
// lib/app/app.dart
import 'package:flutter/material.dart';
import 'routes.dart';

class MahjongApp extends StatelessWidget {
  const MahjongApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '麻雀点数計算',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
        ),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
```

### ルーティング

```dart
// lib/app/routes.dart
import 'package:go_router/go_router.dart';
import '../features/calculation/presentation/pages/calculation_page.dart';
import '../features/history/presentation/pages/history_page.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const CalculationPage(),
    ),
    GoRoute(
      path: '/history',
      builder: (context, state) => const HistoryPage(),
    ),
  ],
);
```

## 機能: 点数計算

### プロバイダー

```dart
// lib/features/calculation/presentation/providers/calculation_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/calculate_score.dart';
import '../../../shared/types/hand.dart';
import '../../../shared/types/score.dart';

// 手牌の状態
final handProvider = StateNotifierProvider<HandNotifier, Hand>((ref) {
  return HandNotifier();
});

class HandNotifier extends StateNotifier<Hand> {
  HandNotifier() : super(Hand.empty());

  void addTile(Tile tile) {
    state = state.copyWith(tiles: [...state.tiles, tile]);
  }

  void removeTile(int index) {
    final newTiles = [...state.tiles]..removeAt(index);
    state = state.copyWith(tiles: newTiles);
  }

  void setWinningTile(Tile tile) {
    state = state.copyWith(winningTile: tile);
  }

  void setTsumo(bool isTsumo) {
    state = state.copyWith(isTsumo: isTsumo);
  }

  void reset() {
    state = Hand.empty();
  }
}

// 計算結果
final scoreResultProvider = FutureProvider.autoDispose<ScoreResult?>((ref) async {
  final hand = ref.watch(handProvider);
  final context = ref.watch(gameContextProvider);

  if (!hand.isComplete) return null;

  final usecase = ref.read(calculateScoreUsecaseProvider);
  return usecase.execute(hand, context);
});
```

### ページ

```dart
// lib/features/calculation/presentation/pages/calculation_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/calculation_provider.dart';
import '../widgets/tile_selector.dart';
import '../widgets/score_display.dart';

class CalculationPage extends ConsumerWidget {
  const CalculationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hand = ref.watch(handProvider);
    final scoreResult = ref.watch(scoreResultProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('点数計算'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => context.push('/history'),
          ),
        ],
      ),
      body: Column(
        children: [
          // 手牌表示
          HandDisplay(hand: hand),

          // 牌選択
          const Expanded(child: TileSelector()),

          // 計算結果
          scoreResult.when(
            data: (result) => result != null
                ? ScoreDisplay(result: result)
                : const SizedBox.shrink(),
            loading: () => const CircularProgressIndicator(),
            error: (e, _) => Text('Error: $e'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(handProvider.notifier).reset(),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
```

### ウィジェット: 牌選択

```dart
// lib/features/calculation/presentation/widgets/tile_selector.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/calculation_provider.dart';
import '../../../shared/types/tile.dart';

class TileSelector extends ConsumerWidget {
  const TileSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: '萬子'),
              Tab(text: '筒子'),
              Tab(text: '索子'),
              Tab(text: '字牌'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildNumberTiles(ref, TileSuit.man),
                _buildNumberTiles(ref, TileSuit.pin),
                _buildNumberTiles(ref, TileSuit.sou),
                _buildHonorTiles(ref),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberTiles(WidgetRef ref, TileSuit suit) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 9,
      ),
      itemCount: 9,
      itemBuilder: (context, index) {
        final tile = Tile(suit: suit, number: index + 1);
        return TileButton(
          tile: tile,
          onTap: () => ref.read(handProvider.notifier).addTile(tile),
        );
      },
    );
  }

  Widget _buildHonorTiles(WidgetRef ref) {
    final honors = HonorType.values;
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
      ),
      itemCount: honors.length,
      itemBuilder: (context, index) {
        final tile = Tile(suit: TileSuit.honor, honor: honors[index]);
        return TileButton(
          tile: tile,
          onTap: () => ref.read(handProvider.notifier).addTile(tile),
        );
      },
    );
  }
}

class TileButton extends StatelessWidget {
  final Tile tile;
  final VoidCallback onTap;

  const TileButton({
    super.key,
    required this.tile,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Text(
            tile.displayName,
            style: const TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
```

## API 連携

### Repository

```dart
// lib/features/calculation/data/repositories/calculation_repository.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../datasources/calculation_api.dart';
import '../../domain/entities/hand.dart';
import '../../../shared/types/score.dart';

final calculationRepositoryProvider = Provider((ref) {
  final api = ref.read(calculationApiProvider);
  return CalculationRepository(api);
});

class CalculationRepository {
  final CalculationApi _api;

  CalculationRepository(this._api);

  Future<ScoreResult> calculateScore(Hand hand, GameContext context) async {
    final response = await _api.calculate(
      CalculateScoreRequest(hand: hand, context: context),
    );

    if (!response.success) {
      throw CalculationException(response.error!.message);
    }

    return response.result!;
  }
}
```

### API Client

```dart
// lib/features/calculation/data/datasources/calculation_api.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider((ref) {
  return Dio(BaseOptions(
    baseUrl: const String.fromEnvironment(
      'API_URL',
      defaultValue: 'http://localhost:5001/project-id/region',
    ),
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));
});

final calculationApiProvider = Provider((ref) {
  return CalculationApi(ref.read(dioProvider));
});

class CalculationApi {
  final Dio _dio;

  CalculationApi(this._dio);

  Future<CalculateScoreResponse> calculate(CalculateScoreRequest request) async {
    final response = await _dio.post(
      '/calculateScore',
      data: request.toJson(),
    );
    return CalculateScoreResponse.fromJson(response.data);
  }
}
```

## テスト戦略

### Widget Test

```dart
// test/features/calculation/presentation/widgets/tile_selector_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('TileSelector adds tile on tap', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: TileSelector()),
      ),
    );

    // 1萬をタップ
    await tester.tap(find.text('1萬'));
    await tester.pump();

    // 手牌に追加されていることを確認
    // ...
  });
}
```

### Provider Test

```dart
// test/features/calculation/presentation/providers/calculation_provider_test.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('HandNotifier adds tile correctly', () {
    final container = ProviderContainer();
    final notifier = container.read(handProvider.notifier);

    notifier.addTile(Tile(suit: TileSuit.man, number: 1));

    final hand = container.read(handProvider);
    expect(hand.tiles.length, 1);
    expect(hand.tiles.first.number, 1);
  });
}
```

## 依存パッケージ (pubspec.yaml)

```yaml
name: mahjong_calculation_app
description: 麻雀点数計算アプリ
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.4.0
  go_router: ^12.0.0
  dio: ^5.3.0
  shared_preferences: ^2.2.0
  freezed_annotation: ^2.4.0
  json_annotation: ^4.8.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
  build_runner: ^2.4.0
  freezed: ^2.4.0
  json_serializable: ^6.7.0
  mockito: ^5.4.0
```
