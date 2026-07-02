import 'dart:math' as math;
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

  int prestigeCount;
  int prestigePoints;
  int totalPrestigePoints;
  Map<String, int> prestigeUpgrades;
  int dailyLoginStreak;
  String lastClaimDate;
  Map<String, int> boostEndTimes;
  double lifetimeCoinsEarned;
  double lifetimeViewsEarned;
  int totalOnlineSeconds;
  double highestCoinPerSecond;
  int totalWheelSpins;
  int lastWheelSpin;

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
    this.prestigeCount = 0,
    this.prestigePoints = 0,
    this.totalPrestigePoints = 0,
    Map<String, int>? prestigeUpgrades,
    this.dailyLoginStreak = 0,
    this.lastClaimDate = '',
    Map<String, int>? boostEndTimes,
    this.lifetimeCoinsEarned = 0,
    this.lifetimeViewsEarned = 0,
    this.totalOnlineSeconds = 0,
    this.highestCoinPerSecond = 0,
    this.totalWheelSpins = 0,
    this.lastWheelSpin = 0,
  })  : upgradeLevels = upgradeLevels ?? {},
        completedAchievements = completedAchievements ?? {},
        missionProgress = missionProgress ?? List.filled(5, 0),
        completedMissions = completedMissions ?? {},
        prestigeUpgrades = prestigeUpgrades ?? {},
        boostEndTimes = boostEndTimes ?? {};

  double get xpToNextLevel => 100.0 * level * 1.5;
  double get xpProgress => (xp / xpToNextLevel).clamp(0.0, 1.0);

  int getUpgradeLevel(String id) => upgradeLevels[id] ?? 0;
  int getPrestigeUpgradeLevel(String id) => prestigeUpgrades[id] ?? 0;

  double get prestigeMultiplier => 1.0 + (prestigeCount * 0.1);

  double get tapCoinMultiplier {
    final lv = getPrestigeUpgradeLevel('golden_touch');
    return prestigeMultiplier * (1.0 + lv * 0.1);
  }

  double get autoIncomeMultiplier {
    final lv = getPrestigeUpgradeLevel('empire_builder');
    return prestigeMultiplier * (1.0 + lv * 0.15);
  }

  double get xpGainMultiplier {
    final lv = getPrestigeUpgradeLevel('xp_master');
    return 1.0 + lv * 0.2;
  }

  double get incomeBoostMultiplier {
    final now = DateTime.now().millisecondsSinceEpoch;
    if ((boostEndTimes['boost_5x'] ?? 0) > now) return 5.0;
    if ((boostEndTimes['boost_2x'] ?? 0) > now) return 2.0;
    return 1.0;
  }

  double get xpBoostMultiplier {
    final now = DateTime.now().millisecondsSinceEpoch;
    if ((boostEndTimes['boost_xp'] ?? 0) > now) return 2.0;
    return 1.0;
  }

  bool get hasAutoTap {
    final now = DateTime.now().millisecondsSinceEpoch;
    return (boostEndTimes['boost_auto_tap'] ?? 0) > now;
  }

  int get wheelCooldownMs {
    final lv = getPrestigeUpgradeLevel('lucky_star');
    return (4 - lv) * 3600 * 1000;
  }

  bool get canSpinWheel {
    if (lastWheelSpin == 0) return true;
    final now = DateTime.now().millisecondsSinceEpoch;
    return now - lastWheelSpin >= wheelCooldownMs;
  }

  int get wheelCooldownRemaining {
    if (canSpinWheel) return 0;
    final now = DateTime.now().millisecondsSinceEpoch;
    return (lastWheelSpin + wheelCooldownMs - now).clamp(0, wheelCooldownMs);
  }

  int get potentialPrestigePoints {
    return math.sqrt(totalCoinsEarned / 1000).floor();
  }

  List<String> get activeBoostIds {
    final now = DateTime.now().millisecondsSinceEpoch;
    return boostEndTimes.entries
        .where((e) => e.value > now)
        .map((e) => e.key)
        .toList();
  }

  int boostRemainingMs(String id) {
    final end = boostEndTimes[id] ?? 0;
    final now = DateTime.now().millisecondsSinceEpoch;
    return (end - now).clamp(0, 999999999);
  }

  double get coinsPerTap {
    double base = 1.0 + (level * 0.5);
    for (final u in allUpgrades) {
      base += u.tapCoin * getUpgradeLevel(u.id);
    }
    return base * tapCoinMultiplier * incomeBoostMultiplier;
  }

  double get viewsPerTap {
    double base = 5.0 + (level * 2.0);
    for (final u in allUpgrades) {
      base += u.tapView * getUpgradeLevel(u.id);
    }
    return base * tapCoinMultiplier * incomeBoostMultiplier;
  }

  double get followersPerTap {
    double base = 0.2 + (level * 0.1);
    for (final u in allUpgrades) {
      base += u.tapFollower * getUpgradeLevel(u.id);
    }
    return base * tapCoinMultiplier * incomeBoostMultiplier;
  }

  double get xpPerTap =>
      (10.0 + (level * 1.0)) * xpGainMultiplier * xpBoostMultiplier;

  double get coinsPerSecond {
    double total = 0;
    for (final u in allUpgrades) {
      total += u.autoCoin * getUpgradeLevel(u.id);
    }
    return total * autoIncomeMultiplier * incomeBoostMultiplier;
  }

  double get viewsPerSecond {
    double total = 0;
    for (final u in allUpgrades) {
      total += u.autoView * getUpgradeLevel(u.id);
    }
    return total * autoIncomeMultiplier * incomeBoostMultiplier;
  }

  double get followersPerSecond {
    double total = 0;
    for (final u in allUpgrades) {
      total += u.autoFollower * getUpgradeLevel(u.id);
    }
    return total * autoIncomeMultiplier * incomeBoostMultiplier;
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
