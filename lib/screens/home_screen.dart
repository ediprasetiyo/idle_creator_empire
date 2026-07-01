import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/stats_bar.dart';
import '../widgets/level_progress.dart';
import '../widgets/tap_button.dart';
import '../utils/formatters.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        final player = gameProvider.player;
        if (player == null) return const SizedBox.shrink();

        final career = player.career;

        return Scaffold(
          backgroundColor: const Color(0xFF0E0E12),
          appBar: AppBar(
            backgroundColor: const Color(0xFF0E0E12),
            centerTitle: true,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(career.icon, color: career.color, size: 22),
                const SizedBox(width: 8),
                Text(
                  '${career.label} Creator',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A24),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.monetization_on,
                        color: Color(0xFFFFD600),
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        formatNumber(player.coins),
                        style: const TextStyle(
                          color: Color(0xFFFFD600),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              StatsBar(player: player),
              LevelProgress(player: player, accentColor: career.color),
              const Spacer(),
              TapButton(
                color: career.color,
                icon: career.icon,
                label: 'CREATE\nCONTENT',
                coinsPerTap: player.coinsPerTap,
                viewsPerTap: player.viewsPerTap,
                onTap: () => gameProvider.tap(),
              ),
              const SizedBox(height: 12),
              Text(
                '+${formatNumber(player.coinsPerTap)} coins  ·  +${formatNumber(player.viewsPerTap)} views per tap',
                style: TextStyle(
                  color: Colors.white.withAlpha(80),
                  fontSize: 12,
                ),
              ),
              const Spacer(),
            ],
          ),
          bottomNavigationBar: NavigationBar(
            backgroundColor: const Color(0xFF1A1A24),
            selectedIndex: 0,
            indicatorColor: career.color.withAlpha(40),
            destinations: [
              NavigationDestination(
                icon: Icon(Icons.home_outlined,
                    color: Colors.white.withAlpha(120)),
                selectedIcon: Icon(Icons.home, color: career.color),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.upgrade_outlined,
                    color: Colors.white.withAlpha(60)),
                selectedIcon:
                    Icon(Icons.upgrade, color: Colors.white.withAlpha(60)),
                label: 'Upgrades',
              ),
              NavigationDestination(
                icon: Icon(Icons.emoji_events_outlined,
                    color: Colors.white.withAlpha(60)),
                selectedIcon: Icon(Icons.emoji_events,
                    color: Colors.white.withAlpha(60)),
                label: 'Achieve',
              ),
              NavigationDestination(
                icon: Icon(Icons.settings_outlined,
                    color: Colors.white.withAlpha(60)),
                selectedIcon:
                    Icon(Icons.settings, color: Colors.white.withAlpha(60)),
                label: 'Settings',
              ),
            ],
            onDestinationSelected: (_) {},
          ),
        );
      },
    );
  }
}
