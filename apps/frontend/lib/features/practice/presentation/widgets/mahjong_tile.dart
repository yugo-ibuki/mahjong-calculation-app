import 'package:flutter/material.dart';
import '../../domain/models/question.dart';

class MahjongTile extends StatelessWidget {
  final Tile tile;
  final bool isWinningTile;

  const MahjongTile({super.key, required this.tile, this.isWinningTile = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 52,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white,
            Colors.grey.shade100,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
          if (isWinningTile)
            BoxShadow(
              color: Colors.orange.withOpacity(0.5),
              blurRadius: 8,
              spreadRadius: 2,
            ),
        ],
        border: Border.all(
          color: isWinningTile ? Colors.orange.shade400 : Colors.grey.shade300,
          width: isWinningTile ? 2 : 1,
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSuitIcon(),
                if (tile.number != null)
                  Text(
                    tile.number.toString(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      height: 1.0,
                      color: tile.isRed ? Colors.red.shade700 : Colors.black87,
                    ),
                  ),
              ],
            ),
          ),
          if (tile.isRed)
            Positioned(
              top: 4,
              right: 4,
              child: Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSuitIcon() {
    String text = '';
    Color color = Colors.black87;

    switch (tile.suit) {
      case TileSuit.man:
        text = '萬';
        color = Colors.red.shade800;
        break;
      case TileSuit.pin:
        text = '筒';
        color = Colors.blue.shade800;
        break;
      case TileSuit.sou:
        text = '索';
        color = Colors.green.shade800;
        break;
      case TileSuit.honor:
        switch (tile.honor) {
          case HonorType.east: text = '東'; break;
          case HonorType.south: text = '南'; break;
          case HonorType.west: text = '西'; break;
          case HonorType.north: text = '北'; break;
          case HonorType.white: text = '白'; break;
          case HonorType.green: text = '發'; color = Colors.green.shade800; break;
          case HonorType.red: text = '中'; color = Colors.red.shade800; break;
          default: break;
        }
        break;
    }

    return Text(
      text,
      style: TextStyle(
        fontSize: 12, 
        color: color, 
        fontWeight: FontWeight.bold,
        height: 1.0,
      ),
    );
  }
}
