
import 'package:audioplayers/audioplayers.dart';

class MyPlayerMy {
  static const String cancelTone = 'cancel.mp3';
  static const String enterTone = 'enter.mp3';
  static const String coinTone = 'coin.mp3';
  static const String genericTone = '000.mp3';
  static AudioPlayer player = AudioPlayer();

  static Future<void> playSong(String fileName) async {
    await player.play(AssetSource(fileName));
  }

  static Future<void> playStop() async {
    await player.stop();
  }
}