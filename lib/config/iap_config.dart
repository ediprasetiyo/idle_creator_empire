class IapConfig {
  static const String removeAds = 'remove_ads';
  static const String starterPack = 'starter_pack';
  static const String coinPackSmall = 'coin_pack_small';
  static const String coinPackMedium = 'coin_pack_medium';
  static const String coinPackLarge = 'coin_pack_large';
  static const String vipMembership = 'vip_membership';

  static const Set<String> consumableIds = {
    starterPack,
    coinPackSmall,
    coinPackMedium,
    coinPackLarge,
  };

  static const Set<String> nonConsumableIds = {
    removeAds,
  };

  static const Set<String> subscriptionIds = {
    vipMembership,
  };

  static const Set<String> allProductIds = {
    removeAds,
    starterPack,
    coinPackSmall,
    coinPackMedium,
    coinPackLarge,
    vipMembership,
  };
}
