import 'package:flutter/material.dart';
import 'package:music4/music_data/data.dart';

import 'music_data/my_player.dart';

class DiscWidget extends StatefulWidget {
  const DiscWidget({super.key});

  @override
  _DiscWidget createState() => _DiscWidget();
}

class _DiscWidget extends State<DiscWidget> with TickerProviderStateMixin {
  bool mbtnGameStartVisible = true;
  late AnimationController _controller;
  late AnimationController _controller2;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _controller2 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // 当动画完成并且未反转时，延迟10秒后反转动画
        _controller2.forward();
        if(Data.ios=="0"){
          MyPlayerMy.playSong('ios'+(Data.mCurrentIndex+1).toString()+".mp3");
        }else{
          MyPlayerMy.playSong((Data.mCurrentIndex+300).toString()+".mp3");
        }

        Future.delayed(const Duration(seconds: 10), () {
          _controller.reverse();

          setState(() {
            Future.delayed(const Duration(seconds: 1), () {
              setState(() {
                mbtnGameStartVisible = true;
                _controller2.reset();
              });
            });
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100, // 替換成你的 dimen/HDlayy420
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 100, // 替換成你的 dimen/HDlayx300
                height: 100, // 替換成你的 dimen/HDlayy300
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Center(
                      child: AnimatedBuilder(
                        animation: _controller2,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: _controller2.value * 5 * 3.14,
                            // 0.25表示45度的旋转
                            alignment: Alignment.center,
                            child: Image.asset(
                              'assets/image/game_disc.png', // 替换成你的图像路径
                            ),
                          );
                        },
                      ),
                    ),
                    Image.asset('assets/image/game_disc_light.png'),
                    Image.asset('assets/image/game_center.png'),
                    Positioned(
                        left: 80,
                        top: 0,
                        right: -5,
                        child: SizedBox(
                          height: 100,
                          child: Stack(
                            children: [
                              Center(
                                child: AnimatedBuilder(
                                  animation: _controller,
                                  builder: (context, child) {
                                    return Transform.rotate(
                                      angle: _controller.value * 0.20 * 3.14,
                                      // 0.25表示45度的旋转
                                      alignment: Alignment.topCenter,
                                      child: Image.asset(
                                        'assets/image/index_pin.png', // 替换成你的图像路径
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ), // 請替換成你的圖片路徑
                        )),
                    Positioned(
                      height: 100,
                      width: 100,
                      child: IconButton(
                          icon: Visibility(
                            visible: mbtnGameStartVisible,
                            // 設置為true以顯示圖像，設置為false以隱藏圖像
                            child: Image.asset('assets/image/index_start.png'),
                          ),
                          // 請替換成你的圖片路徑
                          onPressed: () {
                            // 處理遊戲開始按鈕的操作

                            setState(() {
                              mbtnGameStartVisible = false;
                            });
                            _controller.forward();
                          }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _controller2.dispose();
    super.dispose();
  }
}
