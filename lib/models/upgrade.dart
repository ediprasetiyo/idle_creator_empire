import 'dart:math' as math;
import 'package:flutter/material.dart';

enum UpgradeCategory {
  equipment(
    label: 'Equipment',
    icon: Icons.build,
    color: Color(0xFF2979FF),
    unlockLevel: 1,
  ),
  content(
    label: 'Content',
    icon: Icons.video_library,
    color: Color(0xFFFF9100),
    unlockLevel: 3,
  ),
  social(
    label: 'Social',
    icon: Icons.people,
    color: Color(0xFFE040FB),
    unlockLevel: 8,
  ),
  business(
    label: 'Business',
    icon: Icons.business,
    color: Color(0xFF00BFA5),
    unlockLevel: 15,
  ),
  premium(
    label: 'Premium',
    icon: Icons.auto_awesome,
    color: Color(0xFFFFD600),
    unlockLevel: 25,
  ),
  legendary(
    label: 'Legendary',
    icon: Icons.star,
    color: Color(0xFFFF1744),
    unlockLevel: 35,
  );

  const UpgradeCategory({
    required this.label,
    required this.icon,
    required this.color,
    required this.unlockLevel,
  });

  final String label;
  final IconData icon;
  final Color color;
  final int unlockLevel;
}

class UpgradeDef {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final UpgradeCategory category;
  final double baseCost;
  final double costMul;
  final int maxLevel;
  final int unlockLevel;
  final double tapCoin;
  final double tapView;
  final double tapFollower;
  final double autoCoin;
  final double autoView;
  final double autoFollower;

  const UpgradeDef({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.category,
    required this.baseCost,
    required this.costMul,
    required this.maxLevel,
    required this.unlockLevel,
    this.tapCoin = 0,
    this.tapView = 0,
    this.tapFollower = 0,
    this.autoCoin = 0,
    this.autoView = 0,
    this.autoFollower = 0,
  });

  double costForLevel(int level) => baseCost * math.pow(costMul, level);

  bool get isAuto => autoCoin > 0 || autoView > 0 || autoFollower > 0;
}

const allUpgrades = <UpgradeDef>[
  // ═══════════════ Equipment ═══════════════
  UpgradeDef(
    id: 'better_phone', name: 'Better Phone',
    description: '+2 coins/tap',
    icon: Icons.phone_android, category: UpgradeCategory.equipment,
    baseCost: 15, costMul: 1.4, maxLevel: 50, unlockLevel: 1,
    tapCoin: 2,
  ),
  UpgradeDef(
    id: 'dslr_camera', name: 'DSLR Camera',
    description: '+5 coins, +8 views/tap',
    icon: Icons.camera_alt, category: UpgradeCategory.equipment,
    baseCost: 80, costMul: 1.5, maxLevel: 50, unlockLevel: 1,
    tapCoin: 5, tapView: 8,
  ),
  UpgradeDef(
    id: 'lighting_kit', name: 'Lighting Kit',
    description: '+10 coins, +12 views/tap',
    icon: Icons.wb_incandescent, category: UpgradeCategory.equipment,
    baseCost: 500, costMul: 1.5, maxLevel: 40, unlockLevel: 2,
    tapCoin: 10, tapView: 12,
  ),
  UpgradeDef(
    id: 'gaming_pc', name: 'Gaming PC',
    description: '+25 coins, +20 views/tap',
    icon: Icons.computer, category: UpgradeCategory.equipment,
    baseCost: 3000, costMul: 1.6, maxLevel: 30, unlockLevel: 4,
    tapCoin: 25, tapView: 20,
  ),
  UpgradeDef(
    id: 'studio', name: 'Studio',
    description: '+60 coins, +50 views/tap',
    icon: Icons.home_work, category: UpgradeCategory.equipment,
    baseCost: 20000, costMul: 1.7, maxLevel: 25, unlockLevel: 7,
    tapCoin: 60, tapView: 50,
  ),

  // ═══════════════ Content ═══════════════
  UpgradeDef(
    id: 'better_editing', name: 'Better Editing',
    description: '+8 views/tap',
    icon: Icons.video_settings, category: UpgradeCategory.content,
    baseCost: 50, costMul: 1.4, maxLevel: 50, unlockLevel: 3,
    tapView: 8,
  ),
  UpgradeDef(
    id: 'better_thumbnail', name: 'Better Thumbnail',
    description: '+15 views/tap',
    icon: Icons.image, category: UpgradeCategory.content,
    baseCost: 300, costMul: 1.5, maxLevel: 50, unlockLevel: 3,
    tapView: 15,
  ),
  UpgradeDef(
    id: 'better_titles', name: 'Better Titles',
    description: '+25 views, +3 coins/tap',
    icon: Icons.title, category: UpgradeCategory.content,
    baseCost: 1200, costMul: 1.5, maxLevel: 40, unlockLevel: 5,
    tapView: 25, tapCoin: 3,
  ),
  UpgradeDef(
    id: 'better_script', name: 'Better Script',
    description: '+50 views, +8 coins/tap',
    icon: Icons.description, category: UpgradeCategory.content,
    baseCost: 6000, costMul: 1.6, maxLevel: 30, unlockLevel: 8,
    tapView: 50, tapCoin: 8,
  ),
  UpgradeDef(
    id: 'viral_strategy', name: 'Viral Strategy',
    description: '+120 views, +15 coins/tap',
    icon: Icons.trending_up, category: UpgradeCategory.content,
    baseCost: 30000, costMul: 1.7, maxLevel: 25, unlockLevel: 12,
    tapView: 120, tapCoin: 15,
  ),

  // ═══════════════ Social ═══════════════
  UpgradeDef(
    id: 'community_manager', name: 'Community Manager',
    description: '+0.5 followers/tap, +0.3 coins/s',
    icon: Icons.person, category: UpgradeCategory.social,
    baseCost: 500, costMul: 1.5, maxLevel: 40, unlockLevel: 8,
    tapFollower: 0.5, autoCoin: 0.3,
  ),
  UpgradeDef(
    id: 'moderator', name: 'Moderator',
    description: '+1.5 followers/tap, +1 coins/s',
    icon: Icons.admin_panel_settings, category: UpgradeCategory.social,
    baseCost: 2000, costMul: 1.6, maxLevel: 35, unlockLevel: 10,
    tapFollower: 1.5, autoCoin: 1,
  ),
  UpgradeDef(
    id: 'discord_server', name: 'Discord Server',
    description: '+3 followers/tap, +3 coins/s',
    icon: Icons.forum, category: UpgradeCategory.social,
    baseCost: 8000, costMul: 1.6, maxLevel: 30, unlockLevel: 12,
    tapFollower: 3, autoCoin: 3,
  ),
  UpgradeDef(
    id: 'fan_club', name: 'Fan Club',
    description: '+8 followers/tap, +8 coins/s',
    icon: Icons.favorite, category: UpgradeCategory.social,
    baseCost: 40000, costMul: 1.7, maxLevel: 25, unlockLevel: 15,
    tapFollower: 8, autoCoin: 8,
  ),
  UpgradeDef(
    id: 'merchandise', name: 'Merchandise',
    description: '+15 followers/tap, +25 coins/s',
    icon: Icons.shopping_bag, category: UpgradeCategory.social,
    baseCost: 200000, costMul: 1.8, maxLevel: 20, unlockLevel: 18,
    tapFollower: 15, autoCoin: 25,
  ),

  // ═══════════════ Business ═══════════════
  UpgradeDef(
    id: 'sponsorship', name: 'Sponsorship',
    description: '+10 coins/s, +5 views/s',
    icon: Icons.handshake, category: UpgradeCategory.business,
    baseCost: 5000, costMul: 1.7, maxLevel: 30, unlockLevel: 15,
    autoCoin: 10, autoView: 5,
  ),
  UpgradeDef(
    id: 'brand_deals', name: 'Brand Deals',
    description: '+30 coins/s, +15 views/s',
    icon: Icons.business_center, category: UpgradeCategory.business,
    baseCost: 25000, costMul: 1.8, maxLevel: 25, unlockLevel: 17,
    autoCoin: 30, autoView: 15,
  ),
  UpgradeDef(
    id: 'agency', name: 'Agency',
    description: '+80 coins/s, +40 views/s',
    icon: Icons.corporate_fare, category: UpgradeCategory.business,
    baseCost: 150000, costMul: 1.9, maxLevel: 20, unlockLevel: 20,
    autoCoin: 80, autoView: 40,
  ),
  UpgradeDef(
    id: 'employees', name: 'Employees',
    description: '+250 coins/s, +120 views/s',
    icon: Icons.groups, category: UpgradeCategory.business,
    baseCost: 800000, costMul: 2.0, maxLevel: 15, unlockLevel: 23,
    autoCoin: 250, autoView: 120,
  ),
  UpgradeDef(
    id: 'office', name: 'Office',
    description: '+800 coins/s, +400 views/s',
    icon: Icons.apartment, category: UpgradeCategory.business,
    baseCost: 5000000, costMul: 2.1, maxLevel: 10, unlockLevel: 26,
    autoCoin: 800, autoView: 400,
  ),

  // ═══════════════ Premium ═══════════════
  UpgradeDef(
    id: 'ai_editor', name: 'AI Editor',
    description: '+50 views/s, +15 coins/s',
    icon: Icons.auto_fix_high, category: UpgradeCategory.premium,
    baseCost: 50000, costMul: 1.8, maxLevel: 25, unlockLevel: 25,
    autoView: 50, autoCoin: 15,
  ),
  UpgradeDef(
    id: 'ai_thumbnail', name: 'AI Thumbnail',
    description: '+120 views/s, +40 coins/s',
    icon: Icons.auto_awesome, category: UpgradeCategory.premium,
    baseCost: 300000, costMul: 1.9, maxLevel: 20, unlockLevel: 27,
    autoView: 120, autoCoin: 40,
  ),
  UpgradeDef(
    id: 'ai_voice', name: 'AI Voice',
    description: '+300 views/s, +100 coins/s, +5 fans/s',
    icon: Icons.record_voice_over, category: UpgradeCategory.premium,
    baseCost: 2000000, costMul: 2.0, maxLevel: 15, unlockLevel: 30,
    autoView: 300, autoCoin: 100, autoFollower: 5,
  ),
  UpgradeDef(
    id: 'ai_marketing', name: 'AI Marketing',
    description: '+800 views/s, +300 coins/s, +20 fans/s',
    icon: Icons.campaign, category: UpgradeCategory.premium,
    baseCost: 10000000, costMul: 2.1, maxLevel: 10, unlockLevel: 33,
    autoView: 800, autoCoin: 300, autoFollower: 20,
  ),
  UpgradeDef(
    id: 'ai_studio', name: 'AI Studio',
    description: '+2K views/s, +1K coins/s, +100 fans/s',
    icon: Icons.precision_manufacturing, category: UpgradeCategory.premium,
    baseCost: 50000000, costMul: 2.2, maxLevel: 8, unlockLevel: 36,
    autoView: 2000, autoCoin: 1000, autoFollower: 100,
  ),

  // ═══════════════ Legendary ═══════════════
  UpgradeDef(
    id: 'celebrity_collab', name: 'Celebrity Collab',
    description: '+200 coins, +500 views, +50 fans/tap',
    icon: Icons.star, category: UpgradeCategory.legendary,
    baseCost: 5000000, costMul: 2.0, maxLevel: 10, unlockLevel: 35,
    tapCoin: 200, tapView: 500, tapFollower: 50,
  ),
  UpgradeDef(
    id: 'global_campaign', name: 'Global Campaign',
    description: '+5K coins/s, +10K views/s',
    icon: Icons.public, category: UpgradeCategory.legendary,
    baseCost: 30000000, costMul: 2.1, maxLevel: 8, unlockLevel: 38,
    autoCoin: 5000, autoView: 10000,
  ),
  UpgradeDef(
    id: 'tv_appearance', name: 'TV Appearance',
    description: '+20K coins/s, +50K views/s, +500 fans/s',
    icon: Icons.tv, category: UpgradeCategory.legendary,
    baseCost: 200000000, costMul: 2.2, maxLevel: 5, unlockLevel: 40,
    autoCoin: 20000, autoView: 50000, autoFollower: 500,
  ),
  UpgradeDef(
    id: 'creator_empire', name: 'Creator Empire',
    description: '+100K coins/s, +200K views/s, +5K fans/s',
    icon: Icons.domain, category: UpgradeCategory.legendary,
    baseCost: 1e9, costMul: 2.3, maxLevel: 3, unlockLevel: 43,
    autoCoin: 100000, autoView: 200000, autoFollower: 5000,
  ),
  UpgradeDef(
    id: 'media_company', name: 'Media Company',
    description: '+500K coins/s, +1M views/s, +50K fans/s',
    icon: Icons.business, category: UpgradeCategory.legendary,
    baseCost: 1e10, costMul: 2.5, maxLevel: 1, unlockLevel: 48,
    autoCoin: 500000, autoView: 1000000, autoFollower: 50000,
  ),
];

UpgradeDef? getUpgradeById(String id) {
  for (final u in allUpgrades) {
    if (u.id == id) return u;
  }
  return null;
}

List<UpgradeDef> getUpgradesByCategory(UpgradeCategory cat) {
  return allUpgrades.where((u) => u.category == cat).toList();
}
