import 'package:flutter/material.dart';

class PrestigeUpgrade {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final int maxLevel;
  final List<int> costs;

  const PrestigeUpgrade({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.maxLevel,
    required this.costs,
  });

  int costForLevel(int currentLevel) {
    if (currentLevel >= maxLevel) return 0;
    return currentLevel < costs.length ? costs[currentLevel] : 999;
  }
}

const allPrestigeUpgrades = <PrestigeUpgrade>[
  PrestigeUpgrade(
    id: 'golden_touch',
    name: 'Golden Touch',
    description: '+10% tap income per level',
    icon: Icons.touch_app,
    color: Color(0xFFFFD600),
    maxLevel: 10,
    costs: [1, 1, 2, 2, 3, 3, 4, 5, 6, 8],
  ),
  PrestigeUpgrade(
    id: 'empire_builder',
    name: 'Empire Builder',
    description: '+15% auto income per level',
    icon: Icons.autorenew,
    color: Color(0xFF00E676),
    maxLevel: 10,
    costs: [2, 2, 3, 3, 4, 4, 5, 6, 8, 10],
  ),
  PrestigeUpgrade(
    id: 'xp_master',
    name: 'XP Master',
    description: '+20% XP gain per level',
    icon: Icons.auto_awesome,
    color: Color(0xFF7C4DFF),
    maxLevel: 5,
    costs: [3, 4, 5, 7, 10],
  ),
  PrestigeUpgrade(
    id: 'head_start',
    name: 'Head Start',
    description: 'Start with coins after prestige',
    icon: Icons.rocket_launch,
    color: Color(0xFFFF9100),
    maxLevel: 5,
    costs: [2, 3, 5, 8, 12],
  ),
  PrestigeUpgrade(
    id: 'lucky_star',
    name: 'Lucky Star',
    description: 'Reduce wheel cooldown by 1h per level',
    icon: Icons.star,
    color: Color(0xFFE040FB),
    maxLevel: 3,
    costs: [5, 10, 15],
  ),
];

const headStartAmounts = [0.0, 1000.0, 5000.0, 25000.0, 100000.0, 500000.0];
