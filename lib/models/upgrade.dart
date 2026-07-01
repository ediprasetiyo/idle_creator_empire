import 'package:flutter/material.dart';
import 'career.dart';

enum UpgradeType {
  betterGear,
  lighting,
  studioDecor,
  contentSchedule,
  socialBot,
  fanCommunity,
}

class Upgrade {
  final UpgradeType type;
  final String name;
  final String description;
  final IconData icon;
  final double baseCost;
  final double costMultiplier;
  final double tapCoinBonus;
  final double tapViewBonus;
  final double autoCoinsPerSec;
  final double autoViewsPerSec;
  final double autoFollowersPerSec;

  const Upgrade({
    required this.type,
    required this.name,
    required this.description,
    required this.icon,
    required this.baseCost,
    this.costMultiplier = 1.5,
    this.tapCoinBonus = 0,
    this.tapViewBonus = 0,
    this.autoCoinsPerSec = 0,
    this.autoViewsPerSec = 0,
    this.autoFollowersPerSec = 0,
  });

  double costForLevel(int level) {
    return baseCost * _pow(costMultiplier, level);
  }

  static double _pow(double base, int exp) {
    double result = 1.0;
    for (int i = 0; i < exp; i++) {
      result *= base;
    }
    return result;
  }
}

List<Upgrade> getUpgradesForCareer(Career career) {
  final gearName = switch (career) {
    Career.gaming => 'Gaming Controller',
    Career.horror => 'Scary Mask',
    Career.food => 'Chef Knife',
    Career.travel => 'Travel Camera',
    Career.comedy => 'Comedy Mic',
    Career.technology => 'Dev Laptop',
    Career.education => 'Whiteboard',
    Career.music => 'Instrument',
  };

  return [
    Upgrade(
      type: UpgradeType.betterGear,
      name: gearName,
      description: '+1 coin per tap',
      icon: Icons.build,
      baseCost: 15,
      costMultiplier: 1.4,
      tapCoinBonus: 1.0,
    ),
    Upgrade(
      type: UpgradeType.lighting,
      name: 'Ring Light',
      description: '+5 views per tap',
      icon: Icons.light,
      baseCost: 30,
      costMultiplier: 1.5,
      tapViewBonus: 5.0,
    ),
    Upgrade(
      type: UpgradeType.studioDecor,
      name: 'Studio Decor',
      description: '+2 coins & +8 views per tap',
      icon: Icons.chair,
      baseCost: 120,
      costMultiplier: 1.6,
      tapCoinBonus: 2.0,
      tapViewBonus: 8.0,
    ),
    Upgrade(
      type: UpgradeType.contentSchedule,
      name: 'Content Schedule',
      description: '+0.5 coins/sec auto',
      icon: Icons.schedule,
      baseCost: 75,
      costMultiplier: 1.8,
      autoCoinsPerSec: 0.5,
    ),
    Upgrade(
      type: UpgradeType.socialBot,
      name: 'Social Media Bot',
      description: '+2 views/sec auto',
      icon: Icons.smart_toy,
      baseCost: 100,
      costMultiplier: 1.8,
      autoViewsPerSec: 2.0,
    ),
    Upgrade(
      type: UpgradeType.fanCommunity,
      name: 'Fan Community',
      description: '+0.1 followers/sec auto',
      icon: Icons.groups,
      baseCost: 200,
      costMultiplier: 1.9,
      autoFollowersPerSec: 0.1,
    ),
  ];
}
