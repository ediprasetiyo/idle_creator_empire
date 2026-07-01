import 'package:shared_preferences/shared_preferences.dart';
import '../models/career.dart';
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
    await Future.wait([
      _prefs.setString(GameConstants.keyCareer, player.career.name),
      _prefs.setDouble(GameConstants.keyCoins, player.coins),
      _prefs.setDouble(GameConstants.keyViews, player.views),
      _prefs.setDouble(GameConstants.keyFollowers, player.followers),
      _prefs.setDouble(GameConstants.keyXp, player.xp),
      _prefs.setInt(GameConstants.keyLevel, player.level),
      _prefs.setInt(
        GameConstants.keyLastSave,
        DateTime.now().millisecondsSinceEpoch,
      ),
      ...UpgradeType.values.map((type) => _prefs.setInt(
            '${GameConstants.keyUpgradePrefix}${type.name}',
            player.upgradeLevel(type),
          )),
    ]);
  }

  Player? loadPlayer() {
    final career = loadCareer();
    if (career == null) return null;

    final upgradeLevels = <UpgradeType, int>{};
    for (final type in UpgradeType.values) {
      upgradeLevels[type] = _prefs.getInt(
            '${GameConstants.keyUpgradePrefix}${type.name}',
          ) ??
          0;
    }

    return Player(
      career: career,
      coins: _prefs.getDouble(GameConstants.keyCoins) ?? 0,
      views: _prefs.getDouble(GameConstants.keyViews) ?? 0,
      followers: _prefs.getDouble(GameConstants.keyFollowers) ?? 0,
      xp: _prefs.getDouble(GameConstants.keyXp) ?? 0,
      level: _prefs.getInt(GameConstants.keyLevel) ?? 1,
      upgradeLevels: upgradeLevels,
    );
  }

  int? loadLastSaveTimestamp() {
    return _prefs.getInt(GameConstants.keyLastSave);
  }
}
