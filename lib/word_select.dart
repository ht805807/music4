import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music4/pass_event_layout.dart';
import 'aii_pass_view.dart';
import 'disc.dart';
import 'google_pay2.dart';
import 'main.dart';
import 'music_data/data.dart';
import 'music_data/main_api_service.dart';
import 'music_data/music.dart';
import 'music_data/my_player.dart';
import 'music_data/shared_preferences_helper.dart';

class WordSelect extends StatefulWidget {
  const WordSelect({super.key});

  @override
  MyGridView createState() => MyGridView();
}

class MyGridView extends State<WordSelect>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  final adUnitId = Platform.isAndroid
      ? 'ca-app-pub-7319177608866963/6040037387'
      : 'ca-app-pub-7319177608866963/5494926684';
  bool _isLoaded = false;

  MethodChannel? _methodChannel;

  @override
  void initState() {
    super.initState();
    Data.generateWords();
    controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        //const SizedBox(height: 30),
        Container(
          height: 80,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/image/index_bar.png'), // 請替換成你的圖片路徑
              fit: BoxFit.cover,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 100,
                height: 46,
                child: IconButton(
                  icon: Image.asset('assets/image/all_back.png'), // 請替換成你的圖片路徑
                  onPressed: () {
                    setState(() {
                      //返回鍵要做的事情
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => MyApp()),
                          (route) => route == null);
                    });
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 10),
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image:
                            AssetImage('assets/image/game_level_title.png'))),
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
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => GooglePayDialog2()),
                            (route) => route == null);
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 100,
                        height: 38,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image:
                                    AssetImage('assets/image/game_coin.png'))),
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
        ),
        SizedBox(
          width: 160, // 替換成你的 dimen/HDlayx300
          height: 60, // 替換成你的 dimen/HDlayy100
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset('assets/image/game_title.png'), // 請替換成你的圖片路徑
              const Text(
                '歌曲',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Center(
            child: GestureDetector(
              onTap: () {
                // 处理按钮点击事件
                setState(() {
                  showConfirmDialog(2);
                });
              },
              child: Container(
                width: 70,
                height: 76,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/image/game_buy1.png'),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 46, left: 16),
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image:
                                AssetImage('assets/image/game_coin_icon.png'),
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 46, right: 20),
                      child: Text(
                        '20', // 替換為您的實際文本
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const DiscWidget(),
          Center(
            child: GestureDetector(
              onTap: () async {
                // 处理按钮点击事件
                const platform = MethodChannel('test');
                await platform.invokeMethod('FaceBookAlertDialog');
              },
              child: Container(
                width: 76,
                height: 76,
                /*decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/image/share_button_sel.png'),
                  ),
                ),*/
              ),
            ),
          ),
        ]),

        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(
            width: 300, // 設置你想要的寬度,
            height: 124, // 設置你想要的高度,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                crossAxisSpacing: 1.0,
                mainAxisSpacing: 1.0,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      Data.isVisible = false;
                      Data.isVisibleList = List.generate(30, (index) => true);
                      for (int a = 0; a < Data.mSelWords.length; a++) {
                        if (Data.mSelWords[a].isNotEmpty) {
                          Data.mSelWords[a] = '';
                        }
                      }
                    });
                  },
                  child: Visibility(
                    visible: true,
                    child: Container(
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                  "assets/image/game_wordblank.png"))),
                      child: Container(
                        alignment: Alignment.center,
                        child: Visibility(
                          visible: true,
                          child: AnimatedBuilder(
                            animation: controller,
                            builder: (context, child) {
                              // 使用 ColorTween 切換白色和紅色
                              Color? textColor = ColorTween(
                                begin: Data.isVisible
                                    ? Colors.white
                                    : Colors.transparent,
                                end: Data.isVisible
                                    ? Colors.red
                                    : Colors.transparent,
                              ).animate(controller).value;
                              return Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Center(
                                        child: Visibility(
                                      visible: !Data.isVisible,
                                      child: Text(
                                        Data.mSelWords[index],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 24.0,
                                        ),
                                      ),
                                    )),
                                    Center(
                                        child: Visibility(
                                            visible: Data.isVisible,
                                            child: Opacity(
                                              opacity: controller.value,
                                              child: Text(
                                                Data.mSelWords[index],
                                                style: TextStyle(
                                                  color: textColor,
                                                  fontSize: 24.0,
                                                ),
                                              ),
                                            )))
                                  ]);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
              itemCount: Data.initCurrentSong().getSongName().length,
            ),
          ),
        ]),
        /*Align(
          alignment: Alignment.center,
          child: SafeArea(
            child: SizedBox(
              width: _bannerAd!.size.width.toDouble(),
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            ),
          ),
        ),*/
        SizedBox(
          width: 340, // 設置你想要的寬度,
          height: 20, // 設置你想要的高度,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset('assets/image/game_line.png'),
            ],
          ),
        ),
        SizedBox(
          width: 300,
          height: 300,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              crossAxisSpacing: 2.0,
              mainAxisSpacing: 2.0,
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  MyPlayerMy.playSong(MyPlayerMy.enterTone);
                  setState(() {
                    for (int a = 0; a < Data.mSelWords.length; a++) {
                      if (Data.mSelWords[a].isEmpty) {
                        Data.isVisibleList[index] = false;
                        Data.mSelWords[a] = Data.words[index];
                        if (a == Data.mSelWords.length - 1) {
                          String selectWords = '';
                          for (int b = 0; b < Data.mSelWords.length; b++) {
                            selectWords += Data.mSelWords[b];
                          }
                          print("SelectWords = $selectWords");
                          print("getSongName = ${Data.initCurrentSong().getSongName()}");
                          if (selectWords ==
                              Data.initCurrentSong().getSongName()) {
                            if(Data.ios=="0"){
                              if (Data.mCurrentIndex + 1 >=
                                  Music.songInfoios.length) {

                                MyPlayerMy.playStop();
                                SharedPreferencesHelper.SetGame();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const AllPassView()),
                                );
                              } else {
                                MyPlayerMy.playSong(MyPlayerMy.coinTone);

                                MainApiService.UpDaya();
                                showDialog(
                                  context: context,
                                  barrierDismissible: false, // 點擊外部不會消失
                                  builder: (BuildContext context) {
                                    MyPlayerMy.playStop();
                                    return const PassEventDialog();
                                  },
                                );
                              }
                            }else{
                              if (Data.mCurrentIndex + 1 >=
                                  Music.songInfo.length) {

                                MyPlayerMy.playStop();
                                SharedPreferencesHelper.SetGame();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const AllPassView()),
                                );
                              } else {
                                MyPlayerMy.playSong(MyPlayerMy.coinTone);

                                MainApiService.UpDaya();
                                showDialog(
                                  context: context,
                                  barrierDismissible: false, // 點擊外部不會消失
                                  builder: (BuildContext context) {
                                    MyPlayerMy.playStop();
                                    return const PassEventDialog();
                                  },
                                );
                              }
                            }

                          } else {
                            Data.isVisible = true;
                            MyPlayerMy.playSong(MyPlayerMy.cancelTone);
                            controller.repeat(
                                reverse: true,
                                period: const Duration(milliseconds: 300));
                          }
                        } else {
                          break;
                        }
                      }
                    }
                  });
                },
                child: Visibility(
                  visible: Data.isVisibleList[index],
                  child: Container(
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/image/game_word0.png"))),
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        Data.words[index],
                        style: const TextStyle(fontSize: 20.0),
                      ),
                    ),
                  ),
                ),
              );
            },
            itemCount: 30,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    controller.dispose();
    SharedPreferencesHelper.SetGame();
    MyPlayerMy.playStop();
    super.dispose();
  }

  void showConfirmDialog(int id) {
    switch (id) {
      case 1:
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("確認花掉 10 個金幣去掉一個答案"),
              actions: [
                TextButton(
                  onPressed: () {
                    // 在此處添加確認刪除單詞的邏輯
                    Navigator.pop(context); // 關閉對話框
                  },
                  child: Text('確認'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // 關閉對話框
                  },
                  child: Text('取消'),
                ),
              ],
            );
          },
        );
        break;
      case 2:
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("確認花掉 20 個金幣獲得一個文字提示"),
              actions: [
                TextButton(
                  onPressed: () {
                    // 在此處添加確認獲取提示文字的邏輯
                    if (Data.TOTAL_COINS >= 20) {
                      setState(() {
                        Data.TOTAL_COINS -= 20;
                        SharedPreferencesHelper.SetGame();
                      });
                      Navigator.pop(context); // 關閉對話框
                      MyPlayerMy.playSong(MyPlayerMy.enterTone);
                      for (int a = 0;
                          a < Data.initCurrentSong().getSongName().length;
                          a++) {
                        if (Data.mSelWords[a].isEmpty) {
                          Data.mSelWords[a] =
                              Data.initCurrentSong().getSongName()[a];
                          if (a == Data.mSelWords.length - 1) {
                            String SelectWords = '';
                            for (int b = 0; b < Data.mSelWords.length; b++) {
                              SelectWords += Data.mSelWords[b];
                            }
                            print("SelectWords2 = " + SelectWords);
                            print("getSongName2 = " +
                                Data.initCurrentSong().getSongName());
                            if(Data.ios=="0"){
                              if (SelectWords ==
                                  Data.initCurrentSong().getSongName()) {
                                if (Data.mCurrentIndex + 1 >=
                                    Music.songInfoios.length) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                        const AllPassView()),
                                  );
                                } else {
                                  SharedPreferencesHelper.SetGame();
                                  MyPlayerMy.playSong(MyPlayerMy.coinTone);
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return const PassEventDialog();
                                    },
                                  );
                                }
                              } else {
                                Data.isVisible = true;
                                MyPlayerMy.playSong(MyPlayerMy.cancelTone);
                                controller.repeat(
                                    reverse: true,
                                    period: const Duration(milliseconds: 300));
                              }
                            }else{
                              if (SelectWords ==
                                  Data.initCurrentSong().getSongName()) {
                                if (Data.mCurrentIndex + 1 >=
                                    Music.songInfo.length) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                        const AllPassView()),
                                  );
                                } else {
                                  SharedPreferencesHelper.SetGame();
                                  MyPlayerMy.playSong(MyPlayerMy.coinTone);
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return const PassEventDialog();
                                    },
                                  );
                                }
                              } else {
                                Data.isVisible = true;
                                MyPlayerMy.playSong(MyPlayerMy.cancelTone);
                                controller.repeat(
                                    reverse: true,
                                    period: const Duration(milliseconds: 300));
                              }
                            }



                          } else {
                            break;
                          }
                        }
                      }
                    } else {
                      showConfirmDialog(3);
                    }
                  },
                  child: Text('確認'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // 關閉對話框
                  },
                  child: Text('取消'),
                ),
              ],
            );
          },
        );
        break;
      case 3:
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("金幣不足，去商店補充?"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // 關閉對話框
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => GooglePayDialog2()),
                            (route) => route == null);
                  },
                  child: const Text('確認'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // 關閉對話框
                  },
                  child: const Text('取消'),
                ),
              ],
            );
          },
        );
        break;
      default:
        break;
    }
  }

  void TOTAL_COINS_200() {
    setState(() {
      Data.TOTAL_COINS += 200;
      SharedPreferencesHelper.SetGame();
    });
  }

  void TOTAL_COINS_300() {
    setState(() {
      Data.TOTAL_COINS += 300;
      SharedPreferencesHelper.SetGame();
    });
  }

  void TOTAL_COINS_1200() {
    setState(() {
      Data.TOTAL_COINS += 1200;
      SharedPreferencesHelper.SetGame();
    });
  }

  void TOTAL_COINS_7000() {
    setState(() {
      Data.TOTAL_COINS += 7000;
      SharedPreferencesHelper.SetGame();
    });
  }

  void TOTAL_COINS_20000() {
    setState(() {
      Data.TOTAL_COINS += 20000;
      SharedPreferencesHelper.SetGame();
    });
  }
}
