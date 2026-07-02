import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/daily_reward.dart';
import '../providers/game_provider.dart';
import '../utils/formatters.dart';

class DailyRewardScreen extends StatelessWidget {
  const DailyRewardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gp, _) {
        final player = gp.player;
        if (player == null) return const SizedBox.shrink();

        final streak = player.dailyLoginStreak;
        final canClaim = gp.hasDailyRewardAvailable;
        final nextDay = canClaim ? (streak < 30 ? streak + 1 : 1) : streak;
        final career = player.career;

        return Scaffold(
          backgroundColor: const Color(0xFF0E0E12),
          appBar: AppBar(
            backgroundColor: const Color(0xFF0E0E12),
            title: const Text(
              'Daily Rewards',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            iconTheme: IconThemeData(color: Colors.white.withAlpha(200)),
          ),
          body: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A24),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: career.color.withAlpha(40)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.local_fire_department, color: const Color(0xFFFF9100), size: 28),
                    const SizedBox(width: 8),
                    Text(
                      'Streak: $streak day${streak == 1 ? '' : 's'}',
                      style: const TextStyle(
                        color: Color(0xFFFF9100),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 6,
                    mainAxisSpacing: 6,
                  ),
                  itemCount: 30,
                  itemBuilder: (context, index) {
                    final day = index + 1;
                    final reward = allDailyRewards[index];
                    final isCollected = day <= streak && !canClaim;
                    final isCollectedPast = day < (canClaim ? nextDay : streak + 1) && day <= streak;
                    final isToday = day == nextDay && canClaim;
                    final isFuture = !isCollectedPast && !isToday;

                    return _DayCell(
                      reward: reward,
                      isCollected: isCollectedPast,
                      isToday: isToday,
                      isFuture: isFuture,
                      accentColor: career.color,
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    onPressed: canClaim
                        ? () {
                            gp.claimDailyReward();
                            _showClaimedDialog(context, allDailyRewards[nextDay - 1], career.color);
                          }
                        : null,
                    style: FilledButton.styleFrom(
                      backgroundColor: career.color,
                      disabledBackgroundColor: const Color(0xFF1A1A24),
                      disabledForegroundColor: Colors.white.withAlpha(60),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text(
                      canClaim ? 'Claim Day $nextDay Reward!' : 'Already Claimed Today',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showClaimedDialog(BuildContext context, DailyReward reward, Color color) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Column(
          children: [
            Icon(reward.icon, color: reward.color, size: 40),
            const SizedBox(height: 8),
            Text(
              'Day ${reward.day} Reward!',
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (reward.coins > 0)
              _RewardRow(icon: Icons.monetization_on, color: const Color(0xFFFFD600), text: '+${formatNumber(reward.coins)} Coins'),
            if (reward.hasXp)
              _RewardRow(icon: Icons.auto_awesome, color: const Color(0xFF7C4DFF), text: '+${formatNumber(reward.xp)} XP'),
            if (reward.hasPrestigePoints)
              _RewardRow(icon: Icons.diamond, color: const Color(0xFFE040FB), text: '+${reward.prestigePoints} Prestige Points'),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => Navigator.of(ctx).pop(),
              style: FilledButton.styleFrom(
                backgroundColor: color,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Awesome!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}

class _RewardRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;

  const _RewardRow({required this.icon, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Text(text, style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  final DailyReward reward;
  final bool isCollected;
  final bool isToday;
  final bool isFuture;
  final Color accentColor;

  const _DayCell({
    required this.reward,
    required this.isCollected,
    required this.isToday,
    required this.isFuture,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isCollected
        ? const Color(0xFF00E676).withAlpha(20)
        : isToday
            ? accentColor.withAlpha(30)
            : const Color(0xFF1A1A24);

    final borderColor = isToday
        ? accentColor
        : isCollected
            ? const Color(0xFF00E676).withAlpha(60)
            : Colors.white.withAlpha(10);

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor, width: isToday ? 2 : 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Day ${reward.day}',
            style: TextStyle(
              color: isCollected
                  ? const Color(0xFF00E676)
                  : isToday
                      ? accentColor
                      : Colors.white.withAlpha(isFuture ? 60 : 200),
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          isCollected
              ? const Icon(Icons.check_circle, color: Color(0xFF00E676), size: 18)
              : Icon(
                  reward.icon,
                  color: isToday
                      ? reward.color
                      : reward.color.withAlpha(isFuture ? 60 : 200),
                  size: 18,
                ),
          const SizedBox(height: 2),
          Text(
            reward.coins > 0 ? formatNumber(reward.coins) : '',
            style: TextStyle(
              color: isToday ? Colors.white : Colors.white.withAlpha(isFuture ? 40 : 120),
              fontSize: 8,
            ),
          ),
        ],
      ),
    );
  }
}
