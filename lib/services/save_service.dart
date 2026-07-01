import 'package:shared_preferences/shared_preferences.dart';
import '../models/career.dart';
import '../models/mission.dart';
import '../models/player.dart';
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
    ];

    for (final u in allUpgrades) {
      final lv = player.getUpgradeLevel(u.id);
      if (lv > 0) {
        futures.add(_prefs.setInt('${GameConstants.keyUpgradePrefix}${u.id}', lv));
      }
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
    );
  }

  int? loadLastSaveTimestamp() {
    return _prefs.getInt(GameConstants.keyLastSave);
  }
}
