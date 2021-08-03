import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdmobHelper{
  InterstitialAd _interstitialAd;
  RewardedAd _rewardedAd;
  int attempts = 0;

  void createInterAd(){
    InterstitialAd.load(
    adUnitId: 'ca-app-pub-7497476289867437/8537110502', 
    request: AdRequest(), 
    adLoadCallback: InterstitialAdLoadCallback(
    onAdLoaded: (InterstitialAd ad) {
      // Keep a reference to the ad so you can show it later.
      this._interstitialAd = ad;
      attempts = 0;
      showIntAd();
    },
    onAdFailedToLoad: (LoadAdError error) {
      attempts = attempts +1;
      _interstitialAd = null;

      if(attempts<=2){
        createInterAd();
      }
    },
  ));

  

  }
  void showIntAd(){
    if(_interstitialAd == null){
      return;
    }

    _interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad){
        print("ad onAdshowFullscreen");
      },
      onAdDismissedFullScreenContent: (InterstitialAd ad){
        print("add disposed");
        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad,AdError aderror){
        print('$ad OnAdfailed $aderror');
        ad.dispose();
        // createInterAd();
      }
    );
    _interstitialAd.show();

    _interstitialAd = null;
  }

  void createRewardad(){
    RewardedAd.load(
      adUnitId: 'ca-app-pub-7497476289867437/5790994831',
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          print('$ad loaded.');
          // Keep a reference to the ad so you can show it later.
          this._rewardedAd = ad;
          showRewardAdd();
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('RewardedAd failed to load: $error');
          createInterAd();
        },
    ));
  }
  void showRewardAdd(){
    _rewardedAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) =>
        print('$ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        createInterAd();
      },
      onAdImpression: (RewardedAd ad) => print('$ad impression occurred.'),
    );
    _rewardedAd.show();
  }
}