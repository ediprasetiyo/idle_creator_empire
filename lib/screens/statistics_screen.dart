import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../utils/formatters.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gp, _) {
        final player = gp.player;
        if (player == null) return const SizedBox.shrink();

        final totalCoins = player.lifetimeCoinsEarned + player.totalCoinsEarned;
        final totalViews = player.lifetimeViewsEarned + player.totalViewsEarned;
        final totalSeconds = player.totalOnlineSeconds + player.onlineSeconds;

        return Scaffold(
          backgroundColor: const Color(0xFF0E0E12),
          appBar: AppBar(
            backgroundColor: const Color(0xFF0E0E12),
            title: const Text(
              'Statistics',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            iconTheme: IconThemeData(color: Colors.white.withAlpha(200)),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _SectionHeader(title: 'Current Run'),
              _StatRow(icon: Icons.monetization_on, color: const Color(0xFFFFD600), label: 'Coins', value: formatNumber(player.coins)),
              _StatRow(icon: Icons.visibility, color: const Color(0xFF2979FF), label: 'Views', value: formatNumber(player.views)),
              _StatRow(icon: Icons.people, color: const Color(0xFFE040FB), label: 'Followers', value: formatNumber(player.followers)),
              _StatRow(icon: Icons.star, color: const Color(0xFF7C4DFF), label: 'Level', value: '${player.level}'),
              _StatRow(icon: Icons.military_tech, color: const Color(0xFFFF9100), label: 'Rank', value: player.rank),
              _StatRow(icon: Icons.speed, color: const Color(0xFF00E676), label: 'Coins/sec', value: formatNumber(player.coinsPerSecond)),
              _StatRow(icon: Icons.touch_app, color: const Color(0xFF2979FF), label: 'Coins/tap', value: formatNumber(player.coinsPerTap)),
              const SizedBox(height: 20),
              _SectionHeader(title: 'Lifetime'),
              _StatRow(icon: Icons.monetization_on, color: const Color(0xFFFFD600), label: 'Total Coins Earned', value: formatNumber(totalCoins)),
              _StatRow(icon: Icons.visibility, color: const Color(0xFF2979FF), label: 'Total Views Earned', value: formatNumber(totalViews)),
              _StatRow(icon: Icons.touch_app, color: const Color(0xFFFF9100), label: 'Total Taps', value: formatNumber(player.totalTaps.toDouble())),
              _StatRow(icon: Icons.shopping_bag, color: const Color(0xFF00BFA5), label: 'Upgrades Bought', value: '${player.totalUpgradesBought}'),
              _StatRow(icon: Icons.emoji_events, color: const Color(0xFFFFD600), label: 'Achievements', value: '${player.completedAchievements.length}'),
              _StatRow(icon: Icons.speed, color: const Color(0xFF00E676), label: 'Highest Income/s', value: formatNumber(player.highestCoinPerSecond)),
              const SizedBox(height: 20),
              _SectionHeader(title: 'Prestige & Time'),
              _StatRow(icon: Icons.refresh, color: const Color(0xFFE040FB), label: 'Prestiges', value: '${player.prestigeCount}'),
              _StatRow(icon: Icons.diamond, color: const Color(0xFF7C4DFF), label: 'Total PP Earned', value: '${player.totalPrestigePoints}'),
              _StatRow(icon: Icons.trending_up, color: const Color(0xFFFFD600), label: 'Prestige Multiplier', value: '${player.prestigeMultiplier.toStringAsFixed(1)}x'),
              _StatRow(icon: Icons.timer, color: const Color(0xFF2979FF), label: 'Time Played', value: formatTimeShort(totalSeconds)),
              _StatRow(icon: Icons.casino, color: const Color(0xFFFF9100), label: 'Wheel Spins', value: '${player.totalWheelSpins}'),
              _StatRow(icon: Icons.local_fire_department, color: const Color(0xFFFF1744), label: 'Login Streak', value: '${player.dailyLoginStreak} days'),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white.withAlpha(150),
          fontSize: 14,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String value;

  const _StatRow({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A24),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: Colors.white.withAlpha(180), fontSize: 13),
            ),
          ),
          Text(
            value,
            style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
