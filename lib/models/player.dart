import 'career.dart';
import 'upgrade.dart';

const ranks = [
  'Newbie', 'Small Creator', 'Growing Creator', 'Influencer',
  'Professional', 'Verified', 'Celebrity', 'Superstar',
  'Global Icon', 'Legend',
];

class Player {
  Career career;
  double coins;
  double views;
  double followers;
  double xp;
  int level;
  Map<String, int> upgradeLevels;
  Set<String> completedAchievements;
  int totalTaps;
  double totalCoinsEarned;
  double totalViewsEarned;
  int totalUpgradesBought;
  String missionDay;
  List<double> missionProgress;
  Set<int> completedMissions;
  int onlineSeconds;

  Player({
    required this.career,
    this.coins = 0,
    this.views = 0,
    this.followers = 0,
    this.xp = 0,
    this.level = 1,
    Map<String, int>? upgradeLevels,
    Set<String>? completedAchievements,
    this.totalTaps = 0,
    this.totalCoinsEarned = 0,
    this.totalViewsEarned = 0,
    this.totalUpgradesBought = 0,
    this.missionDay = '',
    List<double>? missionProgress,
    Set<int>? completedMissions,
    this.onlineSeconds = 0,
  })  : upgradeLevels = upgradeLevels ?? {},
        completedAchievements = completedAchievements ?? {},
        missionProgress = missionProgress ?? List.filled(5, 0),
        completedMissions = completedMissions ?? {};

  double get xpToNextLevel => 100.0 * level * 1.5;
  double get xpProgress => (xp / xpToNextLevel).clamp(0.0, 1.0);

  int getUpgradeLevel(String id) => upgradeLevels[id] ?? 0;

  double get coinsPerTap {
    double base = 1.0 + (level * 0.5);
    for (final u in allUpgrades) {
      base += u.tapCoin * getUpgradeLevel(u.id);
    }
    return base;
  }

  double get viewsPerTap {
    double base = 5.0 + (level * 2.0);
    for (final u in allUpgrades) {
      base += u.tapView * getUpgradeLevel(u.id);
    }
    return base;
  }

  double get followersPerTap {
    double base = 0.2 + (level * 0.1);
    for (final u in allUpgrades) {
      base += u.tapFollower * getUpgradeLevel(u.id);
    }
    return base;
  }

  double get xpPerTap => 10.0 + (level * 1.0);

  double get coinsPerSecond {
    double total = 0;
    for (final u in allUpgrades) {
      total += u.autoCoin * getUpgradeLevel(u.id);
    }
    return total;
  }

  double get viewsPerSecond {
    double total = 0;
    for (final u in allUpgrades) {
      total += u.autoView * getUpgradeLevel(u.id);
    }
    return total;
  }

  double get followersPerSecond {
    double total = 0;
    for (final u in allUpgrades) {
      total += u.autoFollower * getUpgradeLevel(u.id);
    }
    return total;
  }

  bool get hasAutoIncome =>
      coinsPerSecond > 0 || viewsPerSecond > 0 || followersPerSecond > 0;

  int get rankIndex {
    if (level >= 50) return 9;
    if (level >= 40) return 8;
    if (level >= 35) return 7;
    if (level >= 30) return 6;
    if (level >= 25) return 5;
    if (level >= 20) return 4;
    if (level >= 15) return 3;
    if (level >= 10) return 2;
    if (level >= 5) return 1;
    return 0;
  }

  String get rank => ranks[rankIndex];

  bool hasUpgradeFromCategory(UpgradeCategory cat) {
    for (final u in allUpgrades) {
      if (u.category == cat && getUpgradeLevel(u.id) > 0) return true;
    }
    return false;
  }

  bool get hasAllCategories {
    for (final cat in UpgradeCategory.values) {
      if (!hasUpgradeFromCategory(cat)) return false;
    }
    return true;
  }

  bool get hasMaxedUpgrade {
    for (final u in allUpgrades) {
      if (getUpgradeLevel(u.id) >= u.maxLevel) return true;
    }
    return false;
  }
}
