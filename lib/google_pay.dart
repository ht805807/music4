import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GooglePayDialog extends StatelessWidget {


  const GooglePayDialog({super.key});

  @override
  Widget build(BuildContext context) {
    MethodChannel? _methodChannel;
    _methodChannel = const MethodChannel("test");
    _methodChannel.setMethodCallHandler((handler) => Future<String>(() {
      switch (handler.method) {
        case "TOTAL_COINS_300":
          Navigator.pop(context,'TOTAL_COINS_300');
          break;
        case "TOTAL_COINS_1200":
          Navigator.pop(context,'TOTAL_COINS_1200');
          break;
        case "TOTAL_COINS_7000":
          Navigator.pop(context,'TOTAL_COINS_7000');
          break;
        case "TOTAL_COINS_20000":
          Navigator.pop(context,'TOTAL_COINS_20000');
          break;
      }
      return "";
    }));

    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: MaterialApp(
        home: Scaffold(
          body: Center(
            child: Container(
              height: 200,
              width: 100,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/image/buytip_bg.png'), // 替换为实际图片路径
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    '付費系統',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 60),
                  buildPurchaseRow('30元購買300個金幣'),
                  const SizedBox(height: 60),
                  buildPurchaseRow('100元購買1200個金幣'),
                  const SizedBox(height: 60),
                  buildPurchaseRow('500元購買7000個金幣'),
                  const SizedBox(height: 60),
                  buildPurchaseRow('1000元購買20000個金幣'),
                  const SizedBox(height: 60),
                  buildPurchaseRow('30元購買過關金幣五倍卷(永久)'),
                  const SizedBox(height: 60),
                  const Text(
                    '購買後請勿將APP刪除，否則金幣數據將被刪除',
                    style: TextStyle(
                      color: Colors.deepOrange,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 10),
                  buildImageButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget buildPurchaseRow(String message) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        message,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 15,
        ),
      ),
      InkWell(
        onTap: () async {
          const platform = MethodChannel('test');
          await platform.invokeMethod('GooglePlay');
        },
        child: Container(
          width: 80,
          height: 26,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/image/images.jpg'), // 替换为实际图片路径
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    ],
  );
}

Widget buildImageButton(context) {
  return Container(
    child: InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/image/pp.png'), // 替换为实际图片路径
            fit: BoxFit.cover,
          ),
        ),
      ),
    ),
  );
}
