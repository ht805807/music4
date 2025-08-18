import 'package:flutter/material.dart';
import 'google_pay.dart';
import 'main.dart';
import 'music_data/data.dart';
import 'music_data/my_player.dart';
import 'music_data/shared_preferences_helper.dart';

class TopWidget extends StatefulWidget {
  const TopWidget({super.key});

  @override
  _TopWidget createState() => _TopWidget();
}

class _TopWidget extends State<TopWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/image/index_bar.png'), // 請替換成你的圖片路徑
          fit: BoxFit.cover,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 10),
            child: IconButton(
              icon: Image.asset('assets/image/all_back.png'), // 請替換成你的圖片路徑
              onPressed: () {
                setState(() {
                  //返回鍵要做的事情
                  SharedPreferencesHelper.SetGame();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => MyApp()),
                      (route) => route == null);
                });
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 40),
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/image/game_level_title.png'))),
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text(
                    (Data.mCurrentIndex + 1).toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const GooglePayDialog()),
                );
              },
              child: Row(
                children: [
                  Container(
                    width: 100,
                    height: 38,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/image/game_coin.png'))),
                    child: Row(
                      children: [
                        Container(
                            margin: const EdgeInsets.only(left: 30),
                            width: 20,
                            height: 20,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/image/game_coin_icon.png')))),
                        Container(
                          margin: const EdgeInsets.only(left: 5, right: 10),
                          child: Text(
                            Data.TOTAL_COINS.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    SharedPreferencesHelper.SetGame();
    MyPlayerMy.playStop();
    super.dispose();
  }
}
