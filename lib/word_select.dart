import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:music4/pass_event_layout.dart';
import 'aii_pass_view.dart';
import 'disc.dart';
import 'google_pay2.dart';
import 'music_data/admob.dart';
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
  BannerAd? _bannerAd;

  MethodChannel? _methodChannel;

  @override
  void initState() {
    super.initState();
    Data.generateWords();
    controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    )..repeat(reverse: true);
    _loadBanner();
  }

  void _loadBanner() {
    _bannerAd?.dispose(); // 先清掉舊的
    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
          _isLoaded = false;
        },
      ),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        /// 🔹 上方 bar
        SafeArea(
          child: Container(
            height: screenHeight * 0.06,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/image/index_bar.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: screenWidth * 0.28,
                  height: screenHeight * 0.04,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/image/all_back.png'),
                    ),
                  ),
                ),
                Container(
                  width: screenWidth * 0.12,
                  height: screenWidth * 0.12,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/image/game_level_title.png'),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    (Data.mCurrentIndex + 1).toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.05,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => ApplePay()),
                          (route) => false,
                    );
                  },
                  child: Container(
                    width: screenWidth * 0.28,
                    height: screenHeight * 0.05,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/image/game_coin.png'),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/image/game_coin_icon.png',
                          width: screenWidth * 0.05,
                        ),
                        SizedBox(width: screenWidth * 0.02),
                        Text(
                          Data.TOTAL_COINS.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.045,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        /// 🔹 中間標題
        SizedBox(
          width: screenWidth * 0.4,
          height: screenHeight * 0.05,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset('assets/image/game_title.png'),
              const Text(
                '歌曲',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),

        /// 🔹 三個按鈕區
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(
              child: GestureDetector(
                onTap: () => showConfirmDialog(2),
                child: Container(
                  width: screenWidth * 0.18,
                  height: screenHeight * 0.1,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/image/game_buy1.png'),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: screenHeight * 0.06,
                            left: screenWidth * 0.04),
                        child: Image.asset(
                          'assets/image/game_coin_icon.png',
                          width: screenWidth * 0.04,
                          height: screenWidth * 0.04,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: screenHeight * 0.06,
                            right: screenWidth * 0.05),
                        child: Text(
                          '20',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.035,
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
                  const platform = MethodChannel('test');
                  await platform.invokeMethod('FaceBookAlertDialog');
                },
                child: Container(
                  width: screenWidth * 0.18,
                  height: screenWidth * 0.18,
                ),
              ),
            ),
          ],
        ),

        /// 🔹 上方答案格
        SizedBox(
          width: screenWidth * 0.9,
          height: screenHeight * 0.18,
          child: Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: screenWidth * 0.01,
              runSpacing: screenHeight * 0.01,
              children: List.generate(
                Data.initCurrentSong().getSongName().length,
                    (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        // 清空答案區
                        Data.isVisible = false;
                        Data.isVisibleList = List.generate(30, (index) => true);
                        for (int a = 0; a < Data.mSelWords.length; a++) {
                          Data.mSelWords[a] = '';
                        }
                      });
                    },
                    child: Container(
                      width: screenWidth * 0.12,
                      height: screenWidth * 0.12,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/image/game_wordblank.png"),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: AnimatedBuilder(
                        animation: controller,
                        builder: (context, child) {
                          final word = Data.mSelWords[index];

                          // 🔸 空格 → 顯示空白
                          if (word.isEmpty) return const SizedBox();

                          // 🔸 判斷顏色
                          Color textColor;
                          if (Data.isVisible) {
                            // 錯誤 → 紅色閃爍
                            textColor = ColorTween(
                              begin: Colors.white,
                              end: Colors.red,
                            ).animate(controller).value!;
                          } else {
                            // 正常 → 白字
                            textColor = Colors.white;
                          }

                          return Text(
                            word,
                            style: TextStyle(
                              color: textColor,
                              fontSize: screenWidth * 0.05,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        /// 🔹 廣告 Banner
        if (_isLoaded && _bannerAd != null)
          SizedBox(
            width: _bannerAd!.size.width.toDouble(),
            height: _bannerAd!.size.height.toDouble(),
            child: AdWidget(ad: _bannerAd!),
          ),

        /// 🔹 底部答案線
        Padding(
          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
          child: Image.asset(
            "assets/image/game_line.png",
            width: screenWidth * 0.8,
            fit: BoxFit.contain,
          ),
        ),

        /// 🔹 候選字 Grid
        SizedBox(
          width: screenWidth * 0.8,
          height: screenHeight * 0.4,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              crossAxisSpacing: 2.0,
              mainAxisSpacing: 2.0,
            ),
            itemCount: 30,
            itemBuilder: (context, index) {
              return Visibility(
                visible: Data.isVisibleList[index],
                child: GestureDetector(
                    onTap: () {
                      MyPlayerMy.playSong(MyPlayerMy.enterTone);
                      setState(() {
                        for (int a = 0; a < Data.mSelWords.length; a++) {
                          if (Data.mSelWords[a].isEmpty) {
                            Data.isVisibleList[index] = false;
                            Data.mSelWords[a] = Data.words[index];

                            // 🔹 當填滿最後一格時，檢查答案
                            if (a == Data.mSelWords.length - 1) {
                              String selectWords = '';
                              for (int b = 0; b < Data.mSelWords.length; b++) {
                                selectWords += Data.mSelWords[b];
                              }

                              // ✅ 答案正確
                              if (selectWords == Data.initCurrentSong().getSongName()) {
                                setState(() {
                                  Data.isVisible = false; // 停止錯誤狀態，維持白字
                                });

                                if (Data.ios == "0") {
                                  if (Data.mCurrentIndex + 1 >= Music.songInfoios.length) {
                                    MyPlayerMy.playStop();
                                    SharedPreferencesHelper.SetGame();
                                    ADMob.interstitialAd();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const AllPassView()),
                                    );
                                  } else {
                                    MyPlayerMy.playSong(MyPlayerMy.coinTone);
                                    ADMob.interstitialAd();
                                    MainApiService.UpDaya();
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        MyPlayerMy.playStop();
                                        return const PassEventDialog();
                                      },
                                    );
                                  }
                                } else {
                                  if (Data.mCurrentIndex + 1 >= Music.songInfo.length) {
                                    MyPlayerMy.playStop();
                                    SharedPreferencesHelper.SetGame();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const AllPassView()),
                                    );
                                  } else {
                                    MyPlayerMy.playSong(MyPlayerMy.coinTone);
                                    MainApiService.UpDaya();
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        MyPlayerMy.playStop();
                                        return const PassEventDialog();
                                      },
                                    );
                                  }
                                }

                              }
                              // ❌ 答案錯誤 → 啟動閃爍
                              else {
                                setState(() {
                                  Data.isVisible = true;
                                });
                                MyPlayerMy.playSong(MyPlayerMy.cancelTone);
                                controller.repeat(
                                  reverse: true,
                                  period: const Duration(milliseconds: 300),
                                );
                              }
                            }

                            break; // 填字後跳出迴圈
                          }
                        }
                      });
                    },

                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/image/game_word0.png"),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      Data.words[index],
                      style: TextStyle(fontSize: screenWidth * 0.045),
                    ),
                  ),
                ),
              );
            },
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
                        MaterialPageRoute(builder: (context) => ApplePay()),
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
