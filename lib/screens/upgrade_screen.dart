import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/upgrade.dart';
import '../providers/game_provider.dart';
import '../utils/formatters.dart';
import '../widgets/upgrade_card.dart';

class UpgradeScreen extends StatefulWidget {
  const UpgradeScreen({super.key});

  @override
  State<UpgradeScreen> createState() => _UpgradeScreenState();
}

class _UpgradeScreenState extends State<UpgradeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: UpgradeCategory.values.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        final player = gameProvider.player;
        if (player == null) return const SizedBox.shrink();

        return Scaffold(
          backgroundColor: const Color(0xFF0E0E12),
          appBar: AppBar(
            backgroundColor: const Color(0xFF0E0E12),
            centerTitle: true,
            title: const Text(
              'Upgrades',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A24),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.monetization_on,
                        color: Color(0xFFFFD600),
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        formatNumber(player.coins),
                        style: const TextStyle(
                          color: Color(0xFFFFD600),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              indicatorColor: player.career.color,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white.withAlpha(80),
              dividerColor: Colors.transparent,
              tabs: UpgradeCategory.values.map((cat) {
                final unlocked = player.level >= cat.unlockLevel;
                return Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        unlocked ? cat.icon : Icons.lock,
                        size: 16,
                        color: unlocked ? cat.color : Colors.white.withAlpha(40),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        cat.label,
                        style: TextStyle(
                          color: unlocked ? null : Colors.white.withAlpha(40),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          body: Column(
            children: [
              if (player.hasAutoIncome)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00E676).withAlpha(15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF00E676).withAlpha(40),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.autorenew,
                        color: Color(0xFF00E676),
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${formatNumber(player.coinsPerSecond)}/s coins  ·  '
                        '${formatNumber(player.viewsPerSecond)}/s views  ·  '
                        '${formatNumber(player.followersPerSecond)}/s fans',
                        style: const TextStyle(
                          color: Color(0xFF00E676),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: UpgradeCategory.values.map((cat) {
                    final upgrades = getUpgradesByCategory(cat);
                    return ListView.builder(
                      padding: const EdgeInsets.only(top: 8, bottom: 20),
                      itemCount: upgrades.length,
                      itemBuilder: (context, index) {
                        final upgrade = upgrades[index];
                        final level = player.getUpgradeLevel(upgrade.id);
                        return UpgradeCard(
                          upgrade: upgrade,
                          currentLevel: level,
                          canAfford: gameProvider.canBuyUpgrade(upgrade),
                          locked: gameProvider.isUpgradeLocked(upgrade),
                          maxed: gameProvider.isUpgradeMaxed(upgrade),
                          onBuy: () => gameProvider.buyUpgrade(upgrade),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
