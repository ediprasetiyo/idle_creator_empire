class AdService {
  bool _initialized = false;
  final Map<String, int> _cooldowns = {};
  static const int cooldownMs = 120000;

  bool get adsAvailable => _initialized;

  void initialize() {
    // Integration point: initialize mobile ads SDK
    // MobileAds.instance.initialize().then((_) { _initialized = true; });
  }

  bool canShowAd(String rewardType) {
    if (!_initialized) return false;
    final last = _cooldowns[rewardType] ?? 0;
    return DateTime.now().millisecondsSinceEpoch - last > cooldownMs;
  }

  int cooldownRemaining(String rewardType) {
    if (!_initialized) return 0;
    final last = _cooldowns[rewardType] ?? 0;
    final elapsed = DateTime.now().millisecondsSinceEpoch - last;
    return (cooldownMs - elapsed).clamp(0, cooldownMs);
  }

  Future<bool> showRewardedAd({
    required String rewardType,
    required void Function() onRewarded,
  }) async {
    if (!canShowAd(rewardType)) return false;

    // Integration point: load and show rewarded ad
    // final ad = await RewardedAd.load(adUnitId: '...', ...);
    // ad.show(onUserEarnedReward: (ad, reward) { onRewarded(); });

    _cooldowns[rewardType] = DateTime.now().millisecondsSinceEpoch;

    // Simulate reward for development (remove when ads are wired)
    onRewarded();
    return true;
  }

  void dispose() {
    // Dispose ad resources
  }
}
