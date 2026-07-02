import 'package:flutter/material.dart';

enum WheelRewardType { coins, xp, boost, prestigePoint, jackpot }

class WheelSegment {
  final String label;
  final IconData icon;
  final Color color;
  final WheelRewardType type;
  final double value;
  final double weight;
  final String? boostId;

  const WheelSegment({
    required this.label,
    required this.icon,
    required this.color,
    required this.type,
    required this.value,
    required this.weight,
    this.boostId,
  });
}

const allWheelSegments = <WheelSegment>[
  WheelSegment(
    label: '50 Coins',
    icon: Icons.monetization_on,
    color: Color(0xFFFFD600),
    type: WheelRewardType.coins,
    value: 50,
    weight: 25,
  ),
  WheelSegment(
    label: '200 Coins',
    icon: Icons.monetization_on,
    color: Color(0xFFFF9100),
    type: WheelRewardType.coins,
    value: 200,
    weight: 20,
  ),
  WheelSegment(
    label: '100 XP',
    icon: Icons.auto_awesome,
    color: Color(0xFF7C4DFF),
    type: WheelRewardType.xp,
    value: 100,
    weight: 18,
  ),
  WheelSegment(
    label: '500 Coins',
    icon: Icons.monetization_on,
    color: Color(0xFF00BFA5),
    type: WheelRewardType.coins,
    value: 500,
    weight: 12,
  ),
  WheelSegment(
    label: '2x Income',
    icon: Icons.bolt,
    color: Color(0xFF2979FF),
    type: WheelRewardType.boost,
    value: 300,
    weight: 10,
    boostId: 'boost_2x',
  ),
  WheelSegment(
    label: '1K Coins',
    icon: Icons.monetization_on,
    color: Color(0xFFE040FB),
    type: WheelRewardType.coins,
    value: 1000,
    weight: 8,
  ),
  WheelSegment(
    label: '1 PP',
    icon: Icons.diamond,
    color: Color(0xFFFF1744),
    type: WheelRewardType.prestigePoint,
    value: 1,
    weight: 5,
  ),
  WheelSegment(
    label: 'JACKPOT',
    icon: Icons.star,
    color: Color(0xFFFFD600),
    type: WheelRewardType.jackpot,
    value: 10000,
    weight: 2,
  ),
];
