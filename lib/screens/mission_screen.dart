import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/mission_card.dart';

class MissionScreen extends StatelessWidget {
  const MissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        final player = gameProvider.player;
        if (player == null) return const SizedBox.shrink();

        final missions = gameProvider.todayMissions;
        final career = player.career;
        final claimedCount =
            missions.asMap().entries.where((e) => gameProvider.isMissionClaimed(e.key)).length;

        return Scaffold(
          backgroundColor: const Color(0xFF0E0E12),
          appBar: AppBar(
            backgroundColor: const Color(0xFF0E0E12),
            centerTitle: true,
            title: const Text(
              'Daily Missions',
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
                        color: career.color.withAlpha(30),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.assignment,
                        color: career.color,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Today\'s Progress',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$claimedCount / ${missions.length} missions completed',
                            style: TextStyle(
                              color: Colors.white.withAlpha(120),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: claimedCount == missions.length
                            ? const Color(0xFF00E676).withAlpha(20)
                            : career.color.withAlpha(20),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        claimedCount == missions.length ? 'All Done!' : '$claimedCount/${missions.length}',
                        style: TextStyle(
                          color: claimedCount == missions.length
                              ? const Color(0xFF00E676)
                              : career.color,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 4, bottom: 20),
                  itemCount: missions.length,
                  itemBuilder: (context, index) {
                    final mission = missions[index];
                    return MissionCard(
                      mission: mission,
                      progress: gameProvider.missionProgressFraction(index),
                      isComplete: gameProvider.isMissionComplete(index),
                      isClaimed: gameProvider.isMissionClaimed(index),
                      onClaim: () => gameProvider.claimMission(index),
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
