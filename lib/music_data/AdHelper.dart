import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-7319177608866963/6040037387';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-7319177608866963/5494926684';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-7319177608866963/3181089695';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-7319177608866963/6345221343';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
