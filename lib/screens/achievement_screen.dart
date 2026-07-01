import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/achievement.dart';
import '../providers/game_provider.dart';
import '../utils/formatters.dart';

class AchievementScreen extends StatelessWidget {
  const AchievementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        final player = gameProvider.player;
        if (player == null) return const SizedBox.shrink();

        final career = player.career;
        final completed = player.completedAchievements;
        final total = allAchievements.length;
        final doneCount = completed.length;

        return Scaffold(
          backgroundColor: const Color(0xFF0E0E12),
          appBar: AppBar(
            backgroundColor: const Color(0xFF0E0E12),
            centerTitle: true,
            title: const Text(
              'Achievements',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A24),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD600).withAlpha(30),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.emoji_events,
                        color: Color(0xFFFFD600),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$doneCount / $total Unlocked',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: total > 0 ? doneCount / total : 0,
                              minHeight: 6,
                              backgroundColor: Colors.white.withAlpha(15),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                career.color,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 4, 12, 20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.35,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: total,
                  itemBuilder: (context, index) {
                    final a = allAchievements[index];
                    final unlocked = completed.contains(a.id);
                    return _AchievementTile(
                      achievement: a,
                      unlocked: unlocked,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AchievementTile extends StatelessWidget {
  final Achievement achievement;
  final bool unlocked;

  const _AchievementTile({
    required this.achievement,
    required this.unlocked,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A24),
        borderRadius: BorderRadius.circular(14),
        border: unlocked
            ? Border.all(
                color: const Color(0xFFFFD600).withAlpha(50),
                width: 1,
              )
            : null,
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: unlocked
                      ? const Color(0xFFFFD600).withAlpha(25)
                      : Colors.white.withAlpha(10),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  unlocked ? achievement.icon : Icons.lock_outline,
                  color: unlocked
                      ? const Color(0xFFFFD600)
                      : Colors.white.withAlpha(40),
                  size: 18,
                ),
              ),
              const Spacer(),
              if (unlocked)
                const Icon(
                  Icons.check_circle,
                  color: Color(0xFF00E676),
                  size: 18,
                ),
            ],
          ),
          const Spacer(),
          Text(
            unlocked ? achievement.name : '???',
            style: TextStyle(
              color: unlocked ? Colors.white : Colors.white.withAlpha(50),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            unlocked ? achievement.description : 'Keep playing to unlock',
            style: TextStyle(
              color: unlocked
                  ? Colors.white.withAlpha(100)
                  : Colors.white.withAlpha(30),
              fontSize: 11,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (unlocked) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                if (achievement.coinReward > 0) ...[
                  Icon(
                    Icons.monetization_on,
                    size: 10,
                    color: const Color(0xFFFFD600).withAlpha(150),
                  ),
                  const SizedBox(width: 2),
                  Text(
                    formatNumber(achievement.coinReward),
                    style: TextStyle(
                      color: const Color(0xFFFFD600).withAlpha(150),
                      fontSize: 10,
                    ),
                  ),
                ],
                if (achievement.coinReward > 0 && achievement.xpReward > 0)
                  const SizedBox(width: 6),
                if (achievement.xpReward > 0) ...[
                  Icon(
                    Icons.auto_awesome,
                    size: 10,
                    color: const Color(0xFF7C4DFF).withAlpha(150),
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '${formatNumber(achievement.xpReward)} XP',
                    style: TextStyle(
                      color: const Color(0xFF7C4DFF).withAlpha(150),
                      fontSize: 10,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}
