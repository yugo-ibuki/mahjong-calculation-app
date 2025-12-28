import 'package:flutter/material.dart';
import '../../domain/models/question.dart';

class MahjongTile extends StatelessWidget {
  final Tile tile;
  final bool isWinningTile;

  const MahjongTile({super.key, required this.tile, this.isWinningTile = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 48,
      margin: const EdgeInsets.symmetric(horizontal: 1),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: isWinningTile ? Colors.red.withOpacity(0.3) : Colors.black12,
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildSuitIcon(context),
          if (tile.number != null)
            Text(
              tile.number.toString(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: tile.isRed ? Colors.red : Colors.black,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSuitIcon(BuildContext context) {
    String text = '';
    Color color = Colors.black;

    switch (tile.suit) {
      case TileSuit.man:
        text = '萬';
        color = Colors.red.shade900;
        break;
      case TileSuit.pin:
        text = '筒';
        color = Colors.blue.shade900;
        break;
      case TileSuit.sou:
        text = '索';
        color = Colors.green.shade900;
        break;
      case TileSuit.honor:
        switch (tile.honor) {
          case HonorType.east: text = '東'; break;
          case HonorType.south: text = '南'; break;
          case HonorType.west: text = '西'; break;
          case HonorType.north: text = '北'; break;
          case HonorType.white: text = '白'; break;
          case HonorType.green: text = '發'; color = Colors.green.shade900; break;
          case HonorType.red: text = '中'; color = Colors.red.shade900; break;
          default: break;
        }
        break;
    }

    return Text(
      text,
      style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold),
    );
  }
}
