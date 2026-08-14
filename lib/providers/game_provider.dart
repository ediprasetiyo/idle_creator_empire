import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/iap_config.dart';
import '../models/achievement.dart';
import '../models/boost.dart';
import '../models/career.dart';
import '../models/daily_reward.dart';
import '../models/iap_product.dart';
import '../models/mission.dart';
import '../models/player.dart';
import '../models/prestige.dart';
import '../models/upgrade.dart';
import '../models/wheel_reward.dart';
import '../services/achievement_sync_service.dart';
import '../services/ad_service.dart';
import '../services/analytics_service.dart';
import '../services/audio_service.dart';
import '../services/cloud_save_service.dart';
import '../services/crash_service.dart';
import '../services/iap_service.dart';
import '../services/leaderboard_service.dart';
import '../services/notification_service.dart';
import '../services/performance_service.dart';
import '../services/remote_config_service.dart';
import '../services/save_service.dart';
import '../services/tutorial_service.dart';
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
  final AdService adService = AdService();
  final NotificationService notificationService = NotificationService();
  final AnalyticsService analyticsService = AnalyticsService();
  final CrashService crashService = CrashService();
  final RemoteConfigService remoteConfigService = RemoteConfigService();
  final PerformanceService performanceService = PerformanceService();
  final CloudSaveService cloudSaveService = CloudSaveService();
  final LeaderboardService leaderboardService = LeaderboardService();
  final AchievementSyncService achievementSyncService = AchievementSyncService();
  final IapService iapService = IapService();
  final TutorialService tutorialService = TutorialService();

  Player? _player;
  SharedPreferences? _prefs;
  bool _isLoaded = false;
  OfflineEarnings? _offlineEarnings;
  Timer? _autoIncomeTimer;
  Timer? _onlineTimer;
  int _saveCounter = 0;
  int? _pendingLevelUp;
  final List<Achievement> _pendingAchievements = [];
  List<Mission> _todayMissions = [];
  bool _prestigePending = false;
  bool _hapticEnabled = true;

  GameProvider(this._saveService);

  Player? get player => _player;
  bool get isLoaded => _isLoaded;
  bool get hasPlayer => _player != null;
  OfflineEarnings? get offlineEarnings => _offlineEarnings;
  List<Mission> get todayMissions => _todayMissions;
  bool get prestigePending => _prestigePending;
  bool get hapticEnabled => _hapticEnabled;
  SaveService get saveService => _saveService;

  set prestigePending(bool v) {
    _prestigePending = v;
    notifyListeners();
  }

  void toggleHaptic() {
    _hapticEnabled = !_hapticEnabled;
    analyticsService.logSettingsChanged('haptic', _hapticEnabled.toString());
    notifyListeners();
  }

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
    final trace = performanceService.startTrace('app_load');

    await _saveService.init();
    _prefs = await SharedPreferences.getInstance();
    await tutorialService.load(_prefs!);
    _player = _saveService.loadPlayer();
    if (_player != null) {
      _calculateOfflineEarnings();
      _ensureMissions();
      _startAutoIncome();
      _startOnlineTimer();
      crashService.setCustomKey('career', _player!.career.name);
      crashService.setCustomKey('level', _player!.level.toString());
    }

    await Future.wait([
      adService.initialize(),
      notificationService.initialize(),
      analyticsService.initialize(),
      crashService.initialize(),
      remoteConfigService.initialize(),
      performanceService.initialize(),
      cloudSaveService.initialize(),
      leaderboardService.initialize(),
      achievementSyncService.initialize(),
      iapService.initialize(),
    ]);

    _setupIapListener();

    if (_player != null) {
      adService.setAdsRemoved(_player!.removeAds || _player!.isVip);
      achievementSyncService.syncAll(_player!.completedAchievements);
    }

    analyticsService.logSessionStart();
    trace.stop();
    _isLoaded = true;
    notifyListeners();
  }

  void _setupIapListener() {
    iapService.onPurchaseComplete = (result) {
      if (!result.success || _player == null) return;
      _deliverIapProduct(result.productId);
    };
  }

  void _deliverIapProduct(String productId) {
    if (_player == null) return;
    final p = _player!;
    final product = getIapProductById(productId);
    if (product == null) return;

    if (product.grantsRemoveAds) {
      p.removeAds = true;
      adService.setAdsRemoved(true);
    }
    if (product.grantsVip) {
      p.isVip = true;
      adService.setAdsRemoved(true);
    }
    if (product.coinsReward > 0) {
      p.coins += product.coinsReward;
      p.totalCoinsEarned += product.coinsReward;
    }
    if (product.prestigePointsReward > 0) {
      p.prestigePoints += product.prestigePointsReward;
      p.totalPrestigePoints += product.prestigePointsReward;
    }
    if (productId == IapConfig.starterPack) {
      activateBoost('boost_2x', 900);
    }

    p.totalIapPurchases++;
    analyticsService.logIapPurchased(productId);
    _saveService.savePlayer(p);
    notifyListeners();
  }

  Future<bool> purchaseProduct(String productId) async {
    return iapService.purchase(productId);
  }

  Future<bool> restorePurchases() async {
    final result = await iapService.restorePurchases();
    if (result) {
      analyticsService.logIapRestored();
    }
    return result;
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
    analyticsService.logCareerSelected(career.name);
    crashService.setCustomKey('career', career.name);
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
      analyticsService.logLevelUp(p.level);
      crashService.setCustomKey('level', p.level.toString());
    } else {
      audioService.playTap();
    }

    _updateMissionProgress(MissionType.tapCount, 1);
    _updateMissionProgress(MissionType.earnCoins, coinGain);
    if (p.level > prevLevel) {
      _setMissionProgress(MissionType.reachLevel, p.level.toDouble());
    }

    _trackHighestCps();
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
    _trackHighestCps();
    _checkAchievements();
    audioService.playBuy();
    analyticsService.logUpgradePurchased(upgrade.id, lv + 1, cost);
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

    _levelUpCheck(p);
    audioService.playReward();
    analyticsService.logMissionCompleted(index);
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

  void prestige() {
    if (_player == null) return;
    final p = _player!;
    final points = p.potentialPrestigePoints;
    if (points <= 0) return;

    p.lifetimeCoinsEarned += p.totalCoinsEarned;
    p.lifetimeViewsEarned += p.totalViewsEarned;
    p.totalOnlineSeconds += p.onlineSeconds;
    _trackHighestCps();

    p.prestigeCount++;
    p.prestigePoints += points;
    p.totalPrestigePoints += points;

    final headStartLevel = p.getPrestigeUpgradeLevel('head_start');
    final startCoins = headStartAmounts[headStartLevel.clamp(0, headStartAmounts.length - 1)];

    p.coins = startCoins;
    p.views = 0;
    p.followers = 0;
    p.xp = 0;
    p.level = 1;
    p.upgradeLevels.clear();
    p.totalTaps = 0;
    p.totalCoinsEarned = 0;
    p.totalViewsEarned = 0;
    p.totalUpgradesBought = 0;
    p.missionDay = '';
    p.missionProgress = List.filled(5, 0);
    p.completedMissions = {};
    p.onlineSeconds = 0;

    _ensureMissions();
    audioService.playPrestige();
    analyticsService.logPrestigeCompleted(p.prestigeCount, points);
    _saveService.savePlayer(p);
    _prestigePending = true;
    notifyListeners();
  }

  bool canBuyPrestigeUpgrade(PrestigeUpgrade upgrade) {
    if (_player == null) return false;
    final lv = _player!.getPrestigeUpgradeLevel(upgrade.id);
    if (lv >= upgrade.maxLevel) return false;
    return _player!.prestigePoints >= upgrade.costForLevel(lv);
  }

  void buyPrestigeUpgrade(PrestigeUpgrade upgrade) {
    if (_player == null) return;
    final p = _player!;
    final lv = p.getPrestigeUpgradeLevel(upgrade.id);
    if (lv >= upgrade.maxLevel) return;
    final cost = upgrade.costForLevel(lv);
    if (p.prestigePoints < cost) return;

    p.prestigePoints -= cost;
    p.prestigeUpgrades[upgrade.id] = lv + 1;

    audioService.playBuy();
    _saveService.savePlayer(p);
    notifyListeners();
  }

  bool get hasDailyRewardAvailable {
    if (_player == null) return false;
    return _player!.lastClaimDate != _todayString();
  }

  int get currentDailyStreak {
    if (_player == null) return 0;
    return _player!.dailyLoginStreak;
  }

  void claimDailyReward() {
    if (_player == null) return;
    final p = _player!;
    final today = _todayString();
    if (p.lastClaimDate == today) return;

    final yesterday = _yesterdayString();
    if (p.lastClaimDate == yesterday) {
      p.dailyLoginStreak++;
      if (p.dailyLoginStreak > 30) p.dailyLoginStreak = 1;
    } else {
      p.dailyLoginStreak = 1;
    }

    p.lastClaimDate = today;

    final reward = allDailyRewards[p.dailyLoginStreak - 1];
    p.coins += reward.coins;
    p.totalCoinsEarned += reward.coins;
    p.xp += reward.xp;
    if (reward.prestigePoints > 0) {
      p.prestigePoints += reward.prestigePoints;
      p.totalPrestigePoints += reward.prestigePoints;
    }

    _levelUpCheck(p);
    audioService.playReward();
    analyticsService.logDailyRewardClaimed(p.dailyLoginStreak, p.dailyLoginStreak);
    _checkAchievements();
    _saveService.savePlayer(p);
    notifyListeners();
  }

  void activateBoost(String boostId, int durationSeconds) {
    if (_player == null) return;
    final now = DateTime.now().millisecondsSinceEpoch;
    final currentEnd = _player!.boostEndTimes[boostId] ?? 0;
    final newEnd = (currentEnd > now ? currentEnd : now) + (durationSeconds * 1000);
    _player!.boostEndTimes[boostId] = newEnd;
    audioService.playBoost();
    analyticsService.logBoostActivated(boostId);
    _saveService.savePlayer(_player!);
    notifyListeners();
  }

  bool isBoostActive(String boostId) {
    if (_player == null) return false;
    return (_player!.boostEndTimes[boostId] ?? 0) > DateTime.now().millisecondsSinceEpoch;
  }

  int determineWheelResult() {
    final segments = allWheelSegments;
    final totalWeight = segments.fold(0.0, (sum, s) => sum + s.weight);
    double r = Random().nextDouble() * totalWeight;
    for (int i = 0; i < segments.length; i++) {
      r -= segments[i].weight;
      if (r <= 0) return i;
    }
    return 0;
  }

  void claimWheelReward(int segmentIndex) {
    if (_player == null) return;
    if (segmentIndex < 0 || segmentIndex >= allWheelSegments.length) return;

    final segment = allWheelSegments[segmentIndex];
    final p = _player!;

    switch (segment.type) {
      case WheelRewardType.coins:
      case WheelRewardType.jackpot:
        final reward = segment.value * p.prestigeMultiplier;
        p.coins += reward;
        p.totalCoinsEarned += reward;
      case WheelRewardType.xp:
        p.xp += segment.value * p.xpGainMultiplier;
        _levelUpCheck(p);
      case WheelRewardType.boost:
        if (segment.boostId != null) {
          activateBoost(segment.boostId!, segment.value.toInt());
        }
      case WheelRewardType.prestigePoint:
        p.prestigePoints += segment.value.toInt();
        p.totalPrestigePoints += segment.value.toInt();
    }

    p.totalWheelSpins++;
    p.lastWheelSpin = DateTime.now().millisecondsSinceEpoch;

    audioService.playWheelResult();
    analyticsService.logWheelSpun(segment.label);
    _checkAchievements();
    _saveService.savePlayer(p);
    notifyListeners();
  }

  void grantFreeWheelSpin() {
    if (_player == null) return;
    _player!.lastWheelSpin = 0;
    notifyListeners();
  }

  void watchAdForBoost() {
    adService.showRewardedAd(
      rewardType: 'boost_2x',
      onRewarded: () {
        activateBoost('boost_2x', 900);
        analyticsService.logAdWatched('rewarded', 'boost_2x');
      },
    );
  }

  void watchAdForCoins() {
    if (_player == null) return;
    adService.showRewardedAd(
      rewardType: 'coins',
      onRewarded: () {
        final bonus = _player!.coinsPerSecond * 300;
        final reward = bonus > 100 ? bonus : 100;
        _player!.coins += reward;
        _player!.totalCoinsEarned += reward;
        analyticsService.logAdWatched('rewarded', 'coins');
        _saveService.savePlayer(_player!);
        notifyListeners();
      },
    );
  }

  void watchAdForWheelSpin() {
    adService.showRewardedAd(
      rewardType: 'wheel_spin',
      onRewarded: () {
        grantFreeWheelSpin();
        analyticsService.logAdWatched('rewarded', 'wheel_spin');
      },
    );
  }

  Future<CloudSaveResult> syncToCloud() async {
    if (_player == null) {
      return const CloudSaveResult(status: CloudSaveStatus.error, error: 'No player');
    }
    final saveData = _saveService.exportSave();
    final localTimestamp = DateTime.now().millisecondsSinceEpoch;
    final result = await cloudSaveService.syncSave(
      localSaveData: saveData,
      localTimestamp: localTimestamp,
    );
    if (result.status == CloudSaveStatus.success) {
      analyticsService.logCloudSaveSynced();
    }
    notifyListeners();
    return result;
  }

  Future<bool> loadFromCloud(String cloudData) async {
    final success = await _saveService.importSave(cloudData);
    if (success) {
      _player = _saveService.loadPlayer();
      if (_player != null) {
        _ensureMissions();
        _startAutoIncome();
        _startOnlineTimer();
      }
      notifyListeners();
    }
    return success;
  }

  Future<void> advanceTutorial() async {
    if (_prefs == null) return;
    await tutorialService.advanceStep(_prefs!);
    notifyListeners();
  }

  Future<void> skipTutorial() async {
    if (_prefs == null) return;
    await tutorialService.skip(_prefs!);
    notifyListeners();
  }

  Future<void> resetGame() async {
    _autoIncomeTimer?.cancel();
    _onlineTimer?.cancel();
    _player = null;
    _todayMissions = [];
    _pendingAchievements.clear();
    _pendingLevelUp = null;
    _offlineEarnings = null;
    if (_prefs != null) await tutorialService.reset(_prefs!);
    analyticsService.logGameReset();
    await _saveService.clearAll();
    notifyListeners();
  }

  String exportSave() => _saveService.exportSave();

  Future<bool> importSave(String data) async {
    final success = await _saveService.importSave(data);
    if (success) {
      _player = _saveService.loadPlayer();
      if (_player != null) {
        _ensureMissions();
        _startAutoIncome();
        _startOnlineTimer();
      }
      notifyListeners();
    }
    return success;
  }

  void _levelUpCheck(Player p) {
    final prevLevel = p.level;
    while (p.xp >= p.xpToNextLevel) {
      p.xp -= p.xpToNextLevel;
      p.level++;
    }
    if (p.level > prevLevel) {
      _pendingLevelUp = p.level;
      audioService.playLevelUp();
      analyticsService.logLevelUp(p.level);
    }
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
        analyticsService.logAchievementUnlocked(a.id);
        achievementSyncService.syncAchievement(a.id);
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
    if (_player == null) return;
    final p = _player!;

    if (p.hasAutoIncome) {
      final coinGain = p.coinsPerSecond;
      final viewGain = p.viewsPerSecond;
      p.coins += coinGain;
      p.views += viewGain;
      p.followers += p.followersPerSecond;
      p.totalCoinsEarned += coinGain;
      p.totalViewsEarned += viewGain;
      _updateMissionProgress(MissionType.earnCoins, coinGain);
    }

    if (p.hasAutoTap) {
      final coinGain = p.coinsPerTap;
      final viewGain = p.viewsPerTap;
      p.coins += coinGain;
      p.views += viewGain;
      p.followers += p.followersPerTap;
      p.xp += p.xpPerTap;
      p.totalTaps++;
      p.totalCoinsEarned += coinGain;
      p.totalViewsEarned += viewGain;
      _updateMissionProgress(MissionType.tapCount, 1);
      _updateMissionProgress(MissionType.earnCoins, coinGain);
      _levelUpCheck(p);
    }

    _trackHighestCps();
    _batchSave(10);
    notifyListeners();
  }

  void _tickOnline() {
    if (_player == null) return;
    _player!.onlineSeconds += 60;
    _player!.totalOnlineSeconds += 60;
    _setMissionProgress(
      MissionType.onlineMinutes,
      (_player!.onlineSeconds / 60).floorToDouble(),
    );
    notifyListeners();
  }

  void _trackHighestCps() {
    if (_player == null) return;
    final cps = _player!.coinsPerSecond;
    if (cps > _player!.highestCoinPerSecond) {
      _player!.highestCoinPerSecond = cps;
    }
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

  String _yesterdayString() {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return '${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _autoIncomeTimer?.cancel();
    _onlineTimer?.cancel();
    if (_player != null) _saveService.savePlayer(_player!);
    audioService.dispose();
    adService.dispose();
    notificationService.dispose();
    iapService.dispose();
    super.dispose();
  }
}
