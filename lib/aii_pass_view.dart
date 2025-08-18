import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music4/top_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'music_data/data.dart';
import 'dart:io';
class AllPassView extends StatelessWidget {
  const AllPassView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/image/index_background.png'), // 根据实际情况调整路径
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Include top_bar layout
            // 假设 top_bar 是一个单独的 StatefulWidget，可以直接嵌入其中
            const TopWidget(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FrameWithImage(
                      backgroundImage: 'assets/image/allpass_back0.png',
                      child:Image.asset(
                          'assets/image/allpass_text0.png'
                      )
                  ),
                  FrameWithImage(
                    backgroundImage: 'assets/image/allpass_back1.png',
                    child: Container(
                      margin: const EdgeInsets.all(16.0), // 设置上下左右外边距为 16.0
                      width: double.infinity,
                      child: const Text(
                        '本應用程式將不定期更新題庫，請勿刪除APP，直接更新應用程式資料將會延續。',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                  FrameWithImage(
                    backgroundImage: 'assets/image/allpass_back1.png',
                    child: Column(
                      children: [
                        const Text(
                          '點擊下方按鈕，查看是否有更新題庫。',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
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
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side: const BorderSide(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          child: const Text(
                            '最新更新',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class FrameWithImageAndText extends StatelessWidget {
  final String backgroundImage;
  final String? textImage;
  final Widget? child;

  const FrameWithImageAndText({super.key,
    required this.backgroundImage,
    this.textImage,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return FrameWithImage(
      backgroundImage: backgroundImage,
      child:Image.asset(
        textImage!,
        fit: BoxFit.contain,
      )
    );
  }
}

class FrameWithImage extends StatelessWidget {
  final String backgroundImage;
  final Widget child;

  const FrameWithImage({super.key,
    required this.backgroundImage,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            backgroundImage,
            fit: BoxFit.contain,
          ),
          child,
        ],
      ),
    );
  }
}

class LaunchReview {
  static const MethodChannel _channel = MethodChannel('launch_review');

  /// Note: It will not work with the iOS Simulator.
  ///
  /// Set writeReview to false to only show the app store page. Used only in iOS.
  static Future<void> launch(
      {String? androidAppId,
        String? iOSAppId,
        bool writeReview = true,
        bool isiOSBeta = false}) async {
    await _channel.invokeMethod('launch', {
      'android_id': androidAppId,
      'ios_id': iOSAppId,
      'write_review': writeReview,
      'is_ios_beta': isiOSBeta
    });
  }
}