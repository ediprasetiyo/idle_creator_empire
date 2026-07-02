import 'package:flutter/material.dart';

class DailyReward {
  final int day;
  final double coins;
  final double xp;
  final int prestigePoints;

  const DailyReward({
    required this.day,
    this.coins = 0,
    this.xp = 0,
    this.prestigePoints = 0,
  });

  bool get hasPrestigePoints => prestigePoints > 0;
  bool get hasXp => xp > 0;

  IconData get icon {
    if (hasPrestigePoints) return Icons.diamond;
    if (hasXp) return Icons.auto_awesome;
    return Icons.monetization_on;
  }

  Color get color {
    if (hasPrestigePoints) return const Color(0xFFE040FB);
    if (hasXp) return const Color(0xFF7C4DFF);
    return const Color(0xFFFFD600);
  }
}

const allDailyRewards = <DailyReward>[
  DailyReward(day: 1, coins: 100),
  DailyReward(day: 2, coins: 200),
  DailyReward(day: 3, coins: 300, xp: 50),
  DailyReward(day: 4, coins: 500),
  DailyReward(day: 5, coins: 1000, xp: 100),
  DailyReward(day: 6, coins: 1500),
  DailyReward(day: 7, coins: 3000, xp: 200, prestigePoints: 1),
  DailyReward(day: 8, coins: 2000),
  DailyReward(day: 9, coins: 2500, xp: 150),
  DailyReward(day: 10, coins: 5000, xp: 300),
  DailyReward(day: 11, coins: 3000),
  DailyReward(day: 12, coins: 3500, xp: 200),
  DailyReward(day: 13, coins: 4000),
  DailyReward(day: 14, coins: 8000, xp: 500, prestigePoints: 2),
  DailyReward(day: 15, coins: 5000),
  DailyReward(day: 16, coins: 6000, xp: 300),
  DailyReward(day: 17, coins: 7000),
  DailyReward(day: 18, coins: 8000, xp: 400),
  DailyReward(day: 19, coins: 9000),
  DailyReward(day: 20, coins: 15000, xp: 600),
  DailyReward(day: 21, coins: 10000, prestigePoints: 3),
  DailyReward(day: 22, coins: 12000, xp: 500),
  DailyReward(day: 23, coins: 14000),
  DailyReward(day: 24, coins: 16000, xp: 700),
  DailyReward(day: 25, coins: 20000),
  DailyReward(day: 26, coins: 25000, xp: 800),
  DailyReward(day: 27, coins: 30000),
  DailyReward(day: 28, coins: 40000, xp: 1000, prestigePoints: 5),
  DailyReward(day: 29, coins: 50000, xp: 1500),
  DailyReward(day: 30, coins: 100000, xp: 3000, prestigePoints: 10),
];
