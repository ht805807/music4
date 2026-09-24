import 'package:flutter/material.dart';
import 'package:music4/top_widget.dart';

/// Completion screen. Store/update links were removed; platform stores update apps.
class AllPassView extends StatelessWidget {
  const AllPassView({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
          body: SafeArea(
              child: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/image/index_background.png'),
                fit: BoxFit.cover)),
        child: Column(children: [
          const TopWidget(),
          Expanded(
              child: Center(
                  child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Image.asset('assets/image/allpass_text0.png'),
                        const SizedBox(height: 24),
                        const Text('恭喜完成所有關卡！',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center)
                      ]))))
        ]),
      )));
}

class FrameWithImage extends StatelessWidget {
  const FrameWithImage(
      {super.key, required this.backgroundImage, required this.child});
  final String backgroundImage;
  final Widget child;
  @override
  Widget build(BuildContext context) => Stack(
      alignment: Alignment.center,
      children: [Image.asset(backgroundImage, fit: BoxFit.contain), child]);
}
