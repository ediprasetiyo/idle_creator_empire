import 'package:flutter/material.dart';

enum AchievementType { taps, coins, views, followers, level, upgrades, income, special }

class Achievement {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final AchievementType type;
  final double coinReward;
  final double xpReward;

  const Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.type,
    this.coinReward = 0,
    this.xpReward = 0,
  });
}

const allAchievements = <Achievement>[
  // ══════ Taps (10) ══════
  Achievement(id: 'tap_1', name: 'First Step', description: 'Tap for the first time', icon: Icons.touch_app, type: AchievementType.taps, coinReward: 10, xpReward: 5),
  Achievement(id: 'tap_50', name: 'Getting Started', description: 'Tap 50 times', icon: Icons.touch_app, type: AchievementType.taps, coinReward: 50, xpReward: 20),
  Achievement(id: 'tap_100', name: 'Content Machine', description: 'Tap 100 times', icon: Icons.touch_app, type: AchievementType.taps, coinReward: 100, xpReward: 50),
  Achievement(id: 'tap_500', name: 'Dedicated Creator', description: 'Tap 500 times', icon: Icons.touch_app, type: AchievementType.taps, coinReward: 500, xpReward: 100),
  Achievement(id: 'tap_1k', name: 'Thousand Taps', description: 'Tap 1,000 times', icon: Icons.touch_app, type: AchievementType.taps, coinReward: 1000, xpReward: 200),
  Achievement(id: 'tap_5k', name: 'Tap Master', description: 'Tap 5,000 times', icon: Icons.touch_app, type: AchievementType.taps, coinReward: 5000, xpReward: 500),
  Achievement(id: 'tap_10k', name: 'Unstoppable', description: 'Tap 10,000 times', icon: Icons.touch_app, type: AchievementType.taps, coinReward: 10000, xpReward: 1000),
  Achievement(id: 'tap_50k', name: 'Finger Warrior', description: 'Tap 50,000 times', icon: Icons.touch_app, type: AchievementType.taps, coinReward: 50000, xpReward: 2000),
  Achievement(id: 'tap_100k', name: 'Tap Legend', description: 'Tap 100,000 times', icon: Icons.touch_app, type: AchievementType.taps, coinReward: 200000, xpReward: 5000),
  Achievement(id: 'tap_1m', name: 'Million Tapper', description: 'Tap 1,000,000 times', icon: Icons.touch_app, type: AchievementType.taps, coinReward: 1000000, xpReward: 10000),

  // ══════ Coins (10) ══════
  Achievement(id: 'coins_100', name: 'Pocket Change', description: 'Earn 100 total coins', icon: Icons.monetization_on, type: AchievementType.coins, coinReward: 20, xpReward: 10),
  Achievement(id: 'coins_1k', name: 'First Paycheck', description: 'Earn 1K total coins', icon: Icons.monetization_on, type: AchievementType.coins, coinReward: 100, xpReward: 30),
  Achievement(id: 'coins_10k', name: 'Money Maker', description: 'Earn 10K total coins', icon: Icons.monetization_on, type: AchievementType.coins, coinReward: 500, xpReward: 80),
  Achievement(id: 'coins_100k', name: 'Wealthy Creator', description: 'Earn 100K total coins', icon: Icons.monetization_on, type: AchievementType.coins, coinReward: 5000, xpReward: 200),
  Achievement(id: 'coins_1m', name: 'Millionaire', description: 'Earn 1M total coins', icon: Icons.monetization_on, type: AchievementType.coins, coinReward: 50000, xpReward: 500),
  Achievement(id: 'coins_10m', name: 'Multi-Millionaire', description: 'Earn 10M total coins', icon: Icons.monetization_on, type: AchievementType.coins, coinReward: 500000, xpReward: 1000),
  Achievement(id: 'coins_100m', name: 'Tycoon', description: 'Earn 100M total coins', icon: Icons.monetization_on, type: AchievementType.coins, coinReward: 5000000, xpReward: 2000),
  Achievement(id: 'coins_1b', name: 'Billionaire', description: 'Earn 1B total coins', icon: Icons.monetization_on, type: AchievementType.coins, coinReward: 50000000, xpReward: 5000),
  Achievement(id: 'coins_10b', name: 'Ultra Rich', description: 'Earn 10B total coins', icon: Icons.monetization_on, type: AchievementType.coins, coinReward: 500000000, xpReward: 10000),
  Achievement(id: 'coins_100b', name: 'Money Emperor', description: 'Earn 100B total coins', icon: Icons.monetization_on, type: AchievementType.coins, coinReward: 5000000000, xpReward: 20000),

  // ══════ Views (5) ══════
  Achievement(id: 'views_1k', name: 'First Viral', description: 'Reach 1K total views', icon: Icons.visibility, type: AchievementType.views, coinReward: 100, xpReward: 30),
  Achievement(id: 'views_100k', name: 'Trending', description: 'Reach 100K views', icon: Icons.visibility, type: AchievementType.views, coinReward: 5000, xpReward: 200),
  Achievement(id: 'views_1m', name: 'Million Views', description: 'Reach 1M views', icon: Icons.visibility, type: AchievementType.views, coinReward: 50000, xpReward: 500),
  Achievement(id: 'views_100m', name: 'Mega Viral', description: 'Reach 100M views', icon: Icons.visibility, type: AchievementType.views, coinReward: 5000000, xpReward: 2000),
  Achievement(id: 'views_1b', name: 'View Emperor', description: 'Reach 1B views', icon: Icons.visibility, type: AchievementType.views, coinReward: 50000000, xpReward: 5000),

  // ══════ Followers (5) ══════
  Achievement(id: 'fans_100', name: 'Small Community', description: 'Reach 100 followers', icon: Icons.people, type: AchievementType.followers, coinReward: 200, xpReward: 50),
  Achievement(id: 'fans_1k', name: 'Growing Fanbase', description: 'Reach 1K followers', icon: Icons.people, type: AchievementType.followers, coinReward: 2000, xpReward: 150),
  Achievement(id: 'fans_10k', name: 'Fan Favorite', description: 'Reach 10K followers', icon: Icons.people, type: AchievementType.followers, coinReward: 20000, xpReward: 500),
  Achievement(id: 'fans_100k', name: 'Famous', description: 'Reach 100K followers', icon: Icons.people, type: AchievementType.followers, coinReward: 200000, xpReward: 2000),
  Achievement(id: 'fans_1m', name: 'Fan Empire', description: 'Reach 1M followers', icon: Icons.people, type: AchievementType.followers, coinReward: 2000000, xpReward: 5000),

  // ══════ Level (5) ══════
  Achievement(id: 'level_5', name: 'Amateur', description: 'Reach level 5', icon: Icons.military_tech, type: AchievementType.level, coinReward: 200, xpReward: 50),
  Achievement(id: 'level_10', name: 'Rising Star', description: 'Reach level 10', icon: Icons.military_tech, type: AchievementType.level, coinReward: 1000, xpReward: 200),
  Achievement(id: 'level_20', name: 'Influencer', description: 'Reach level 20', icon: Icons.military_tech, type: AchievementType.level, coinReward: 10000, xpReward: 500),
  Achievement(id: 'level_30', name: 'Celebrity', description: 'Reach level 30', icon: Icons.military_tech, type: AchievementType.level, coinReward: 100000, xpReward: 2000),
  Achievement(id: 'level_50', name: 'Legend', description: 'Reach level 50', icon: Icons.military_tech, type: AchievementType.level, coinReward: 1000000, xpReward: 10000),

  // ══════ Upgrades (5) ══════
  Achievement(id: 'upgrade_1', name: 'First Upgrade', description: 'Buy your first upgrade', icon: Icons.upgrade, type: AchievementType.upgrades, coinReward: 50, xpReward: 20),
  Achievement(id: 'upgrade_5', name: 'Investor', description: 'Buy 5 total upgrades', icon: Icons.upgrade, type: AchievementType.upgrades, coinReward: 500, xpReward: 80),
  Achievement(id: 'upgrade_15', name: 'Big Spender', description: 'Buy 15 total upgrades', icon: Icons.upgrade, type: AchievementType.upgrades, coinReward: 5000, xpReward: 200),
  Achievement(id: 'upgrade_30', name: 'Fully Equipped', description: 'Buy 30 total upgrades', icon: Icons.upgrade, type: AchievementType.upgrades, coinReward: 50000, xpReward: 1000),
  Achievement(id: 'upgrade_50', name: 'Upgrade Maniac', description: 'Buy 50 total upgrades', icon: Icons.upgrade, type: AchievementType.upgrades, coinReward: 500000, xpReward: 3000),

  // ══════ Income (5) ══════
  Achievement(id: 'income_1', name: 'Passive Income', description: 'Reach 1 coin/s auto income', icon: Icons.autorenew, type: AchievementType.income, coinReward: 100, xpReward: 30),
  Achievement(id: 'income_10', name: 'Money Machine', description: 'Reach 10 coins/s', icon: Icons.autorenew, type: AchievementType.income, coinReward: 1000, xpReward: 100),
  Achievement(id: 'income_100', name: 'Cash Flow', description: 'Reach 100 coins/s', icon: Icons.autorenew, type: AchievementType.income, coinReward: 10000, xpReward: 300),
  Achievement(id: 'income_1k', name: 'Income King', description: 'Reach 1K coins/s', icon: Icons.autorenew, type: AchievementType.income, coinReward: 100000, xpReward: 1000),
  Achievement(id: 'income_10k', name: 'Income Emperor', description: 'Reach 10K coins/s', icon: Icons.autorenew, type: AchievementType.income, coinReward: 1000000, xpReward: 5000),

  // ══════ Special (5) ══════
  Achievement(id: 'rank_influencer', name: 'Influencer Status', description: 'Reach Influencer rank', icon: Icons.verified, type: AchievementType.special, coinReward: 5000, xpReward: 300),
  Achievement(id: 'rank_celebrity', name: 'Celebrity Status', description: 'Reach Celebrity rank', icon: Icons.verified, type: AchievementType.special, coinReward: 50000, xpReward: 1000),
  Achievement(id: 'rank_legend', name: 'Legendary', description: 'Reach Legend rank', icon: Icons.verified, type: AchievementType.special, coinReward: 1000000, xpReward: 10000),
  Achievement(id: 'all_categories', name: 'Diversified', description: 'Buy from every category', icon: Icons.grid_view, type: AchievementType.special, coinReward: 100000, xpReward: 2000),
  Achievement(id: 'max_upgrade', name: 'Maxed Out', description: 'Max out any upgrade', icon: Icons.emoji_events, type: AchievementType.special, coinReward: 500000, xpReward: 5000),
];

Map<String, double> get achievementThresholds => {
  'tap_1': 1, 'tap_50': 50, 'tap_100': 100, 'tap_500': 500,
  'tap_1k': 1000, 'tap_5k': 5000, 'tap_10k': 10000, 'tap_50k': 50000,
  'tap_100k': 100000, 'tap_1m': 1000000,
  'coins_100': 100, 'coins_1k': 1e3, 'coins_10k': 1e4, 'coins_100k': 1e5,
  'coins_1m': 1e6, 'coins_10m': 1e7, 'coins_100m': 1e8,
  'coins_1b': 1e9, 'coins_10b': 1e10, 'coins_100b': 1e11,
  'views_1k': 1e3, 'views_100k': 1e5, 'views_1m': 1e6,
  'views_100m': 1e8, 'views_1b': 1e9,
  'fans_100': 100, 'fans_1k': 1e3, 'fans_10k': 1e4,
  'fans_100k': 1e5, 'fans_1m': 1e6,
  'level_5': 5, 'level_10': 10, 'level_20': 20,
  'level_30': 30, 'level_50': 50,
  'upgrade_1': 1, 'upgrade_5': 5, 'upgrade_15': 15,
  'upgrade_30': 30, 'upgrade_50': 50,
  'income_1': 1, 'income_10': 10, 'income_100': 100,
  'income_1k': 1000, 'income_10k': 10000,
};
