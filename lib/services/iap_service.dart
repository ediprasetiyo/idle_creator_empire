import 'dart:async';
import '../config/iap_config.dart';
import '../models/iap_product.dart';

enum IapStatus { idle, loading, purchasing, restoring, error }

class IapPurchaseResult {
  final bool success;
  final String productId;
  final String? error;
  final String? transactionId;

  const IapPurchaseResult({
    required this.success,
    required this.productId,
    this.error,
    this.transactionId,
  });
}

class IapProductInfo {
  final String id;
  final String title;
  final String price;
  final String description;
  final bool isAvailable;

  const IapProductInfo({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    this.isAvailable = true,
  });
}

class IapService {
  bool _initialized = false;
  bool _available = false;
  IapStatus _status = IapStatus.idle;
  final Map<String, IapProductInfo> _products = {};
  final Set<String> _purchasedIds = {};
  void Function(IapPurchaseResult)? onPurchaseComplete;

  bool get isInitialized => _initialized;
  bool get isAvailable => _available;
  IapStatus get status => _status;
  Map<String, IapProductInfo> get products => Map.unmodifiable(_products);
  bool hasPurchased(String id) => _purchasedIds.contains(id);
  bool get hasRemovedAds => _purchasedIds.contains(IapConfig.removeAds);
  bool get isVip => _purchasedIds.contains(IapConfig.vipMembership);

  Future<void> initialize() async {
    _status = IapStatus.loading;

    // Integration point: initialize in_app_purchase
    // final available = await InAppPurchase.instance.isAvailable();
    // if (!available) { _status = IapStatus.error; return; }
    //
    // final response = await InAppPurchase.instance.queryProductDetails(IapConfig.allProductIds);
    // for (final detail in response.productDetails) {
    //   _products[detail.id] = IapProductInfo(
    //     id: detail.id,
    //     title: detail.title,
    //     price: detail.price,
    //     description: detail.description,
    //   );
    // }
    //
    // InAppPurchase.instance.purchaseStream.listen(_handlePurchaseUpdate);
    // _available = true;
    // _initialized = true;
    // _status = IapStatus.idle;

    for (final product in allIapProducts) {
      _products[product.id] = IapProductInfo(
        id: product.id,
        title: product.name,
        price: _devPrice(product.id),
        description: product.description,
      );
    }

    _available = true;
    _initialized = true;
    _status = IapStatus.idle;
  }

  String _devPrice(String id) {
    switch (id) {
      case IapConfig.removeAds:
        return '\$2.99';
      case IapConfig.starterPack:
        return '\$4.99';
      case IapConfig.coinPackSmall:
        return '\$0.99';
      case IapConfig.coinPackMedium:
        return '\$2.99';
      case IapConfig.coinPackLarge:
        return '\$9.99';
      case IapConfig.vipMembership:
        return '\$4.99/mo';
      default:
        return '\$0.99';
    }
  }

  Future<bool> purchase(String productId) async {
    if (!_initialized || !_available) return false;
    if (_status == IapStatus.purchasing) return false;

    _status = IapStatus.purchasing;

    // Integration point: initiate purchase
    // final product = _productDetails[productId];
    // if (product == null) { _status = IapStatus.error; return false; }
    //
    // final purchaseParam = PurchaseParam(productDetails: product);
    // if (IapConfig.consumableIds.contains(productId)) {
    //   return InAppPurchase.instance.buyConsumable(purchaseParam: purchaseParam);
    // } else {
    //   return InAppPurchase.instance.buyNonConsumable(purchaseParam: purchaseParam);
    // }

    _purchasedIds.add(productId);
    _status = IapStatus.idle;
    onPurchaseComplete?.call(IapPurchaseResult(
      success: true,
      productId: productId,
      transactionId: 'dev_${DateTime.now().millisecondsSinceEpoch}',
    ));
    return true;
  }

  Future<bool> restorePurchases() async {
    if (!_initialized || !_available) return false;

    _status = IapStatus.restoring;

    // Integration point: restore purchases
    // await InAppPurchase.instance.restorePurchases();

    _status = IapStatus.idle;
    return true;
  }

  // Integration point: handle purchase stream updates
  // void _handlePurchaseUpdate(List<PurchaseDetails> purchases) {
  //   for (final purchase in purchases) {
  //     switch (purchase.status) {
  //       case PurchaseStatus.purchased:
  //       case PurchaseStatus.restored:
  //         _verifyAndDeliver(purchase);
  //       case PurchaseStatus.error:
  //         onPurchaseComplete?.call(IapPurchaseResult(
  //           success: false,
  //           productId: purchase.productID,
  //           error: purchase.error?.message,
  //         ));
  //       case PurchaseStatus.pending:
  //         break;
  //       case PurchaseStatus.canceled:
  //         break;
  //     }
  //     if (purchase.pendingCompletePurchase) {
  //       InAppPurchase.instance.completePurchase(purchase);
  //     }
  //   }
  //   _status = IapStatus.idle;
  // }

  // Integration point: server-side or local validation
  // Future<void> _verifyAndDeliver(PurchaseDetails purchase) async {
  //   final valid = await _validateReceipt(purchase);
  //   if (valid) {
  //     _purchasedIds.add(purchase.productID);
  //     onPurchaseComplete?.call(IapPurchaseResult(
  //       success: true,
  //       productId: purchase.productID,
  //       transactionId: purchase.purchaseID,
  //     ));
  //   } else {
  //     onPurchaseComplete?.call(IapPurchaseResult(
  //       success: false,
  //       productId: purchase.productID,
  //       error: 'Receipt validation failed',
  //     ));
  //   }
  // }
  //
  // Future<bool> _validateReceipt(PurchaseDetails purchase) async {
  //   // Local validation: check purchase token format
  //   // Server validation: POST to your backend with purchase token
  //   // Backend verifies with Google Play Developer API
  //   return true;
  // }

  String? getPrice(String productId) {
    return _products[productId]?.price;
  }

  void dispose() {
    // Integration point: cancel purchase stream subscription
  }
}
