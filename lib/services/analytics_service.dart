import '../config/analytics_events.dart';

class AnalyticsService {
  bool _initialized = false;

  bool get isInitialized => _initialized;

  Future<void> initialize() async {
    // Integration point: FirebaseAnalytics.instance
    _initialized = true;
  }

  void logEvent(String name, [Map<String, dynamic>? parameters]) {
    if (!_initialized) return;
    // Integration point:
    // FirebaseAnalytics.instance.logEvent(name: name, parameters: parameters);
  }

  void setUserId(String id) {
    if (!_initialized) return;
    // FirebaseAnalytics.instance.setUserId(id: id);
  }

  void setUserProperty(String name, String value) {
    if (!_initialized) return;
    // FirebaseAnalytics.instance.setUserProperty(name: name, value: value);
  }

  void logSessionStart() {
    logEvent(AnalyticsEvents.sessionStart);
  }

  void logSessionEnd(int durationSeconds) {
    logEvent(AnalyticsEvents.sessionEnd, {'duration_seconds': durationSeconds});
  }

  void logCareerSelected(String career) {
    logEvent(AnalyticsEvents.careerSelected, {
      AnalyticsEvents.paramCareer: career,
    });
  }

  void logUpgradePurchased(String upgradeId, int level, double cost) {
    logEvent(AnalyticsEvents.upgradePurchased, {
      AnalyticsEvents.paramUpgradeId: upgradeId,
      AnalyticsEvents.paramLevel: level,
      AnalyticsEvents.paramCoins: cost,
    });
  }

  void logPrestigeCompleted(int count, int points) {
    logEvent(AnalyticsEvents.prestigeCompleted, {
      AnalyticsEvents.paramPrestigeCount: count,
      AnalyticsEvents.paramPrestigePoints: points,
    });
  }

  void logDailyRewardClaimed(int day, int streak) {
    logEvent(AnalyticsEvents.dailyRewardClaimed, {
      AnalyticsEvents.paramDay: day,
      AnalyticsEvents.paramStreak: streak,
    });
  }

  void logWheelSpun(String segment) {
    logEvent(AnalyticsEvents.wheelSpun, {
      AnalyticsEvents.paramSegment: segment,
    });
  }

  void logAdWatched(String adType, String reward) {
    logEvent(AnalyticsEvents.adWatched, {
      AnalyticsEvents.paramAdType: adType,
      AnalyticsEvents.paramReward: reward,
    });
  }

  void logIapPurchased(String productId) {
    logEvent(AnalyticsEvents.iapPurchased, {
      AnalyticsEvents.paramProductId: productId,
    });
  }

  void logIapRestored() {
    logEvent(AnalyticsEvents.iapRestored);
  }

  void logLevelUp(int level) {
    logEvent(AnalyticsEvents.levelUp, {
      AnalyticsEvents.paramLevel: level,
    });
  }

  void logAchievementUnlocked(String achievementId) {
    logEvent(AnalyticsEvents.achievementUnlocked, {
      AnalyticsEvents.paramAchievementId: achievementId,
    });
  }

  void logMissionCompleted(int index) {
    logEvent(AnalyticsEvents.missionCompleted, {'index': index});
  }

  void logBoostActivated(String boostId) {
    logEvent(AnalyticsEvents.boostActivated, {
      AnalyticsEvents.paramBoostId: boostId,
    });
  }

  void logCloudSaveSynced() {
    logEvent(AnalyticsEvents.cloudSaveSynced);
  }

  void logSettingsChanged(String setting, String value) {
    logEvent(AnalyticsEvents.settingsChanged, {
      'setting': setting,
      'value': value,
    });
  }

  void logGameReset() {
    logEvent(AnalyticsEvents.gameReset);
  }
}
