import 'package:flutter/material.dart';

enum MissionType {
  tapCount(label: 'Tap', icon: Icons.touch_app, color: Color(0xFF2979FF)),
  earnCoins(label: 'Earn', icon: Icons.monetization_on, color: Color(0xFFFFD600)),
  buyUpgrades(label: 'Buy', icon: Icons.upgrade, color: Color(0xFF00BFA5)),
  reachLevel(label: 'Level', icon: Icons.military_tech, color: Color(0xFFE040FB)),
  onlineMinutes(label: 'Online', icon: Icons.timer, color: Color(0xFFFF9100));

  const MissionType({required this.label, required this.icon, required this.color});
  final String label;
  final IconData icon;
  final Color color;
}

class Mission {
  final MissionType type;
  final String name;
  final double target;
  final double coinReward;
  final double xpReward;

  const Mission({
    required this.type,
    required this.name,
    required this.target,
    required this.coinReward,
    required this.xpReward,
  });
}

List<Mission> generateDailyMissions(int playerLevel) {
  final lv = playerLevel;
  return [
    Mission(
      type: MissionType.tapCount,
      name: 'Tap ${20 + lv * 8} times',
      target: (20 + lv * 8).toDouble(),
      coinReward: (50 + lv * 15).toDouble(),
      xpReward: (20 + lv * 5).toDouble(),
    ),
    Mission(
      type: MissionType.earnCoins,
      name: 'Earn ${_missionCoinTarget(lv)} coins',
      target: _missionCoinTargetRaw(lv),
      coinReward: (80 + lv * 25).toDouble(),
      xpReward: (30 + lv * 8).toDouble(),
    ),
    Mission(
      type: MissionType.buyUpgrades,
      name: 'Buy ${1 + lv ~/ 8} upgrades',
      target: (1 + lv ~/ 8).toDouble(),
      coinReward: (100 + lv * 30).toDouble(),
      xpReward: (40 + lv * 10).toDouble(),
    ),
    Mission(
      type: MissionType.reachLevel,
      name: 'Reach level ${lv + 1}',
      target: (lv + 1).toDouble(),
      coinReward: (200 + lv * 50).toDouble(),
      xpReward: (50 + lv * 15).toDouble(),
    ),
    Mission(
      type: MissionType.onlineMinutes,
      name: 'Play for ${3 + lv ~/ 3} minutes',
      target: (3 + lv ~/ 3).toDouble(),
      coinReward: (60 + lv * 20).toDouble(),
      xpReward: (25 + lv * 6).toDouble(),
    ),
  ];
}

String _missionCoinTarget(int lv) {
  final raw = _missionCoinTargetRaw(lv);
  if (raw >= 1e6) return '${(raw / 1e6).toStringAsFixed(0)}M';
  if (raw >= 1e3) return '${(raw / 1e3).toStringAsFixed(0)}K';
  return raw.toStringAsFixed(0);
}

double _missionCoinTargetRaw(int lv) {
  if (lv <= 5) return (100 + lv * 50).toDouble();
  if (lv <= 15) return (500 + lv * 200).toDouble();
  if (lv <= 30) return (5000 + lv * 1000).toDouble();
  return (50000 + lv * 5000).toDouble();
}
