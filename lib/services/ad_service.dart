import 'dart:async';
import '../config/ad_config.dart';

enum AdType { banner, interstitial, rewarded, appOpen, native }

class AdService {
  bool _initialized = false;
  bool _consentObtained = false;
  bool _adsRemoved = false;
  final Map<String, int> _cooldowns = {};
  final List<int> _interstitialTimestamps = [];
  int _retryCount = 0;

  bool get isInitialized => _initialized;
  bool get adsAvailable => _initialized && !_adsRemoved;
  bool get consentReady => _consentObtained;

  void setAdsRemoved(bool removed) {
    _adsRemoved = removed;
  }

  Future<void> initialize() async {
    // Integration point: initialize Google Mobile Ads SDK
    // await MobileAds.instance.initialize();
    // await _requestConsent();
    _consentObtained = true;
    _initialized = true;
  }

  Future<void> _requestConsent() async {
    // Integration point: UMP SDK consent flow
    // final params = ConsentRequestParameters();
    // ConsentInformation.instance.requestConsentInfoUpdate(params, () {
    //   if (ConsentInformation.instance.isConsentFormAvailable()) {
    //     ConsentForm.loadAndShowConsentFormIfRequired((formError) {
    //       _consentObtained = true;
    //     });
    //   } else {
    //     _consentObtained = true;
    //   }
    // }, (error) { _consentObtained = true; });
  }

  bool canShowAd(AdType type) {
    if (!_initialized || _adsRemoved) return false;
    if (type == AdType.banner) return true;

    final key = type.name;
    final now = DateTime.now().millisecondsSinceEpoch;
    final last = _cooldowns[key] ?? 0;

    int cooldownMs;
    switch (type) {
      case AdType.interstitial:
        cooldownMs = AdConfig.interstitialCooldownMs;
      case AdType.rewarded:
        cooldownMs = AdConfig.rewardedCooldownMs;
      case AdType.appOpen:
        cooldownMs = AdConfig.appOpenCooldownMs;
      default:
        cooldownMs = 0;
    }

    if (now - last < cooldownMs) return false;

    if (type == AdType.interstitial) {
      final windowStart = now - AdConfig.interstitialFrequencyWindowMs;
      _interstitialTimestamps.removeWhere((t) => t < windowStart);
      if (_interstitialTimestamps.length >= AdConfig.interstitialFrequencyCap) {
        return false;
      }
    }

    return true;
  }

  int cooldownRemaining(AdType type) {
    if (!_initialized) return 0;
    final key = type.name;
    final now = DateTime.now().millisecondsSinceEpoch;
    final last = _cooldowns[key] ?? 0;

    int cooldownMs;
    switch (type) {
      case AdType.interstitial:
        cooldownMs = AdConfig.interstitialCooldownMs;
      case AdType.rewarded:
        cooldownMs = AdConfig.rewardedCooldownMs;
      case AdType.appOpen:
        cooldownMs = AdConfig.appOpenCooldownMs;
      default:
        return 0;
    }

    final elapsed = now - last;
    return (cooldownMs - elapsed).clamp(0, cooldownMs);
  }

  Future<bool> loadBannerAd({
    required String adUnitId,
    void Function()? onLoaded,
    void Function(String error)? onFailed,
  }) async {
    if (!adsAvailable) return false;

    for (int attempt = 0; attempt <= AdConfig.maxBannerRetries; attempt++) {
      // Integration point: load BannerAd
      // try {
      //   final banner = BannerAd(
      //     adUnitId: adUnitId,
      //     size: AdSize.banner,
      //     request: const AdRequest(),
      //     listener: BannerAdListener(
      //       onAdLoaded: (_) => onLoaded?.call(),
      //       onAdFailedToLoad: (_, error) => onFailed?.call(error.message),
      //     ),
      //   );
      //   await banner.load();
      //   return true;
      // } catch (e) {
      //   if (attempt < AdConfig.maxBannerRetries) {
      //     await Future.delayed(Duration(milliseconds: AdConfig.retryDelayMs * (attempt + 1)));
      //   }
      // }

      onLoaded?.call();
      return true;
    }

    onFailed?.call('Max retries exceeded');
    return false;
  }

  Future<bool> showInterstitialAd({
    void Function()? onDismissed,
    void Function(String error)? onFailed,
  }) async {
    if (!canShowAd(AdType.interstitial)) return false;

    for (int attempt = 0; attempt <= AdConfig.maxInterstitialRetries; attempt++) {
      // Integration point: load and show InterstitialAd
      // try {
      //   await InterstitialAd.load(
      //     adUnitId: AdConfig.interstitialId,
      //     request: const AdRequest(),
      //     adLoadCallback: InterstitialAdLoadCallback(
      //       onAdLoaded: (ad) {
      //         ad.fullScreenContentCallback = FullScreenContentCallback(
      //           onAdDismissedFullScreenContent: (_) { onDismissed?.call(); ad.dispose(); },
      //           onAdFailedToShowFullScreenContent: (_, error) { onFailed?.call(error.message); ad.dispose(); },
      //         );
      //         ad.show();
      //       },
      //       onAdFailedToLoad: (error) => onFailed?.call(error.message),
      //     ),
      //   );
      //   _recordAdShown(AdType.interstitial);
      //   return true;
      // } catch (e) {
      //   if (attempt < AdConfig.maxInterstitialRetries) {
      //     await Future.delayed(Duration(milliseconds: AdConfig.retryDelayMs * (attempt + 1)));
      //   }
      // }

      _recordAdShown(AdType.interstitial);
      onDismissed?.call();
      return true;
    }

    onFailed?.call('Max retries exceeded');
    return false;
  }

  Future<bool> showRewardedAd({
    required String rewardType,
    required void Function() onRewarded,
    void Function(String error)? onFailed,
  }) async {
    if (!canShowAd(AdType.rewarded)) {
      onFailed?.call('Rewarded ad not available');
      return false;
    }

    _retryCount = 0;
    return _loadAndShowRewarded(rewardType, onRewarded, onFailed);
  }

  Future<bool> _loadAndShowRewarded(
    String rewardType,
    void Function() onRewarded,
    void Function(String error)? onFailed,
  ) async {
    // Integration point: load and show RewardedAd
    // try {
    //   await RewardedAd.load(
    //     adUnitId: AdConfig.rewardedId,
    //     request: const AdRequest(),
    //     rewardedAdLoadCallback: RewardedAdLoadCallback(
    //       onAdLoaded: (ad) {
    //         ad.fullScreenContentCallback = FullScreenContentCallback(
    //           onAdDismissedFullScreenContent: (_) => ad.dispose(),
    //           onAdFailedToShowFullScreenContent: (_, error) { ad.dispose(); onFailed?.call(error.message); },
    //         );
    //         ad.show(onUserEarnedReward: (_, reward) => onRewarded());
    //       },
    //       onAdFailedToLoad: (error) {
    //         if (_retryCount < AdConfig.maxRewardedRetries) {
    //           _retryCount++;
    //           Future.delayed(Duration(milliseconds: AdConfig.retryDelayMs * _retryCount), () {
    //             _loadAndShowRewarded(rewardType, onRewarded, onFailed);
    //           });
    //         } else {
    //           onFailed?.call(error.message);
    //         }
    //       },
    //     ),
    //   );
    //   _recordAdShown(AdType.rewarded);
    //   return true;
    // } catch (e) {
    //   onFailed?.call(e.toString());
    //   return false;
    // }

    _recordAdShown(AdType.rewarded);
    onRewarded();
    return true;
  }

  Future<bool> showAppOpenAd({
    void Function()? onDismissed,
    void Function(String error)? onFailed,
  }) async {
    if (!canShowAd(AdType.appOpen)) return false;

    // Integration point: load and show AppOpenAd
    // try {
    //   await AppOpenAd.load(
    //     adUnitId: AdConfig.appOpenId,
    //     request: const AdRequest(),
    //     adLoadCallback: AppOpenAdLoadCallback(
    //       onAdLoaded: (ad) {
    //         ad.fullScreenContentCallback = FullScreenContentCallback(
    //           onAdDismissedFullScreenContent: (_) { onDismissed?.call(); ad.dispose(); },
    //           onAdFailedToShowFullScreenContent: (_, error) { onFailed?.call(error.message); ad.dispose(); },
    //         );
    //         ad.show();
    //       },
    //       onAdFailedToLoad: (error) => onFailed?.call(error.message),
    //     ),
    //   );
    //   _recordAdShown(AdType.appOpen);
    //   return true;
    // } catch (e) {
    //   onFailed?.call(e.toString());
    //   return false;
    // }

    _recordAdShown(AdType.appOpen);
    onDismissed?.call();
    return true;
  }

  Future<bool> loadNativeAd({
    required String adUnitId,
    void Function()? onLoaded,
    void Function(String error)? onFailed,
  }) async {
    if (!adsAvailable) return false;

    // Integration point: load NativeAd
    // try {
    //   final nativeAd = NativeAd(
    //     adUnitId: adUnitId,
    //     request: const AdRequest(),
    //     listener: NativeAdListener(
    //       onAdLoaded: (_) => onLoaded?.call(),
    //       onAdFailedToLoad: (_, error) => onFailed?.call(error.message),
    //     ),
    //     nativeTemplateStyle: NativeTemplateStyle(templateType: TemplateType.small),
    //   );
    //   await nativeAd.load();
    //   return true;
    // } catch (e) {
    //   onFailed?.call(e.toString());
    //   return false;
    // }

    onLoaded?.call();
    return true;
  }

  void _recordAdShown(AdType type) {
    final now = DateTime.now().millisecondsSinceEpoch;
    _cooldowns[type.name] = now;
    if (type == AdType.interstitial) {
      _interstitialTimestamps.add(now);
    }
  }

  void dispose() {
    // Integration point: dispose all loaded ads
  }
}
