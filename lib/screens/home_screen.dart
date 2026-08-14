import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/achievement.dart';
import '../providers/game_provider.dart';
import '../widgets/achievement_popup.dart';
import '../widgets/boost_bar.dart';
import '../widgets/level_progress.dart';
import '../widgets/level_up_overlay.dart';
import '../widgets/particle_overlay.dart';
import '../widgets/stats_bar.dart';
import '../widgets/tap_button.dart';
import '../widgets/tutorial_overlay.dart';
import '../utils/formatters.dart';
import 'achievement_screen.dart';
import 'mission_screen.dart';
import 'more_screen.dart';
import 'upgrade_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  int? _levelUpValue;
  Achievement? _pendingAchievement;
  bool _dailyRewardChecked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showOfflineEarnings();
      _checkDailyReward();
    });
  }

  void _showOfflineEarnings() {
    final gameProvider = context.read<GameProvider>();
    final earnings = gameProvider.offlineEarnings;
    if (earnings == null || !earnings.hasEarnings) return;

    showDialog(
      context: context,
      builder: (ctx) {
        final career = gameProvider.player!.career;
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Column(
            children: [
              Icon(Icons.nightlight_round, color: career.color, size: 40),
              const SizedBox(height: 8),
              const Text(
                'Welcome Back!',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'While you were away for ${formatDuration(earnings.duration)}:',
                style: TextStyle(
                  color: Colors.white.withAlpha(150),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 16),
              if (earnings.coins > 0)
                _OfflineRow(
                  icon: Icons.monetization_on,
                  color: const Color(0xFFFFD600),
                  label: 'Coins',
                  value: '+${formatNumber(earnings.coins)}',
                ),
              if (earnings.views > 0)
                _OfflineRow(
                  icon: Icons.visibility,
                  color: const Color(0xFF2979FF),
                  label: 'Views',
                  value: '+${formatNumber(earnings.views)}',
                ),
              if (earnings.followers > 0)
                _OfflineRow(
                  icon: Icons.people,
                  color: const Color(0xFFE040FB),
                  label: 'Followers',
                  value: '+${formatNumber(earnings.followers)}',
                ),
            ],
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.of(ctx).pop(),
                style: FilledButton.styleFrom(
                  backgroundColor: career.color,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Collect',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    ).then((_) {
      gameProvider.clearOfflineEarnings();
    });
  }

  void _checkDailyReward() {
    if (_dailyRewardChecked) return;
    _dailyRewardChecked = true;
    final gp = context.read<GameProvider>();
    if (gp.hasDailyRewardAvailable) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: const Color(0xFF1A1A24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Column(
            children: [
              Icon(Icons.card_giftcard, color: Color(0xFFFF9100), size: 40),
              SizedBox(height: 8),
              Text('Daily Reward Available!', style: TextStyle(color: Colors.white, fontSize: 18)),
            ],
          ),
          content: Text(
            'Your daily login reward is ready to claim!',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white.withAlpha(150), fontSize: 13),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('Later', style: TextStyle(color: Colors.white.withAlpha(120))),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                setState(() => _currentIndex = 4);
              },
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFFF9100),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Go Claim!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
    }
  }

  void _checkPendingEvents(GameProvider gameProvider) {
    if (_levelUpValue != null || _pendingAchievement != null) return;

    final lv = gameProvider.consumeLevelUp();
    if (lv != null) {
      setState(() => _levelUpValue = lv);
      return;
    }

    final ach = gameProvider.consumeAchievement();
    if (ach != null) {
      setState(() => _pendingAchievement = ach);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        final player = gameProvider.player;
        if (player == null) return const SizedBox.shrink();

        final career = player.career;
        final hasDailyBadge = gameProvider.hasDailyRewardAvailable;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _checkPendingEvents(gameProvider);
        });

        final screens = [
          _HomeBody(gameProvider: gameProvider),
          const UpgradeScreen(),
          const MissionScreen(),
          const AchievementScreen(),
          const MoreScreen(),
        ];

        return Scaffold(
          backgroundColor: const Color(0xFF0E0E12),
          body: Stack(
            children: [
              RepaintBoundary(
                child: IndexedStack(
                  index: _currentIndex,
                  children: screens,
                ),
              ),
              if (_currentIndex == 0)
                Positioned.fill(
                  child: RepaintBoundary(
                    child: ParticleOverlay(color: career.color),
                  ),
                ),
              if (_levelUpValue != null)
                Positioned.fill(
                  child: LevelUpOverlay(
                    newLevel: _levelUpValue!,
                    accentColor: career.color,
                    onDismiss: () {
                      setState(() => _levelUpValue = null);
                    },
                  ),
                ),
              if (_pendingAchievement != null)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 100,
                  child: AchievementPopup(
                    achievement: _pendingAchievement!,
                    onDismiss: () {
                      setState(() => _pendingAchievement = null);
                    },
                  ),
                ),
              if (gameProvider.tutorialService.isActive)
                Positioned.fill(
                  child: TutorialOverlay(
                    tutorialService: gameProvider.tutorialService,
                    onNext: () => gameProvider.advanceTutorial(),
                    onSkip: () => gameProvider.skipTutorial(),
                  ),
                ),
            ],
          ),
          bottomNavigationBar: NavigationBar(
            backgroundColor: const Color(0xFF1A1A24),
            selectedIndex: _currentIndex,
            indicatorColor: career.color.withAlpha(40),
            onDestinationSelected: (index) {
              setState(() => _currentIndex = index);
            },
            destinations: [
              NavigationDestination(
                icon: Icon(Icons.home_outlined,
                    color: Colors.white.withAlpha(120)),
                selectedIcon: Icon(Icons.home, color: career.color),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.shopping_bag_outlined,
                    color: Colors.white.withAlpha(120)),
                selectedIcon: Icon(Icons.shopping_bag, color: career.color),
                label: 'Shop',
              ),
              NavigationDestination(
                icon: Icon(Icons.assignment_outlined,
                    color: Colors.white.withAlpha(120)),
                selectedIcon: Icon(Icons.assignment, color: career.color),
                label: 'Missions',
              ),
              NavigationDestination(
                icon: Icon(Icons.emoji_events_outlined,
                    color: Colors.white.withAlpha(120)),
                selectedIcon: Icon(Icons.emoji_events, color: career.color),
                label: 'Achieve',
              ),
              NavigationDestination(
                icon: Badge(
                  isLabelVisible: hasDailyBadge,
                  smallSize: 8,
                  child: Icon(Icons.grid_view_outlined,
                      color: Colors.white.withAlpha(120)),
                ),
                selectedIcon: Badge(
                  isLabelVisible: hasDailyBadge,
                  smallSize: 8,
                  child: Icon(Icons.grid_view, color: career.color),
                ),
                label: 'More',
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HomeBody extends StatelessWidget {
  final GameProvider gameProvider;

  const _HomeBody({required this.gameProvider});

  @override
  Widget build(BuildContext context) {
    final player = gameProvider.player!;
    final career = player.career;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E0E12),
        centerTitle: true,
        title: Semantics(
          header: true,
          child: Row(
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
        ),
        leading: Semantics(
          label: gameProvider.audioService.isSoundMuted ? 'Unmute sound' : 'Mute sound',
          button: true,
          child: IconButton(
            icon: Icon(
              gameProvider.audioService.isSoundMuted
                  ? Icons.volume_off
                  : Icons.volume_up,
              color: Colors.white.withAlpha(150),
              size: 22,
            ),
            onPressed: () {
              gameProvider.audioService.toggleSound();
              (context as Element).markNeedsBuild();
            },
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Semantics(
              label: 'Coins: ${formatNumber(player.coins)}',
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
          ),
        ],
      ),
      body: Column(
        children: [
          RepaintBoundary(child: StatsBar(player: player)),
          RepaintBoundary(child: LevelProgress(player: player, accentColor: career.color)),
          RepaintBoundary(child: BoostBar(player: player)),
          if (player.hasAutoIncome)
            Semantics(
              label: '${formatNumber(player.coinsPerSecond)} coins per second, '
                  '${formatNumber(player.viewsPerSecond)} views per second',
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.autorenew,
                      color: Color(0xFF00E676),
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${formatNumber(player.coinsPerSecond)}/s coins  ·  '
                      '${formatNumber(player.viewsPerSecond)}/s views',
                      style: const TextStyle(
                        color: Color(0xFF00E676),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (player.prestigeCount > 0)
            Semantics(
              label: '${player.prestigeMultiplier.toStringAsFixed(1)} times prestige bonus',
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.diamond, color: Color(0xFFE040FB), size: 12),
                    const SizedBox(width: 4),
                    Text(
                      '${player.prestigeMultiplier.toStringAsFixed(1)}x prestige bonus',
                      style: const TextStyle(color: Color(0xFFE040FB), fontSize: 11),
                    ),
                  ],
                ),
              ),
            ),
          const Spacer(),
          RepaintBoundary(
            child: TapButton(
              color: career.color,
              icon: career.icon,
              label: 'CREATE\nCONTENT',
              coinsPerTap: player.coinsPerTap,
              viewsPerTap: player.viewsPerTap,
              onTap: () => gameProvider.tap(),
            ),
          ),
          const SizedBox(height: 12),
          Semantics(
            label: '${formatNumber(player.coinsPerTap)} coins and ${formatNumber(player.viewsPerTap)} views per tap',
            child: Text(
              '+${formatNumber(player.coinsPerTap)} coins  ·  '
              '+${formatNumber(player.viewsPerTap)} views per tap',
              style: TextStyle(
                color: Colors.white.withAlpha(80),
                fontSize: 12,
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _OfflineRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String value;

  const _OfflineRow({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withAlpha(150),
              fontSize: 14,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
