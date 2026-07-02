import 'package:flutter/material.dart';

class BoostDef {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final int durationSeconds;

  const BoostDef({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.durationSeconds,
  });
}

const allBoosts = <BoostDef>[
  BoostDef(
    id: 'boost_2x',
    name: '2x Income',
    description: 'Double all income for 15 minutes',
    icon: Icons.bolt,
    color: Color(0xFFFFD600),
    durationSeconds: 900,
  ),
  BoostDef(
    id: 'boost_5x',
    name: '5x Income',
    description: '5x all income for 5 minutes',
    icon: Icons.local_fire_department,
    color: Color(0xFFFF1744),
    durationSeconds: 300,
  ),
  BoostDef(
    id: 'boost_auto_tap',
    name: 'Auto Tap',
    description: 'Automatically tap once per second for 10 minutes',
    icon: Icons.touch_app,
    color: Color(0xFF2979FF),
    durationSeconds: 600,
  ),
  BoostDef(
    id: 'boost_xp',
    name: 'XP Boost',
    description: 'Double XP gain for 10 minutes',
    icon: Icons.auto_awesome,
    color: Color(0xFF7C4DFF),
    durationSeconds: 600,
  ),
];

BoostDef? getBoostById(String id) {
  for (final b in allBoosts) {
    if (b.id == id) return b;
  }
  return null;
}
