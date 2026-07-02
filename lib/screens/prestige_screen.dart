import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/prestige.dart';
import '../providers/game_provider.dart';
import '../utils/formatters.dart';

class PrestigeScreen extends StatelessWidget {
  const PrestigeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gp, _) {
        final player = gp.player;
        if (player == null) return const SizedBox.shrink();
        final career = player.career;

        return Scaffold(
          backgroundColor: const Color(0xFF0E0E12),
          appBar: AppBar(
            backgroundColor: const Color(0xFF0E0E12),
            title: const Text(
              'Prestige',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            iconTheme: IconThemeData(color: Colors.white.withAlpha(200)),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _PrestigeInfoCard(
                prestigeCount: player.prestigeCount,
                prestigePoints: player.prestigePoints,
                multiplier: player.prestigeMultiplier,
                potentialPoints: player.potentialPrestigePoints,
                accentColor: career.color,
              ),
              const SizedBox(height: 16),
              _RebirthButton(
                potentialPoints: player.potentialPrestigePoints,
                accentColor: career.color,
                onPrestige: () => _confirmPrestige(context, gp),
              ),
              const SizedBox(height: 24),
              Text(
                'Prestige Upgrades',
                style: TextStyle(
                  color: Colors.white.withAlpha(200),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ...allPrestigeUpgrades.map((upgrade) {
                final lv = player.getPrestigeUpgradeLevel(upgrade.id);
                final canBuy = gp.canBuyPrestigeUpgrade(upgrade);
                return _PrestigeUpgradeCard(
                  upgrade: upgrade,
                  currentLevel: lv,
                  canBuy: canBuy,
                  onBuy: canBuy ? () => gp.buyPrestigeUpgrade(upgrade) : null,
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void _confirmPrestige(BuildContext context, GameProvider gp) {
    final points = gp.player!.potentialPrestigePoints;
    if (points <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Not enough progress to prestige.'),
          backgroundColor: Color(0xFF1A1A24),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.refresh, color: Color(0xFFE040FB), size: 28),
            SizedBox(width: 8),
            Text(
              'Rebirth',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'You will earn $points Prestige Points.',
              style: const TextStyle(color: Color(0xFFE040FB), fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'This will reset your:',
              style: TextStyle(color: Colors.white.withAlpha(200), fontSize: 13),
            ),
            const SizedBox(height: 8),
            ...[
              'Level & XP',
              'Coins, Views & Followers',
              'All Upgrades',
              'Missions Progress',
            ].map((t) => Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 4),
              child: Row(
                children: [
                  Icon(Icons.remove, color: Colors.redAccent.withAlpha(180), size: 14),
                  const SizedBox(width: 6),
                  Text(t, style: TextStyle(color: Colors.white.withAlpha(150), fontSize: 12)),
                ],
              ),
            )),
            const SizedBox(height: 12),
            Text(
              'Achievements and Prestige Upgrades are kept.',
              style: TextStyle(color: Colors.white.withAlpha(120), fontSize: 11),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancel', style: TextStyle(color: Colors.white.withAlpha(150))),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              gp.prestige();
              Navigator.of(context).pop();
            },
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFE040FB),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Rebirth', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class _PrestigeInfoCard extends StatelessWidget {
  final int prestigeCount;
  final int prestigePoints;
  final double multiplier;
  final int potentialPoints;
  final Color accentColor;

  const _PrestigeInfoCard({
    required this.prestigeCount,
    required this.prestigePoints,
    required this.multiplier,
    required this.potentialPoints,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A24),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE040FB).withAlpha(40)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _InfoTile(
                label: 'Prestiges',
                value: '$prestigeCount',
                icon: Icons.refresh,
                color: const Color(0xFFE040FB),
              ),
              _InfoTile(
                label: 'Points',
                value: '$prestigePoints',
                icon: Icons.diamond,
                color: const Color(0xFF7C4DFF),
              ),
              _InfoTile(
                label: 'Multiplier',
                value: '${multiplier.toStringAsFixed(1)}x',
                icon: Icons.trending_up,
                color: const Color(0xFFFFD600),
              ),
            ],
          ),
          if (potentialPoints > 0) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFE040FB).withAlpha(20),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Rebirth now for $potentialPoints PP',
                style: const TextStyle(
                  color: Color(0xFFE040FB),
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _InfoTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white.withAlpha(120), fontSize: 11),
        ),
      ],
    );
  }
}

class _RebirthButton extends StatelessWidget {
  final int potentialPoints;
  final Color accentColor;
  final VoidCallback onPrestige;

  const _RebirthButton({
    required this.potentialPoints,
    required this.accentColor,
    required this.onPrestige,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = potentialPoints > 0;
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: FilledButton.icon(
        onPressed: enabled ? onPrestige : null,
        icon: const Icon(Icons.refresh, size: 22),
        label: Text(
          enabled ? 'Rebirth (+$potentialPoints PP)' : 'Earn more to prestige',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        style: FilledButton.styleFrom(
          backgroundColor: enabled ? const Color(0xFFE040FB) : const Color(0xFF1A1A24),
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(0xFF1A1A24),
          disabledForegroundColor: Colors.white.withAlpha(60),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }
}

class _PrestigeUpgradeCard extends StatelessWidget {
  final PrestigeUpgrade upgrade;
  final int currentLevel;
  final bool canBuy;
  final VoidCallback? onBuy;

  const _PrestigeUpgradeCard({
    required this.upgrade,
    required this.currentLevel,
    required this.canBuy,
    this.onBuy,
  });

  @override
  Widget build(BuildContext context) {
    final isMaxed = currentLevel >= upgrade.maxLevel;
    final cost = isMaxed ? 0 : upgrade.costForLevel(currentLevel);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A24),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isMaxed
              ? upgrade.color.withAlpha(60)
              : canBuy
                  ? upgrade.color.withAlpha(40)
                  : Colors.white.withAlpha(10),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: upgrade.color.withAlpha(25),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(upgrade.icon, color: upgrade.color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      upgrade.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: upgrade.color.withAlpha(30),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Lv $currentLevel/${upgrade.maxLevel}',
                        style: TextStyle(color: upgrade.color, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  upgrade.description,
                  style: TextStyle(color: Colors.white.withAlpha(120), fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (isMaxed)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: upgrade.color.withAlpha(20),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'MAX',
                style: TextStyle(color: upgrade.color, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            )
          else
            FilledButton(
              onPressed: onBuy,
              style: FilledButton.styleFrom(
                backgroundColor: canBuy ? upgrade.color : const Color(0xFF2A2A3A),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                minimumSize: Size.zero,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.diamond, size: 12),
                  const SizedBox(width: 4),
                  Text('$cost', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
