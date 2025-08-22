import 'dart:io';
import 'package:flutter/material.dart';
import 'package:music4/web_view_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'api/main_api_service.dart';
import 'home_page.dart';
import 'music_data/admob.dart';
import 'music_data/data.dart';
import 'music_data/my_player.dart';
import 'music_data/shared_preferences_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
 // MobileAds.instance.initialize();
  ADMob.initAd();
  await MainApiService().iOS().then((value) {
    if (value.isNotEmpty) {
      if (value.containsKey('data')) {
        Data.ios = value['data'];
        // 处理返回键事件，返回 true 表示可以关闭页面，返回 false 表示阻止关闭页面
        // 在这里添加您需要执行的逻辑

      }
    }
  }).onError((error, stackTrace) {

  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/image/bg5.jpg"), // 請替換為實際的圖片路徑
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/image/ab58e6a002a7e.png", // 請替換為實際的圖片路徑
                  width: 800.0,
                  height: 80.0,
                ),
                const BlinkingText('台灣猜歌金曲'),
                const SizedBox(height: 20.0),
                MyButton(text: "開始"),
                MyButton(text: "排行榜"),
                //MyButton(text: "更多遊戲"),
                //MyButton(text: "查看最新更新"),
                MyButton(text: "關於我"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  final String text;

  MyButton({super.key, required this.text});

  get async => null;

  @override
  Widget build(BuildContext context) {
    MyPlayerMy.playSong(MyPlayerMy.genericTone);
    return Container(
      width: 180.0,
      height: 40.0,
      margin: const EdgeInsets.only(top: 20.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black, backgroundColor: Colors.white,
        ),
        onPressed: () async {
          switch (text) {
            case '開始':
              {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                Data.mName = prefs.getString('Name')??"";
                if(Data.mName.isEmpty){
                  showNameInputDialog(context);
                }else{
                  Data.mCurrentIndex = prefs.getInt('GameLevel')!;
                  Data.TOTAL_COINS = prefs.getInt('GameCoins')!;
                  MyPlayerMy.playStop();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                          (route) => route == null);
                }

              }
              break;

            case '排行榜':
              {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>
                    const WebviewPage(
                        "https://caryapp.nuxmax.com/game/member_Music4.php")),
                        );
              }
              break;

            case '更多遊戲':
              {
                /*Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const WebviewPage("")),
                        );*/
              }
              break;

            case '查看最新更新':
              {
                async; {
                  String url;

                  if (Platform.isAndroid) {
                    url = Data.androidUrl;
                  } else if (Platform.isIOS) {
                    url = Data.iosUrl;
                  } else {
                    throw '不支持的平台';
                  }

                  if (await canLaunch(url)) {
                    launch(url);
                  } else {
                    throw '无法打开链接: $url';
                  }
                }
              }
              break;

            case '關於我':
              {
                showCustomAlertDialog(context);
              }
              break;
          }
        },
        child: Text(text),
      ),
    );
  }

  void showCustomAlertDialog(BuildContext context) {
    AlertDialog alertDialog = AlertDialog(
      title: const Text('關於我'),
      content: const Text(
        '此APP也不例外的廣告也很多，開發者需要靠玩家點擊廣告才會有收入，單純的展示廣告，沒點擊率是沒有辦法獲得收入的，很現實的有收入才有更新，請各位玩家多多支持並點擊廣告，謝謝。',
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(); // 关闭对话框
          },
          child: const Text('確定'),
        ),
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      },
    );
  }

  void showNameInputDialog(BuildContext context) {
    TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('請輸入您的暱稱，此暱稱將會在排行榜中顯示'),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: '輸入暱稱'),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // 关闭对话框
              },
              child: Text('取消'),
            ),
            ElevatedButton(
              onPressed: () {
                String name = nameController.text;
                if (name.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('請輸入暱稱'),
                    ),
                  );
                } else {
                  SharedPreferencesHelper.SetName(name);
                  MyPlayerMy.playStop();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                          (route) => route == null);
                  // 保存暱稱到SharedPreferences
                  // 这里省略了保存到SharedPreferences的部分，请根据你的需求完成
                  // 示例中使用了SnackBar来显示提示信息
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('輸入的暱稱為: $name'),
                    ),
                  );
                }
              },
              child: Text('完成'),
            ),
          ],
        );
      },
    );
  }
}

class BlinkingText extends StatefulWidget {
  final String text;

  const BlinkingText(this.text, {super.key});

  @override
  _BlinkingTextState createState() => _BlinkingTextState();
}

class _BlinkingTextState extends State<BlinkingText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Center(
            child: Opacity(
          opacity: _controller.value,
          child: Text(
            widget.text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ));
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    MyPlayerMy.playStop();
    super.dispose();
  }

}
