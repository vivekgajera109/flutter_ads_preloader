import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsManager {
  AdsManager._();
  static final AdsManager instance = AdsManager._();

  bool _initialized = false;

  // IDs
  late String bannerId;
  late String interstitialId;
  late String rewardedId;
  late String rewardedInterstitialId;
  late String appOpenId;
  late String nativeSmallId;
  late String nativeMediumId;

  // Ads
  BannerAd? bannerAd;
  InterstitialAd? interstitialAd;
  RewardedAd? rewardedAd;
  RewardedInterstitialAd? rewardedInterstitialAd;
  AppOpenAd? appOpenAd;
  NativeAd? nativeSmall;
  NativeAd? nativeMedium;
  // Flags
  bool isBannerLoaded = false;
  bool isInterstitialLoaded = false;
  bool isRewardedLoaded = false;
  bool isRewardedInterstitialLoaded = false;
  bool isAppOpenLoaded = false;
  bool isNativeSmallLoaded = false;
  bool isNativeMediumLoaded = false;
  // ✅ Assign IDs only once
  void setAdIds({
    required String bannerId,
    required String interstitialId,
    required String rewardedId,
    required String rewardedInterstitialId,
    required String appOpenId,
    required String nativeSmallId,
    required String nativeMediumId,
  }) {
    this.bannerId = bannerId;
    this.interstitialId = interstitialId;
    this.rewardedId = rewardedId;
    this.rewardedInterstitialId = rewardedInterstitialId;
    this.appOpenId = appOpenId;
    this.nativeSmallId = nativeSmallId;
    this.nativeMediumId = nativeMediumId;
  }

  // ✅ Initialize SDK + Preload Ads
  Future<void> initialize() async {
    if (_initialized) return;
    await MobileAds.instance.initialize();
    _initialized = true;

    loadBanner();
    loadInterstitial();
    loadRewarded();
    loadRewardedInterstitial();
    loadAppOpen();
    loadNativeSmall();
    loadNativeMedium();
  }

  // ✅ Interstitial with close callback
  void loadInterstitial() {
    InterstitialAd.load(
      adUnitId: interstitialId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          interstitialAd = ad;
          isInterstitialLoaded = true;
        },
        onAdFailedToLoad: (e) {
          isInterstitialLoaded = false;
          print(e);
        },
      ),
    );
  }

  void showInterstitial({required VoidCallback? onClosed}) {
    if (!isInterstitialLoaded || interstitialAd == null) {
      onClosed?.call(); // continue flow without ad
      return;
    }

    interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        isInterstitialLoaded = false;
        loadInterstitial();
        onClosed?.call(); // continue flow without ad
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        isInterstitialLoaded = false;
        loadInterstitial();
        onClosed?.call(); // continue flow without ad
      },
    );

    interstitialAd!.show();
  }

  // ✅ Rewarded
  void loadRewarded() {
    RewardedAd.load(
      adUnitId: rewardedId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          rewardedAd = ad;
          isRewardedLoaded = true;
        },
        onAdFailedToLoad: (e) {
          isRewardedLoaded = false;
          print(e);
        },
      ),
    );
  }

  void showRewarded({
    required Function(int reward) onReward,
    required VoidCallback onClosed,
  }) {
    if (!isRewardedLoaded || rewardedAd == null) {
      onClosed();
      return;
    }

    rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        isRewardedLoaded = false;
        loadRewarded();
        onClosed();
      },
    );

    rewardedAd!.show(
      onUserEarnedReward: (_, reward) => onReward(reward.amount.toInt()),
    );
  }

  // ✅ Rewarded Interstitial
  void loadRewardedInterstitial() {
    RewardedInterstitialAd.load(
      adUnitId: rewardedInterstitialId,
      request: const AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          rewardedInterstitialAd = ad;
          isRewardedInterstitialLoaded = true;
        },
        onAdFailedToLoad: (e) {
          print(e);
          isRewardedInterstitialLoaded = false;
        },
      ),
    );
  }

  void showRewardedInterstitial({
    required Function(int reward) onReward,
    required VoidCallback onClosed,
  }) {
    if (!isRewardedInterstitialLoaded || rewardedInterstitialAd == null) {
      onClosed();
      return;
    }

    rewardedInterstitialAd!.fullScreenContentCallback =
        FullScreenContentCallback(
          onAdDismissedFullScreenContent: (ad) {
            ad.dispose();
            isRewardedInterstitialLoaded = false;
            loadRewardedInterstitial();
            onClosed();
          },
        );

    rewardedInterstitialAd!.show(
      onUserEarnedReward: (_, reward) => onReward(reward.amount.toInt()),
    );
  }

  // ✅ App Open Ad
  void loadAppOpen() {
    AppOpenAd.load(
      adUnitId: appOpenId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          appOpenAd = ad;
          isAppOpenLoaded = true;
        },
        onAdFailedToLoad: (e) {
          print(e);
          isAppOpenLoaded = false;
        },
      ),
    );
  }

  void showAppOpen({required VoidCallback onClosed}) {
    if (!isAppOpenLoaded || appOpenAd == null) {
      onClosed();
      return;
    }

    appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        isAppOpenLoaded = false;
        loadAppOpen();
        onClosed();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        isAppOpenLoaded = false;
        loadAppOpen();
        onClosed();
      },
    );

    appOpenAd!.show();
  }
  ///////////////////

  // ------------------ BANNER ------------------

  void loadBanner() {
    bannerAd?.dispose();

    bannerAd = BannerAd(
      adUnitId: bannerId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) => isBannerLoaded = true,
        onAdFailedToLoad: (ad, error) {
          isBannerLoaded = false;
          ad.dispose();
          print("Banner error: $error");
        },
      ),
    )..load();
  }

  // ------------------ NATIVE SMALL ------------------

  void loadNativeSmall() {
    nativeSmall?.dispose();

    nativeSmall = NativeAd(
      adUnitId: nativeSmallId,
      factoryId: 'small',
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (_) => isNativeSmallLoaded = true,
        onAdFailedToLoad: (ad, error) {
          isNativeSmallLoaded = false;
          ad.dispose();
          print("Native small error: $error");
        },
      ),
    )..load();
  }

  // ------------------ NATIVE MEDIUM ------------------

  void loadNativeMedium() {
    nativeMedium?.dispose();

    nativeMedium = NativeAd(
      adUnitId: nativeMediumId,
      factoryId: 'medium',
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (_) => isNativeMediumLoaded = true,
        onAdFailedToLoad: (ad, error) {
          isNativeMediumLoaded = false;
          ad.dispose();
          print("Native medium error: $error");
        },
      ),
    )..load();
  }

  //////////////////
  // ✅ Clean Memory
  void disposeAll() {
    bannerAd?.dispose();
    interstitialAd?.dispose();
    rewardedAd?.dispose();
    rewardedInterstitialAd?.dispose();
    appOpenAd?.dispose();
    nativeSmall?.dispose();
    nativeMedium?.dispose();
  }
}
