import 'package:flutter/material.dart';
import '../../domain/models/question.dart';
import 'mahjong_tile.dart';

class HandWidget extends StatelessWidget {
  final List<TileGroup> groups;
  final int winningGroupIndex;

  const HandWidget({
    super.key,
    required this.groups,
    required this.winningGroupIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: groups.asMap().entries.map((entry) {
        final groupIndex = entry.key;
        final group = entry.value;
        final isWinningGroup = groupIndex == winningGroupIndex;

        return Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isWinningGroup ? Colors.orange.withOpacity(0.1) : null,
            border: isWinningGroup ? Border.all(color: Colors.orange.shade300) : null,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: group.tiles.asMap().entries.map((tileEntry) {
              final tileIndex = tileEntry.key;
              final tile = tileEntry.value;
              final isLastTile = tileIndex == group.tiles.length - 1;
              
              return MahjongTile(
                tile: tile,
                isWinningTile: isWinningGroup && isLastTile,
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }
}
