import 'dart:async';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'home_page.dart';

class GooglePayPage extends StatefulWidget {
  const GooglePayPage({super.key});

  @override
  State<GooglePayPage> createState() => _GooglePayPageState();
}

class _GooglePayPageState extends State<GooglePayPage> {
  final InAppPurchase _iap = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  final List<String> _productIds = <String>[
    'pc01',
    'pc02',
    'pc03',
    'pc04',
  ];

  List<ProductDetails> _products = [];
  bool _purchasePending = false;
  bool _isAvailable = false;

  @override
  void initState() {
    super.initState();

    _subscription = _iap.purchaseStream.listen(
      _listenToPurchaseUpdated,
      onDone: () => _subscription.cancel(),
      onError: (error) => debugPrint("❌ 購買 stream 錯誤: $error"),
    );

    _initialize();
  }

  Future<void> _initialize() async {
    final available = await _iap.isAvailable();
    setState(() {
      _isAvailable = available;
    });

    if (!available) {
      debugPrint("⚠️ IAP 不可用");
      return;
    }

    final response = await _iap.queryProductDetails(_productIds.toSet());
    if (response.error != null) {
      debugPrint("❌ 讀取產品錯誤: ${response.error}");
      return;
    }

    setState(() {
      _products = response.productDetails;
    });
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    for (final purchase in purchaseDetailsList) {
      setState(() {
        _purchasePending = false;
      });
      if (Navigator.canPop(context)) Navigator.pop(context);

      switch (purchase.status) {
        case PurchaseStatus.pending:
          setState(() => _purchasePending = true);
          break;
        case PurchaseStatus.purchased:
          debugPrint("🎉 購買成功: ${purchase.productID}");
          _iap.completePurchase(purchase);
          break;
        case PurchaseStatus.error:
          debugPrint("❌ 購買失敗: ${purchase.error}");
          break;
        case PurchaseStatus.canceled:
          debugPrint("🛑 使用者取消: ${purchase.productID}");
          break;
        case PurchaseStatus.restored:
          debugPrint("♻️ 恢復購買: ${purchase.productID}");
          break;
      }
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAvailable) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            '付費系統',
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
        ),
        body: const Center(child: Text('Store is not available')),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('付費系統'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
                    (route) => false,
              );
            },
          ),
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/image/index_background.png',
                fit: BoxFit.cover,
              ),
            ),
            ListView(
              children: _products.map((ProductDetails productDetails) {
                return Container(
                  margin: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage('assets/image/allpass_back0.png'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListTile(
                    title: Text(
                      productDetails.title,
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      productDetails.description,
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: Container(
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                          image: AssetImage('assets/image/game_coin_sel.png'),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                        ),
                        child: Text(
                          productDetails.price,
                          style: const TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          setState(() => _purchasePending = true);
                          _showLoadingDialog();
                          final purchaseParam =
                          PurchaseParam(productDetails: productDetails);
                          await _iap.buyConsumable(
                            purchaseParam: purchaseParam,
                          );
                        },
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            if (_purchasePending)
              const Center(child: CircularProgressIndicator()),
          ],
        ),
      );
    }
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
  }
}
