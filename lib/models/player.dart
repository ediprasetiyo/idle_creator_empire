import 'career.dart';
import 'upgrade.dart';

class Player {
  Career career;
  double coins;
  double views;
  double followers;
  double xp;
  int level;
  Map<UpgradeType, int> upgradeLevels;

  Player({
    required this.career,
    this.coins = 0,
    this.views = 0,
    this.followers = 0,
    this.xp = 0,
    this.level = 1,
    Map<UpgradeType, int>? upgradeLevels,
  }) : upgradeLevels = upgradeLevels ??
            {for (final t in UpgradeType.values) t: 0};

  double get xpToNextLevel => 100.0 * level * 1.5;

  double get xpProgress => (xp / xpToNextLevel).clamp(0.0, 1.0);

  int upgradeLevel(UpgradeType type) => upgradeLevels[type] ?? 0;

  double get coinsPerTap {
    double base = 1.0 + (level * 0.5);
    final upgrades = getUpgradesForCareer(career);
    for (final u in upgrades) {
      base += u.tapCoinBonus * upgradeLevel(u.type);
    }
    return base;
  }

  double get viewsPerTap {
    double base = 5.0 + (level * 2.0);
    final upgrades = getUpgradesForCareer(career);
    for (final u in upgrades) {
      base += u.tapViewBonus * upgradeLevel(u.type);
    }
    return base;
  }

  double get followersPerTap => 0.2 + (level * 0.1);

  double get xpPerTap => 10.0 + (level * 1.0);

  double get coinsPerSecond {
    double total = 0;
    final upgrades = getUpgradesForCareer(career);
    for (final u in upgrades) {
      total += u.autoCoinsPerSec * upgradeLevel(u.type);
    }
    return total;
  }

  double get viewsPerSecond {
    double total = 0;
    final upgrades = getUpgradesForCareer(career);
    for (final u in upgrades) {
      total += u.autoViewsPerSec * upgradeLevel(u.type);
    }
    return total;
  }

  double get followersPerSecond {
    double total = 0;
    final upgrades = getUpgradesForCareer(career);
    for (final u in upgrades) {
      total += u.autoFollowersPerSec * upgradeLevel(u.type);
    }
    return total;
  }

  bool get hasAutoIncome =>
      coinsPerSecond > 0 || viewsPerSecond > 0 || followersPerSecond > 0;

  String get title {
    if (level >= 50) return 'Legend';
    if (level >= 40) return 'Superstar';
    if (level >= 30) return 'Celebrity';
    if (level >= 20) return 'Influencer';
    if (level >= 15) return 'Creator';
    if (level >= 10) return 'Rising Star';
    if (level >= 5) return 'Amateur';
    return 'Beginner';
  }
}
