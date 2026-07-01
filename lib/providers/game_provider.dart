import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/achievement.dart';
import '../models/career.dart';
import '../models/mission.dart';
import '../models/player.dart';
import '../models/upgrade.dart';
import '../services/audio_service.dart';
import '../services/save_service.dart';
import '../utils/constants.dart';

class OfflineEarnings {
  final double coins;
  final double views;
  final double followers;
  final Duration duration;

  const OfflineEarnings({
    required this.coins,
    required this.views,
    required this.followers,
    required this.duration,
  });

  bool get hasEarnings => coins > 0 || views > 0 || followers > 0;
}

class GameProvider extends ChangeNotifier {
  final SaveService _saveService;
  final AudioService audioService = AudioService();
  Player? _player;
  bool _isLoaded = false;
  OfflineEarnings? _offlineEarnings;
  Timer? _autoIncomeTimer;
  Timer? _onlineTimer;
  int _saveCounter = 0;
  int? _pendingLevelUp;
  final List<Achievement> _pendingAchievements = [];
  List<Mission> _todayMissions = [];

  GameProvider(this._saveService);

  Player? get player => _player;
  bool get isLoaded => _isLoaded;
  bool get hasPlayer => _player != null;
  OfflineEarnings? get offlineEarnings => _offlineEarnings;
  List<Mission> get todayMissions => _todayMissions;

  int? consumeLevelUp() {
    final lv = _pendingLevelUp;
    _pendingLevelUp = null;
    return lv;
  }

  Achievement? consumeAchievement() {
    if (_pendingAchievements.isEmpty) return null;
    return _pendingAchievements.removeAt(0);
  }

  bool get hasPendingAchievement => _pendingAchievements.isNotEmpty;

  Future<void> load() async {
    await _saveService.init();
    _player = _saveService.loadPlayer();
    if (_player != null) {
      _calculateOfflineEarnings();
      _ensureMissions();
      _startAutoIncome();
      _startOnlineTimer();
    }
    _isLoaded = true;
    notifyListeners();
  }

  void clearOfflineEarnings() {
    _offlineEarnings = null;
  }

  void _calculateOfflineEarnings() {
    final lastSave = _saveService.loadLastSaveTimestamp();
    if (lastSave == null || _player == null) return;

    final now = DateTime.now().millisecondsSinceEpoch;
    final elapsedMs = now - lastSave;
    if (elapsedMs < 60000) return;

    final maxMs = GameConstants.maxOfflineHours * 3600 * 1000;
    final cappedMs = elapsedMs > maxMs ? maxMs : elapsedMs;
    final seconds = cappedMs / 1000.0;

    final p = _player!;
    final coins = p.coinsPerSecond * seconds;
    final views = p.viewsPerSecond * seconds;
    final followers = p.followersPerSecond * seconds;

    if (coins > 0 || views > 0 || followers > 0) {
      p.coins += coins;
      p.views += views;
      p.followers += followers;
      p.totalCoinsEarned += coins;
      p.totalViewsEarned += views;
      _offlineEarnings = OfflineEarnings(
        coins: coins, views: views, followers: followers,
        duration: Duration(milliseconds: cappedMs),
      );
      audioService.playOffline();
      _saveService.savePlayer(p);
    }
  }

  Future<void> selectCareer(Career career) async {
    _player = Player(career: career);
    _ensureMissions();
    await _saveService.saveCareer(career);
    await _saveService.savePlayer(_player!);
    _startAutoIncome();
    _startOnlineTimer();
    notifyListeners();
  }

  void tap() {
    if (_player == null) return;
    final p = _player!;
    final prevLevel = p.level;

    final coinGain = p.coinsPerTap;
    final viewGain = p.viewsPerTap;
    p.coins += coinGain;
    p.views += viewGain;
    p.followers += p.followersPerTap;
    p.xp += p.xpPerTap;
    p.totalTaps++;
    p.totalCoinsEarned += coinGain;
    p.totalViewsEarned += viewGain;

    while (p.xp >= p.xpToNextLevel) {
      p.xp -= p.xpToNextLevel;
      p.level++;
    }

    if (p.level > prevLevel) {
      _pendingLevelUp = p.level;
      audioService.playLevelUp();
    } else {
      audioService.playTap();
    }

    _updateMissionProgress(MissionType.tapCount, 1);
    _updateMissionProgress(MissionType.earnCoins, coinGain);
    if (p.level > prevLevel) {
      _setMissionProgress(MissionType.reachLevel, p.level.toDouble());
    }

    _checkAchievements();
    _batchSave(5);
    notifyListeners();
  }

  bool canBuyUpgrade(UpgradeDef upgrade) {
    if (_player == null) return false;
    final lv = _player!.getUpgradeLevel(upgrade.id);
    if (lv >= upgrade.maxLevel) return false;
    return _player!.coins >= upgrade.costForLevel(lv);
  }

  bool isUpgradeLocked(UpgradeDef upgrade) {
    if (_player == null) return true;
    return _player!.level < upgrade.unlockLevel;
  }

  bool isUpgradeMaxed(UpgradeDef upgrade) {
    if (_player == null) return false;
    return _player!.getUpgradeLevel(upgrade.id) >= upgrade.maxLevel;
  }

  void buyUpgrade(UpgradeDef upgrade) {
    if (_player == null) return;
    final p = _player!;
    final lv = p.getUpgradeLevel(upgrade.id);
    if (lv >= upgrade.maxLevel) return;
    final cost = upgrade.costForLevel(lv);
    if (p.coins < cost) return;

    p.coins -= cost;
    p.upgradeLevels[upgrade.id] = lv + 1;
    p.totalUpgradesBought++;

    _updateMissionProgress(MissionType.buyUpgrades, 1);
    _checkAchievements();
    audioService.playBuy();
    _saveService.savePlayer(p);
    notifyListeners();
  }

  void claimMission(int index) {
    if (_player == null) return;
    if (index < 0 || index >= _todayMissions.length) return;
    if (_player!.completedMissions.contains(index)) return;

    final mission = _todayMissions[index];
    if (_player!.missionProgress[index] < mission.target) return;

    final p = _player!;
    p.coins += mission.coinReward;
    p.totalCoinsEarned += mission.coinReward;
    p.xp += mission.xpReward;
    p.completedMissions.add(index);

    final prevLevel = p.level;
    while (p.xp >= p.xpToNextLevel) {
      p.xp -= p.xpToNextLevel;
      p.level++;
    }
    if (p.level > prevLevel) {
      _pendingLevelUp = p.level;
      audioService.playLevelUp();
    }

    audioService.playReward();
    _checkAchievements();
    _saveService.savePlayer(p);
    notifyListeners();
  }

  bool isMissionComplete(int index) {
    if (_player == null || index >= _todayMissions.length) return false;
    return _player!.missionProgress[index] >= _todayMissions[index].target;
  }

  bool isMissionClaimed(int index) {
    if (_player == null) return false;
    return _player!.completedMissions.contains(index);
  }

  double missionProgressFraction(int index) {
    if (_player == null || index >= _todayMissions.length) return 0;
    final target = _todayMissions[index].target;
    if (target <= 0) return 1;
    return (_player!.missionProgress[index] / target).clamp(0.0, 1.0);
  }

  void _ensureMissions() {
    if (_player == null) return;
    final today = _todayString();
    if (_player!.missionDay != today) {
      _player!.missionDay = today;
      _player!.missionProgress = List.filled(5, 0);
      _player!.completedMissions = {};
      _player!.onlineSeconds = 0;
      _setMissionProgress(MissionType.reachLevel, _player!.level.toDouble());
    }
    _todayMissions = generateDailyMissions(_player!.level);
  }

  void _updateMissionProgress(MissionType type, double amount) {
    if (_player == null) return;
    final index = type.index;
    if (index < _player!.missionProgress.length) {
      _player!.missionProgress[index] += amount;
    }
  }

  void _setMissionProgress(MissionType type, double value) {
    if (_player == null) return;
    final index = type.index;
    if (index < _player!.missionProgress.length) {
      if (value > _player!.missionProgress[index]) {
        _player!.missionProgress[index] = value;
      }
    }
  }

  void _checkAchievements() {
    if (_player == null) return;
    final p = _player!;
    final thresholds = achievementThresholds;

    for (final a in allAchievements) {
      if (p.completedAchievements.contains(a.id)) continue;

      bool earned = false;
      final threshold = thresholds[a.id];

      if (threshold != null) {
        switch (a.type) {
          case AchievementType.taps:
            earned = p.totalTaps >= threshold;
          case AchievementType.coins:
            earned = p.totalCoinsEarned >= threshold;
          case AchievementType.views:
            earned = p.totalViewsEarned >= threshold;
          case AchievementType.followers:
            earned = p.followers >= threshold;
          case AchievementType.level:
            earned = p.level >= threshold;
          case AchievementType.upgrades:
            earned = p.totalUpgradesBought >= threshold;
          case AchievementType.income:
            earned = p.coinsPerSecond >= threshold;
          case AchievementType.special:
            break;
        }
      }

      if (!earned && a.type == AchievementType.special) {
        switch (a.id) {
          case 'rank_influencer':
            earned = p.rankIndex >= 3;
          case 'rank_celebrity':
            earned = p.rankIndex >= 6;
          case 'rank_legend':
            earned = p.rankIndex >= 9;
          case 'all_categories':
            earned = p.hasAllCategories;
          case 'max_upgrade':
            earned = p.hasMaxedUpgrade;
        }
      }

      if (earned) {
        p.completedAchievements.add(a.id);
        p.coins += a.coinReward;
        p.xp += a.xpReward;
        p.totalCoinsEarned += a.coinReward;
        _pendingAchievements.add(a);
      }
    }
  }

  void _startAutoIncome() {
    _autoIncomeTimer?.cancel();
    _autoIncomeTimer = Timer.periodic(
      const Duration(milliseconds: GameConstants.autoIncomeIntervalMs),
      (_) => _tickAutoIncome(),
    );
  }

  void _startOnlineTimer() {
    _onlineTimer?.cancel();
    _onlineTimer = Timer.periodic(
      const Duration(seconds: 60),
      (_) => _tickOnline(),
    );
  }

  void _tickAutoIncome() {
    if (_player == null || !_player!.hasAutoIncome) return;
    final p = _player!;

    final coinGain = p.coinsPerSecond;
    final viewGain = p.viewsPerSecond;
    p.coins += coinGain;
    p.views += viewGain;
    p.followers += p.followersPerSecond;
    p.totalCoinsEarned += coinGain;
    p.totalViewsEarned += viewGain;

    _updateMissionProgress(MissionType.earnCoins, coinGain);
    _batchSave(10);
    notifyListeners();
  }

  void _tickOnline() {
    if (_player == null) return;
    _player!.onlineSeconds += 60;
    _setMissionProgress(
      MissionType.onlineMinutes,
      (_player!.onlineSeconds / 60).floorToDouble(),
    );
    notifyListeners();
  }

  void _batchSave(int interval) {
    _saveCounter++;
    if (_saveCounter >= interval) {
      _saveCounter = 0;
      _saveService.savePlayer(_player!);
    }
  }

  String _todayString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _autoIncomeTimer?.cancel();
    _onlineTimer?.cancel();
    if (_player != null) _saveService.savePlayer(_player!);
    audioService.dispose();
    super.dispose();
  }
}
