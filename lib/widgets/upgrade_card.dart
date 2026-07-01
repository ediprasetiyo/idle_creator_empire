import 'package:flutter/material.dart';
import '../models/upgrade.dart';
import '../utils/formatters.dart';

class UpgradeCard extends StatelessWidget {
  final Upgrade upgrade;
  final int currentLevel;
  final bool canAfford;
  final Color accentColor;
  final VoidCallback onBuy;

  const UpgradeCard({
    super.key,
    required this.upgrade,
    required this.currentLevel,
    required this.canAfford,
    required this.accentColor,
    required this.onBuy,
  });

  @override
  Widget build(BuildContext context) {
    final cost = upgrade.costForLevel(currentLevel);
    final isAutoUpgrade = upgrade.autoCoinsPerSec > 0 ||
        upgrade.autoViewsPerSec > 0 ||
        upgrade.autoFollowersPerSec > 0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A24),
        borderRadius: BorderRadius.circular(16),
        border: canAfford
            ? Border.all(color: accentColor.withAlpha(60), width: 1)
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: canAfford ? onBuy : null,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: accentColor.withAlpha(30),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(upgrade.icon, color: accentColor, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              upgrade.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: accentColor.withAlpha(25),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Lv $currentLevel',
                              style: TextStyle(
                                color: accentColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          if (isAutoUpgrade)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 1,
                              ),
                              margin: const EdgeInsets.only(right: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF00E676).withAlpha(30),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'AUTO',
                                style: TextStyle(
                                  color: Color(0xFF00E676),
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          Text(
                            upgrade.description,
                            style: TextStyle(
                              color: Colors.white.withAlpha(120),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: canAfford
                            ? accentColor
                            : Colors.white.withAlpha(15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.monetization_on,
                            size: 14,
                            color: canAfford
                                ? Colors.white
                                : Colors.white.withAlpha(60),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            formatNumber(cost),
                            style: TextStyle(
                              color: canAfford
                                  ? Colors.white
                                  : Colors.white.withAlpha(60),
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
