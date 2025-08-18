import 'package:flutter/material.dart';
import 'home_page.dart';
import 'music_data/data.dart';

class PassEventDialog extends StatefulWidget {
  const PassEventDialog({super.key});

  @override
  _PassEventDialog createState() => _PassEventDialog();
}

class _PassEventDialog extends State<PassEventDialog>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "恭喜過關",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20.0),
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  'assets/image/game_level_title.png',
                  width: 70.0, // 调整为期望的宽度
                  height: 70.0, // 调整为期望的高度
                ),
                // 路径需要根据实际情况调整
                Text(
                  (Data.mCurrentIndex + 1).toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Text(
              Data.initCurrentSong().getSongName(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "獎勵",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
                const SizedBox(width: 10.0),
                Image.asset(
                  'assets/image/game_coin_icon.png',
                  width: 30.0, // 调整为期望的宽度
                  height: 30.0, // 调整为期望的高度
                ),
                const SizedBox(width: 10.0),
                const Text(
                  "+",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
                const SizedBox(width: 10.0),
                const Text(
                  "5",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                  Data.mCurrentIndex+=1;
                  Data.TOTAL_COINS += 5;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => const HomePage()),
                );
              },
              child: Image.asset(
                'assets/image/pass_next.png',
                width: 200.0, // 调整为期望的宽度
                height: 50.0, // 调整为期望的高度
              ), // 路径需要根据实际情况调整
            ),
            const SizedBox(width: 20.0), // 径需要根据实际情况调整
          ],
        ),
      ),
    );
  }
}
