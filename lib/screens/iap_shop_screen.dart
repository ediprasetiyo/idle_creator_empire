import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/iap_product.dart';
import '../providers/game_provider.dart';
import '../services/iap_service.dart';

class IapShopScreen extends StatelessWidget {
  const IapShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gp, _) {
        final player = gp.player;
        if (player == null) return const SizedBox.shrink();

        final isPurchasing = gp.iapService.status == IapStatus.purchasing;

        return Scaffold(
          backgroundColor: const Color(0xFF0E0E12),
          appBar: AppBar(
            backgroundColor: const Color(0xFF0E0E12),
            title: const Text(
              'Shop',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            iconTheme: IconThemeData(color: Colors.white.withAlpha(200)),
            actions: [
              TextButton(
                onPressed: isPurchasing ? null : () => _restorePurchases(context, gp),
                child: Text(
                  'Restore',
                  style: TextStyle(
                    color: isPurchasing ? Colors.white.withAlpha(40) : const Color(0xFF2979FF),
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (player.isVip)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFE040FB), Color(0xFF7C4DFF)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.diamond, color: Colors.white, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'VIP Active — 2x All Income!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              if (player.removeAds && !player.isVip)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00E676).withAlpha(20),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF00E676).withAlpha(40)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle, color: Color(0xFF00E676), size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Ads Removed',
                        style: TextStyle(color: Color(0xFF00E676), fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              for (final product in allIapProducts)
                _ProductTile(
                  product: product,
                  price: gp.iapService.getPrice(product.id) ?? '',
                  isPurchased: _isNonConsumablePurchased(product, player),
                  isPurchasing: isPurchasing,
                  onBuy: () => _buyProduct(context, gp, product),
                ),
            ],
          ),
        );
      },
    );
  }

  bool _isNonConsumablePurchased(IapProductDef product, dynamic player) {
    if (product.grantsRemoveAds && player.removeAds) return true;
    if (product.grantsVip && player.isVip) return true;
    return false;
  }

  void _buyProduct(BuildContext context, GameProvider gp, IapProductDef product) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(product.icon, color: product.color, size: 28),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                product.name,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.description,
              style: TextStyle(color: Colors.white.withAlpha(180), fontSize: 13),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF0E0E12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                gp.iapService.getPrice(product.id) ?? '',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: product.color,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
              gp.purchaseProduct(product.id);
            },
            style: FilledButton.styleFrom(
              backgroundColor: product.color,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Buy', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _restorePurchases(BuildContext context, GameProvider gp) async {
    final success = await gp.restorePurchases();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? 'Purchases restored!' : 'Could not restore purchases.'),
          backgroundColor: success ? const Color(0xFF00E676) : Colors.redAccent,
        ),
      );
    }
  }
}

class _ProductTile extends StatelessWidget {
  final IapProductDef product;
  final String price;
  final bool isPurchased;
  final bool isPurchasing;
  final VoidCallback onBuy;

  const _ProductTile({
    required this.product,
    required this.price,
    required this.isPurchased,
    required this.isPurchasing,
    required this.onBuy,
  });

  @override
  Widget build(BuildContext context) {
    final isSubscription = product.type == IapProductType.subscription;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A24),
        borderRadius: BorderRadius.circular(14),
        border: isSubscription
            ? Border.all(color: product.color.withAlpha(40))
            : null,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: product.color.withAlpha(20),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(product.icon, color: product.color, size: 26),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                product.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (isSubscription)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: product.color.withAlpha(30),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'VIP',
                  style: TextStyle(color: product.color, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            product.description,
            style: TextStyle(color: Colors.white.withAlpha(100), fontSize: 11),
          ),
        ),
        trailing: isPurchased
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF00E676).withAlpha(20),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Owned',
                  style: TextStyle(
                    color: Color(0xFF00E676),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : GestureDetector(
                onTap: isPurchasing ? null : onBuy,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isPurchasing ? Colors.white.withAlpha(10) : product.color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    price,
                    style: TextStyle(
                      color: isPurchasing ? Colors.white.withAlpha(40) : Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
