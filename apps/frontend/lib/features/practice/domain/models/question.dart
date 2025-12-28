enum TileSuit { man, pin, sou, honor }

enum HonorType { east, south, west, north, white, green, red }

class Tile {
  final TileSuit suit;
  final int? number;
  final HonorType? honor;
  final bool isRed;

  Tile({required this.suit, this.number, this.honor, this.isRed = false});

  factory Tile.fromJson(Map<String, dynamic> json) => Tile(
        suit: TileSuit.values.byName(json['suit']),
        number: json['number'],
        honor: json['honor'] != null ? HonorType.values.byName(json['honor']) : null,
        isRed: json['isRed'] ?? false,
      );
}

enum GroupType { sequence, triplet, quad, pair }

class TileGroup {
  final GroupType type;
  final List<Tile> tiles;
  final bool isOpen;

  TileGroup({required this.type, required this.tiles, required this.isOpen});
}

class Score {
  final int total;
  final int? dealer;
  final int? nonDealer;

  Score({required this.total, this.dealer, this.nonDealer});
}

class Choice {
  final int total;
  final int? dealer;
  final int? nonDealer;

  Choice({required this.total, this.dealer, this.nonDealer});
}

class Question {
  final String id;
  final String title;
  final List<TileGroup> groups;
  final int winningGroupIndex;
  final bool isTsumo;
  final bool isDealer;
  final String roundWind;
  final String seatWind;
  final List<Map<String, dynamic>> yaku;
  final int han;
  final int fu;
  final List<Map<String, dynamic>> fuBreakdown;
  final Score correctScore;
  final List<Choice> choices;
  final int correctChoiceIndex;
  final String difficulty;
  final String explanation;

  Question({
    required this.id,
    required this.title,
    required this.groups,
    required this.winningGroupIndex,
    required this.isTsumo,
    required this.isDealer,
    required this.roundWind,
    required this.seatWind,
    required this.yaku,
    required this.han,
    required this.fu,
    required this.fuBreakdown,
    required this.correctScore,
    required this.choices,
    required this.correctChoiceIndex,
    required this.difficulty,
    required this.explanation,
  });
}
