import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class ADMob {
  static late final InterstitialAd? _interstitialAd;
  static final adUnitId = Platform.isAndroid
      ? 'ca-app-pub-7319177608866963/3181089695'
      : 'ca-app-pub-7319177608866963/3181089695';

  static void initAd() {
    InterstitialAd.load(
        adUnitId: adUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (InterstitialAd ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
              // Called when the ad showed the full screen content.
                onAdShowedFullScreenContent: (ad) {},
                // Called when an impression occurs on the ad.
                onAdImpression: (ad) {},
                // Called when the ad failed to show full screen content.
                onAdFailedToShowFullScreenContent: (ad, err) {
                  //ad.dispose();
                },
                // Called when the ad dismissed full screen content.
                onAdDismissedFullScreenContent: (ad) {
                  //ad.dispose();
                  _interstitialAd = ad;
                },
                // Called when a click is recorded for an ad.
                onAdClicked: (ad) {});

            // Keep a reference to the ad so you can show it later.
            _interstitialAd = ad;
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            // ignore: avoid_print
            print('InterstitialAd failed to load: $error');
          },
        ));

  }

  static void interstitialAd(){
    _interstitialAd?.show();
  }


}