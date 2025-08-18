import 'dart:math';
import 'get_song.dart';
import 'music.dart';

class Data {
  static List<String> words = []; // 存储所有字体
  static List<String> mSelWords = []; // 存储答案
  static List<bool> isVisibleList = []; // 用于记录每个字体是否可见
  static int mCurrentIndex = 0;
  static int TOTAL_COINS = 200;
  static int INDEX_FILE_NAME = 0;
  static int INDEX_SONG_NAME = 1;
  static int PASS_AWARD_COINS = 5;
  static String mName = "";
  static int test = 0;
  static String ios ="0";
  static bool isVisible = false;
  static const String packageName = 'com.janther0927M5'; // 替换为您应用程序的包名
  static const String androidUrl =
      'https://play.google.com/store/apps/details?id=$packageName';
  static const String iosAppId = '0000'; // 替换为您应用程序在 App Store 的 App ID
  static const String iosUrl = 'https://apps.apple.com/app/id$iosAppId';

// 生成字体
  static void generateWords() {
    words = List.generate(
        30 - initCurrentSong().getSongNameLenth(), (index) => getRandomWord());

    for (int a = 0; a < initCurrentSong().getSongNameLenth(); a++) {
      words.add(initCurrentSong().getSongName()[a]);
    }
    words.shuffle();
    mSelWords =
        List.generate(initCurrentSong().getSongNameLenth(), (index) => '');
    isVisibleList = List.generate(30, (index) => true); // 初始时所有字体可见
  }

  /**
   * 获取当前关卡歌曲
   */
  static GetSong initCurrentSong() {
    // 获取当前关卡的歌曲名字和文件名字
    var song = GetSong();
    if(Data.ios=="0"){
      List<String> temp = Music.songInfoios[mCurrentIndex];
      song.setSongFileName(temp[INDEX_FILE_NAME]);
      song.setSongName(temp[INDEX_SONG_NAME]);
      return song;
    }else{
      List<String> temp = Music.songInfo[mCurrentIndex];
      song.setSongFileName(temp[INDEX_FILE_NAME]);
      song.setSongName(temp[INDEX_SONG_NAME]);
      return song;
    }

  }

  static String getRandomWord() {
    String word =
        "心流感心中的太陽迷途羔羊誠實地想你新歡心口的微光恆溫紅豆魔法餘波盪漾自虐跳進來北極星冷耳光每天都是生日壞脾氣早熟填空痛也沒關係音樂持又在呀胡店想方法下輩子不該夠了派對動物癡情玫瑰花怎麼還不射手姐姐不要不要變奏的浪漫戀元氣彈沒理由不醉不會小幸運缺口等一個人你我的歌聲裡幸福特調見招拆招信愛成癮如果你還在就好了李白愛存在不需要裝乖勢在必行是我不夠好好喜歡你愛情怎麼喊停不痛嘻哈庄腳情聽見下雨的聲音泡沫一起老去大雨將至我我自己思念是一種病天機公公偏頭痛天真有邪狂風裡擁抱久見人心途中淋雨一直走有點甜千年命運突然心動再遇見踮起腳尖說實話失語者都是你害的英雄有路兜圈完美心跳";
    return word[Random().nextInt(word.length)];
  }
}
