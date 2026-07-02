import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/boost.dart';
import '../models/career.dart';
import '../models/player.dart';
import '../models/prestige.dart';
import '../models/upgrade.dart';
import '../utils/constants.dart';

class SaveService {
  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  bool get hasCareer => _prefs.containsKey(GameConstants.keyCareer);

  Future<void> saveCareer(Career career) async {
    await _prefs.setString(GameConstants.keyCareer, career.name);
  }

  Career? loadCareer() {
    final name = _prefs.getString(GameConstants.keyCareer);
    if (name == null) return null;
    return Career.values.firstWhere(
      (c) => c.name == name,
      orElse: () => Career.gaming,
    );
  }

  Future<void> savePlayer(Player player) async {
    final futures = <Future>[
      _prefs.setString(GameConstants.keyCareer, player.career.name),
      _prefs.setDouble(GameConstants.keyCoins, player.coins),
      _prefs.setDouble(GameConstants.keyViews, player.views),
      _prefs.setDouble(GameConstants.keyFollowers, player.followers),
      _prefs.setDouble(GameConstants.keyXp, player.xp),
      _prefs.setInt(GameConstants.keyLevel, player.level),
      _prefs.setInt(GameConstants.keyLastSave, DateTime.now().millisecondsSinceEpoch),
      _prefs.setInt(GameConstants.keyTotalTaps, player.totalTaps),
      _prefs.setDouble(GameConstants.keyTotalCoins, player.totalCoinsEarned),
      _prefs.setDouble(GameConstants.keyTotalViews, player.totalViewsEarned),
      _prefs.setInt(GameConstants.keyTotalUpgrades, player.totalUpgradesBought),
      _prefs.setStringList(GameConstants.keyAchievements, player.completedAchievements.toList()),
      _prefs.setString(GameConstants.keyMissionDay, player.missionDay),
      _prefs.setInt(GameConstants.keyOnlineSeconds, player.onlineSeconds),
      _prefs.setInt(GameConstants.keyPrestigeCount, player.prestigeCount),
      _prefs.setInt(GameConstants.keyPrestigePoints, player.prestigePoints),
      _prefs.setInt(GameConstants.keyTotalPrestigePoints, player.totalPrestigePoints),
      _prefs.setInt(GameConstants.keyDailyLoginStreak, player.dailyLoginStreak),
      _prefs.setString(GameConstants.keyLastClaimDate, player.lastClaimDate),
      _prefs.setDouble(GameConstants.keyLifetimeCoins, player.lifetimeCoinsEarned),
      _prefs.setDouble(GameConstants.keyLifetimeViews, player.lifetimeViewsEarned),
      _prefs.setInt(GameConstants.keyTotalOnlineSeconds, player.totalOnlineSeconds),
      _prefs.setDouble(GameConstants.keyHighestCps, player.highestCoinPerSecond),
      _prefs.setInt(GameConstants.keyTotalWheelSpins, player.totalWheelSpins),
      _prefs.setInt(GameConstants.keyLastWheelSpin, player.lastWheelSpin),
    ];

    for (final u in allUpgrades) {
      final lv = player.getUpgradeLevel(u.id);
      futures.add(_prefs.setInt('${GameConstants.keyUpgradePrefix}${u.id}', lv));
    }

    for (final pu in allPrestigeUpgrades) {
      final lv = player.getPrestigeUpgradeLevel(pu.id);
      futures.add(_prefs.setInt('${GameConstants.keyPrestigeUpgradePrefix}${pu.id}', lv));
    }

    for (final b in allBoosts) {
      futures.add(_prefs.setInt(
        '${GameConstants.keyBoostEndPrefix}${b.id}',
        player.boostEndTimes[b.id] ?? 0,
      ));
    }

    for (int i = 0; i < 5; i++) {
      futures.add(_prefs.setDouble(
        '${GameConstants.keyMissionProgressPrefix}$i',
        i < player.missionProgress.length ? player.missionProgress[i] : 0,
      ));
      futures.add(_prefs.setBool(
        '${GameConstants.keyMissionCompletePrefix}$i',
        player.completedMissions.contains(i),
      ));
    }

    await Future.wait(futures);
  }

  Player? loadPlayer() {
    final career = loadCareer();
    if (career == null) return null;

    final upgradeLevels = <String, int>{};
    for (final u in allUpgrades) {
      final lv = _prefs.getInt('${GameConstants.keyUpgradePrefix}${u.id}') ?? 0;
      if (lv > 0) upgradeLevels[u.id] = lv;
    }

    final prestigeUpgradesMap = <String, int>{};
    for (final pu in allPrestigeUpgrades) {
      final lv = _prefs.getInt('${GameConstants.keyPrestigeUpgradePrefix}${pu.id}') ?? 0;
      if (lv > 0) prestigeUpgradesMap[pu.id] = lv;
    }

    final boostEndTimes = <String, int>{};
    for (final b in allBoosts) {
      final end = _prefs.getInt('${GameConstants.keyBoostEndPrefix}${b.id}') ?? 0;
      if (end > 0) boostEndTimes[b.id] = end;
    }

    final achievements = _prefs.getStringList(GameConstants.keyAchievements);

    final missionProgress = <double>[];
    final completedMissions = <int>{};
    for (int i = 0; i < 5; i++) {
      missionProgress.add(
        _prefs.getDouble('${GameConstants.keyMissionProgressPrefix}$i') ?? 0,
      );
      if (_prefs.getBool('${GameConstants.keyMissionCompletePrefix}$i') == true) {
        completedMissions.add(i);
      }
    }

    return Player(
      career: career,
      coins: _prefs.getDouble(GameConstants.keyCoins) ?? 0,
      views: _prefs.getDouble(GameConstants.keyViews) ?? 0,
      followers: _prefs.getDouble(GameConstants.keyFollowers) ?? 0,
      xp: _prefs.getDouble(GameConstants.keyXp) ?? 0,
      level: _prefs.getInt(GameConstants.keyLevel) ?? 1,
      upgradeLevels: upgradeLevels,
      completedAchievements: achievements?.toSet() ?? {},
      totalTaps: _prefs.getInt(GameConstants.keyTotalTaps) ?? 0,
      totalCoinsEarned: _prefs.getDouble(GameConstants.keyTotalCoins) ?? 0,
      totalViewsEarned: _prefs.getDouble(GameConstants.keyTotalViews) ?? 0,
      totalUpgradesBought: _prefs.getInt(GameConstants.keyTotalUpgrades) ?? 0,
      missionDay: _prefs.getString(GameConstants.keyMissionDay) ?? '',
      missionProgress: missionProgress,
      completedMissions: completedMissions,
      onlineSeconds: _prefs.getInt(GameConstants.keyOnlineSeconds) ?? 0,
      prestigeCount: _prefs.getInt(GameConstants.keyPrestigeCount) ?? 0,
      prestigePoints: _prefs.getInt(GameConstants.keyPrestigePoints) ?? 0,
      totalPrestigePoints: _prefs.getInt(GameConstants.keyTotalPrestigePoints) ?? 0,
      prestigeUpgrades: prestigeUpgradesMap,
      dailyLoginStreak: _prefs.getInt(GameConstants.keyDailyLoginStreak) ?? 0,
      lastClaimDate: _prefs.getString(GameConstants.keyLastClaimDate) ?? '',
      boostEndTimes: boostEndTimes,
      lifetimeCoinsEarned: _prefs.getDouble(GameConstants.keyLifetimeCoins) ?? 0,
      lifetimeViewsEarned: _prefs.getDouble(GameConstants.keyLifetimeViews) ?? 0,
      totalOnlineSeconds: _prefs.getInt(GameConstants.keyTotalOnlineSeconds) ?? 0,
      highestCoinPerSecond: _prefs.getDouble(GameConstants.keyHighestCps) ?? 0,
      totalWheelSpins: _prefs.getInt(GameConstants.keyTotalWheelSpins) ?? 0,
      lastWheelSpin: _prefs.getInt(GameConstants.keyLastWheelSpin) ?? 0,
    );
  }

  int? loadLastSaveTimestamp() {
    return _prefs.getInt(GameConstants.keyLastSave);
  }

  Future<void> clearAll() async {
    await _prefs.clear();
  }

  String exportSave() {
    if (!hasCareer) return '';
    final map = <String, dynamic>{};
    for (final key in _prefs.getKeys()) {
      map[key] = _prefs.get(key);
    }
    return base64Encode(utf8.encode(jsonEncode(map)));
  }

  Future<bool> importSave(String data) async {
    try {
      final jsonStr = utf8.decode(base64Decode(data));
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      await _prefs.clear();
      for (final entry in map.entries) {
        final value = entry.value;
        if (value is bool) {
          await _prefs.setBool(entry.key, value);
        } else if (value is int) {
          await _prefs.setInt(entry.key, value);
        } else if (value is double) {
          await _prefs.setDouble(entry.key, value);
        } else if (value is String) {
          await _prefs.setString(entry.key, value);
        } else if (value is List) {
          await _prefs.setStringList(
            entry.key,
            value.map((e) => e.toString()).toList(),
          );
        }
      }
      return true;
    } catch (_) {
      return false;
    }
  }
}
