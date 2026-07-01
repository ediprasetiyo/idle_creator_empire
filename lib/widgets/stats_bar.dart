import 'package:flutter/material.dart';
import '../models/player.dart';
import '../utils/formatters.dart';

class StatsBar extends StatelessWidget {
  final Player player;

  const StatsBar({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A24),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(
            icon: Icons.monetization_on,
            color: const Color(0xFFFFD600),
            label: 'Coins',
            value: formatNumber(player.coins),
          ),
          _StatItem(
            icon: Icons.visibility,
            color: const Color(0xFF2979FF),
            label: 'Views',
            value: formatNumber(player.views),
          ),
          _StatItem(
            icon: Icons.people,
            color: const Color(0xFFE040FB),
            label: 'Followers',
            value: formatNumber(player.followers),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withAlpha(120),
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
