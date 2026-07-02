import 'package:flutter/material.dart';
import '../models/boost.dart';
import '../models/player.dart';
import '../utils/formatters.dart';

class BoostBar extends StatelessWidget {
  final Player player;

  const BoostBar({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    final activeIds = player.activeBoostIds;
    if (activeIds.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Wrap(
        spacing: 8,
        runSpacing: 6,
        alignment: WrapAlignment.center,
        children: activeIds.map((id) {
          final boost = getBoostById(id);
          if (boost == null) return const SizedBox.shrink();
          final remaining = player.boostRemainingMs(id);
          return _BoostChip(boost: boost, remainingMs: remaining);
        }).toList(),
      ),
    );
  }
}

class _BoostChip extends StatelessWidget {
  final BoostDef boost;
  final int remainingMs;

  const _BoostChip({required this.boost, required this.remainingMs});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: boost.color.withAlpha(25),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: boost.color.withAlpha(60), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(boost.icon, size: 14, color: boost.color),
          const SizedBox(width: 4),
          Text(
            boost.name,
            style: TextStyle(
              color: boost.color,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            formatCountdown(remainingMs),
            style: TextStyle(
              color: boost.color.withAlpha(180),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
