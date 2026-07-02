class AdConfig {
  static const bool testMode = true;

  static const String androidBannerHome = '';
  static const String androidBannerShop = '';
  static const String androidInterstitial = '';
  static const String androidRewarded = '';
  static const String androidAppOpen = '';
  static const String androidNative = '';

  static String get bannerHomeId => testMode ? _testBanner : androidBannerHome;
  static String get bannerShopId => testMode ? _testBanner : androidBannerShop;
  static String get interstitialId => testMode ? _testInterstitial : androidInterstitial;
  static String get rewardedId => testMode ? _testRewarded : androidRewarded;
  static String get appOpenId => testMode ? _testAppOpen : androidAppOpen;
  static String get nativeId => testMode ? _testNative : androidNative;

  static const String _testBanner = 'ca-app-pub-3940256099942544/6300978111';
  static const String _testInterstitial = 'ca-app-pub-3940256099942544/1033173712';
  static const String _testRewarded = 'ca-app-pub-3940256099942544/5224354917';
  static const String _testAppOpen = 'ca-app-pub-3940256099942544/9257395921';
  static const String _testNative = 'ca-app-pub-3940256099942544/2247696110';

  static const int interstitialCooldownMs = 180000;
  static const int rewardedCooldownMs = 120000;
  static const int appOpenCooldownMs = 300000;

  static const int maxBannerRetries = 3;
  static const int maxInterstitialRetries = 2;
  static const int maxRewardedRetries = 3;
  static const int retryDelayMs = 2000;

  static const int interstitialFrequencyCap = 3;
  static const int interstitialFrequencyWindowMs = 3600000;
}
