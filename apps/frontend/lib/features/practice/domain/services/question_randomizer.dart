import 'dart:math';
import '../models/question.dart';

class QuestionRandomizer {
  static final Random _random = Random();

  /// 問題の牌構成をランダムに入れ替えるが、符や役の計算結果は変わらないようにする
  static Question randomize(Question question) {
    // 萬子・筒子・索子の入れ替えマップを作成
    final suits = [TileSuit.man, TileSuit.pin, TileSuit.sou];
    final shuffledSuits = List<TileSuit>.from(suits)..shuffle(_random);
    final suitMap = {
      suits[0]: shuffledSuits[0],
      suits[1]: shuffledSuits[1],
      suits[2]: shuffledSuits[2],
      TileSuit.honor: TileSuit.honor,
    };

    // 数牌の数字をオフセットさせる（ただし1-9の範囲を超えないように調整）
    // タンヤオなどの役がある場合は、数字の範囲に制約があるため、
    // ここでは安全のため、1,9,字牌が含まれるかどうかを判定してオフセットを制限する。
    // ※今回はシンプルに、同じ役・符が維持される「スートの入れ替え」のみを主軸にする。

    final randomizedGroups = question.groups.map((group) {
      final randomizedTiles = group.tiles.map((tile) {
        return Tile(
          suit: suitMap[tile.suit]!,
          number: tile.number,
          honor: tile.honor,
          isRed: tile.isRed,
        );
      }).toList();
      return TileGroup(
        type: group.type,
        tiles: randomizedTiles,
        isOpen: group.isOpen,
      );
    }).toList();

    return Question(
      id: '${question.id}_rand_${_random.nextInt(1000)}',
      title: question.title,
      groups: randomizedGroups,
      winningGroupIndex: question.winningGroupIndex,
      isTsumo: question.isTsumo,
      isDealer: question.isDealer,
      roundWind: question.roundWind,
      seatWind: question.seatWind,
      yaku: question.yaku,
      han: question.han,
      fu: question.fu,
      fuBreakdown: question.fuBreakdown,
      correctScore: question.correctScore,
      choices: question.choices,
      correctChoiceIndex: question.correctChoiceIndex,
      difficulty: question.difficulty,
      explanation: question.explanation,
    );
  }
}
