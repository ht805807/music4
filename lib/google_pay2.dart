import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'home_page.dart';
import 'music_data/data.dart';
import 'music_data/shared_preferences_helper.dart';

class ApplePay extends StatefulWidget {
  const ApplePay({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ApplePay> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  List<ProductDetails> _products = [];
  bool _isAvailable = false;
  bool _purchasePending = false;


  @override
  void initState() {
    super.initState();
    final purchaseUpdated = _inAppPurchase.purchaseStream;
    purchaseUpdated.listen(_listenToPurchaseUpdated);
    _initialize();
  }

  Future<void> _initialize() async {
    final isAvailable = await _inAppPurchase.isAvailable();
    setState(() {
      _isAvailable = isAvailable;
    });

    if (!isAvailable) {
      return;
    }

    const Set<String> _kIds = <String>{'ios01','ios02','ios03','ios04'};
    final ProductDetailsResponse response = await _inAppPurchase.queryProductDetails(_kIds);
    if (response.error != null) {
      setState(() {

      });
      return;
    }

    if (response.productDetails.isEmpty) {
      setState(() {
        _products = [];
      });
      return;
    }

    setState(() {
      _products = response.productDetails;
    });
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        _showPendingUI();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          _handleError(purchaseDetails.error.toString());
        } else if (purchaseDetails.status == PurchaseStatus.canceled) {
          _handleCanceledPurchase();
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          bool valid = _verifyPurchase(purchaseDetails);
          if (valid) {
            _deliverProduct(purchaseDetails);
          } else {
            _handleInvalidPurchase(purchaseDetails);
            return;
          }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          InAppPurchase.instance.completePurchase(purchaseDetails);
        }
      }
    });
  }

  void _handleCanceledPurchase() {
    setState(() {
      _purchasePending = false;
      _showAlert(context, "交易已取消"); // 提示用户交易已取消
    });
  }

  void _handleError(String error) {
    setState(() {
      _purchasePending = false;
    });
  }

  void _showPendingUI() {
    setState(() {
      _purchasePending = true;
    });
  }

  bool _verifyPurchase(PurchaseDetails purchaseDetails) {
    // 在這裡驗證購買，例如向服務器發送驗證請求
    return true;
  }

  void _deliverProduct(PurchaseDetails purchaseDetails) {
    setState(() {
      switch (purchaseDetails.productID) {
        case 'ios01':
          setState(() {
              _showAlert(context, "獲得300金幣");
              Data.TOTAL_COINS += 300;
              SharedPreferencesHelper.SetGame();
          });
          break;
        case 'ios02':
            setState(() {
              _showAlert(context, "獲得1200金幣");
              Data.TOTAL_COINS += 1200;
              SharedPreferencesHelper.SetGame();
            });
          break;
        case 'ios03':
          setState(() {
            _showAlert(context, "獲得7000金幣");
            Data.TOTAL_COINS += 7000;
            SharedPreferencesHelper.SetGame();
          });
          break;
        case 'ios04':
          setState(() {
            _showAlert(context, "獲得20000金幣");
            Data.TOTAL_COINS += 20000;
            SharedPreferencesHelper.SetGame();
          });
          break;
        /*case "30元購買過關金幣五倍卷(永久)":
          SharedPreferencesHelper.SetMo();
          break;*/
      }
      _purchasePending = false;
    });
    // 向用戶交付產品
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    // 處理無效的購買
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAvailable) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            '付費系統',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
        ),
        body: const Center(
          child: Text('Store is not available'),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('付費系統'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                      (route) => route == null);
            },
          ),
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/image/index_background.png', // 设置背景图像
                fit: BoxFit.cover,
              ),
            ),
            ListView(
              children: _products.map((ProductDetails productDetails) {
                return Container(
                  margin: const EdgeInsets.all(8.0), // 设置外边距
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage('assets/image/allpass_back0.png'), // 设置背景图像
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(10.0), // 圆角边框
                  ),
                  child: ListTile(
                    title: Text(
                      productDetails.title,
                      style: TextStyle(
                        color: Colors.white, // 文字颜色设置为白色或其他颜色以与背景形成对比
                      ),
                    ),
                    subtitle: Text(
                      productDetails.description,
                      style: TextStyle(
                        color: Colors.white, // 文字颜色设置为白色或其他颜色以与背景形成对比
                      ),
                    ),
                    trailing: Container(
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                          image: AssetImage('assets/image/game_coin_sel.png'), // 设置按钮的背景图像
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(8.0), // 圆角边框
                      ),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // 设置按钮内边距
                        ),
                        child: Text(
                          productDetails.price,
                          style: TextStyle(
                            color: Colors.white, // 文字颜色设置为白色或其他颜色以与背景形成对比
                          ),
                        ),
                        onPressed: () {
                          PurchaseParam purchaseParam =
                          PurchaseParam(productDetails: productDetails);
                          _inAppPurchase.buyConsumable(
                              purchaseParam: purchaseParam); // 購買消耗性商品
                        },
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            if (_purchasePending)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      );
    }

  }
  void _showAlert(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}