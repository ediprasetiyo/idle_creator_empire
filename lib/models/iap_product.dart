import 'package:flutter/material.dart';
import '../config/iap_config.dart';

enum IapProductType { consumable, nonConsumable, subscription }

class IapProductDef {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final IapProductType type;
  final double coinsReward;
  final int prestigePointsReward;
  final bool grantsRemoveAds;
  final bool grantsVip;

  const IapProductDef({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.type,
    this.coinsReward = 0,
    this.prestigePointsReward = 0,
    this.grantsRemoveAds = false,
    this.grantsVip = false,
  });
}

const allIapProducts = <IapProductDef>[
  IapProductDef(
    id: IapConfig.removeAds,
    name: 'Remove Ads',
    description: 'Permanently remove all banner and interstitial ads',
    icon: Icons.block,
    color: Color(0xFF00E676),
    type: IapProductType.nonConsumable,
    grantsRemoveAds: true,
  ),
  IapProductDef(
    id: IapConfig.starterPack,
    name: 'Starter Pack',
    description: '10,000 coins + 5 Prestige Points + 2x Income boost',
    icon: Icons.rocket_launch,
    color: Color(0xFFFF9100),
    type: IapProductType.consumable,
    coinsReward: 10000,
    prestigePointsReward: 5,
  ),
  IapProductDef(
    id: IapConfig.coinPackSmall,
    name: 'Coin Pack S',
    description: '5,000 coins',
    icon: Icons.monetization_on,
    color: Color(0xFFFFD600),
    type: IapProductType.consumable,
    coinsReward: 5000,
  ),
  IapProductDef(
    id: IapConfig.coinPackMedium,
    name: 'Coin Pack M',
    description: '25,000 coins',
    icon: Icons.monetization_on,
    color: Color(0xFFFFD600),
    type: IapProductType.consumable,
    coinsReward: 25000,
  ),
  IapProductDef(
    id: IapConfig.coinPackLarge,
    name: 'Coin Pack L',
    description: '100,000 coins + 10 Prestige Points',
    icon: Icons.monetization_on,
    color: Color(0xFFFFD600),
    type: IapProductType.consumable,
    coinsReward: 100000,
    prestigePointsReward: 10,
  ),
  IapProductDef(
    id: IapConfig.vipMembership,
    name: 'VIP Membership',
    description: 'No ads + 2x all income + daily bonus coins',
    icon: Icons.diamond,
    color: Color(0xFFE040FB),
    type: IapProductType.subscription,
    grantsRemoveAds: true,
    grantsVip: true,
  ),
];

IapProductDef? getIapProductById(String id) {
  for (final p in allIapProducts) {
    if (p.id == id) return p;
  }
  return null;
}
