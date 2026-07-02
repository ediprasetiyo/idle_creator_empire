import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../utils/formatters.dart';
import 'daily_reward_screen.dart';
import 'iap_shop_screen.dart';
import 'leaderboard_screen.dart';
import 'prestige_screen.dart';
import 'settings_screen.dart';
import 'statistics_screen.dart';
import 'wheel_screen.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gp, _) {
        final player = gp.player;
        if (player == null) return const SizedBox.shrink();

        final hasDailyReward = gp.hasDailyRewardAvailable;
        final canSpin = player.canSpinWheel;
        final cooldownMs = player.wheelCooldownRemaining;

        return Scaffold(
          backgroundColor: const Color(0xFF0E0E12),
          appBar: AppBar(
            backgroundColor: const Color(0xFF0E0E12),
            centerTitle: true,
            title: const Text(
              'More',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _MenuTile(
                icon: Icons.refresh,
                color: const Color(0xFFE040FB),
                label: 'Prestige',
                subtitle: '${player.prestigeCount} rebirths · ${player.prestigePoints} PP',
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PrestigeScreen())),
              ),
              _MenuTile(
                icon: Icons.calendar_month,
                color: const Color(0xFFFF9100),
                label: 'Daily Reward',
                subtitle: hasDailyReward ? 'Reward available!' : 'Streak: ${player.dailyLoginStreak} days',
                badge: hasDailyReward ? '!' : null,
                badgeColor: const Color(0xFFFF1744),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DailyRewardScreen())),
              ),
              _MenuTile(
                icon: Icons.casino,
                color: const Color(0xFFFFD600),
                label: 'Lucky Wheel',
                subtitle: canSpin ? 'Free spin available!' : 'Next spin: ${formatCountdown(cooldownMs)}',
                badge: canSpin ? 'FREE' : null,
                badgeColor: const Color(0xFF00E676),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WheelScreen())),
              ),
              _MenuTile(
                icon: Icons.leaderboard,
                color: const Color(0xFFFFD600),
                label: 'Leaderboard',
                subtitle: 'See top creators worldwide',
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LeaderboardScreen())),
              ),
              _MenuTile(
                icon: Icons.shopping_cart,
                color: const Color(0xFF00E676),
                label: 'Premium Shop',
                subtitle: player.isVip ? 'VIP Active' : 'Boosts, coins & more',
                badge: player.isVip ? 'VIP' : null,
                badgeColor: const Color(0xFFE040FB),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const IapShopScreen())),
              ),
              _MenuTile(
                icon: Icons.bar_chart,
                color: const Color(0xFF2979FF),
                label: 'Statistics',
                subtitle: 'View your empire stats',
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StatisticsScreen())),
              ),
              _MenuTile(
                icon: Icons.settings,
                color: Colors.white.withAlpha(180),
                label: 'Settings',
                subtitle: 'Audio, save, cloud sync',
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
              ),
              const SizedBox(height: 24),
              _AdTile(
                icon: Icons.bolt,
                color: const Color(0xFFFFD600),
                label: 'Watch Ad: 2x Income (15min)',
                onTap: () => gp.watchAdForBoost(),
              ),
              _AdTile(
                icon: Icons.monetization_on,
                color: const Color(0xFF00E676),
                label: 'Watch Ad: Bonus Coins',
                onTap: () => gp.watchAdForCoins(),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String subtitle;
  final String? badge;
  final Color? badgeColor;
  final VoidCallback onTap;

  const _MenuTile({
    required this.icon,
    required this.color,
    required this.label,
    required this.subtitle,
    this.badge,
    this.badgeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '$label: $subtitle',
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A24),
          borderRadius: BorderRadius.circular(14),
        ),
        child: ListTile(
          leading: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withAlpha(20),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          title: Row(
            children: [
              Text(label, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
              if (badge != null) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: badgeColor ?? Colors.redAccent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    badge!,
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ],
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(color: Colors.white.withAlpha(100), fontSize: 12),
          ),
          trailing: Icon(Icons.chevron_right, color: Colors.white.withAlpha(60), size: 20),
          onTap: onTap,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        ),
      ),
    );
  }
}

class _AdTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;

  const _AdTile({
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A24),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withAlpha(30)),
        ),
        child: ListTile(
          leading: Icon(Icons.play_circle_outline, color: color, size: 28),
          title: Text(label, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.bold)),
          trailing: Icon(icon, color: color, size: 20),
          onTap: onTap,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        ),
      ),
    );
  }
}
