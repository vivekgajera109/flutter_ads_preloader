import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'ads_manager.dart';

class AdsProvider extends ChangeNotifier {
  late AdsManager _manager;

  bool isShow = true; // ✅ Firebase toggle — default ON

  AdsProvider();

  Future<void> loadConfig(Map<String, dynamic> config) async {
    isShow = config["isShow"] ?? true;

    _manager = AdsManager.instance
      ..onAdLoadedCallback = notifyListeners
      ..setAdIds(
        bannerId: config["bannerId"] ?? "",
        interstitialId: config["interstitialId"] ?? "",
        rewardedId: config["rewardedId"] ?? "",
        rewardedInterstitialId: config["rewardedInterstitialId"] ?? "",
        appOpenId: config["appOpenId"] ?? "",
        nativeSmallId: config["nativeId"] ?? "",
        nativeMediumId: config["nativeId"] ?? "",
      );

    if (isShow) {
      await _manager.initialize();
    }

    notifyListeners();
  }

  // ✅ Banner
  bool get isBannerLoaded => isShow && _manager.isBannerLoaded;
  BannerAd? get bannerAd => isShow && _manager.isBannerLoaded ? _manager.bannerAd : null;

  // Small Native
  bool get isNativeSmallLoaded => isShow && _manager.isNativeSmallLoaded;
  NativeAd? get nativeSmall => isShow && _manager.isNativeSmallLoaded ? _manager.nativeSmall : null;

  // Medium Native
  bool get isNativeMediumLoaded => isShow && _manager.isNativeMediumLoaded;
  NativeAd? get nativeMedium => isShow && _manager.isNativeMediumLoaded ? _manager.nativeMedium : null;

  // ✅ Interstitial
  void showInterstitial({VoidCallback? onClosed}) {
    if (!isShow) {
      onClosed?.call();
      return;
    }
    _manager.showInterstitial(onClosed: onClosed);
  }

  // ✅ Rewarded
  void showRewarded({
    required Function(int reward) onReward,
    required VoidCallback onClosed,
  }) {
    if (!isShow) {
      onClosed();
      return;
    }
    _manager.showRewarded(onReward: onReward, onClosed: onClosed);
  }

  // ✅ Rewarded Interstitial
  void showRewardedInterstitial({
    required Function(int reward) onReward,
    required VoidCallback onClosed,
  }) {
    if (!isShow) {
      onClosed();
      return;
    }
    _manager.showRewardedInterstitial(onReward: onReward, onClosed: onClosed);
  }

  // ✅ App Open
  void showAppOpen({required VoidCallback onClosed}) {
    if (!isShow) {
      onClosed();
      return;
    }
    _manager.showAppOpen(onClosed: onClosed);
  }

  @override
  void dispose() {
    _manager.disposeAll();
    super.dispose();
  }

  Future<bool> showInterstitialWithLoading(BuildContext context) async {
    if (!isShow) return true;

    bool shouldContinue = false;

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    // Load Ad
    _manager.loadInterstitial();

    // Wait for ad to load max 3 sec
    await Future.delayed(const Duration(seconds: 3));

    // SHOW Ad With "onClosed"
    _manager.showInterstitial();
    shouldContinue = true;
    Navigator.of(context, rootNavigator: true).pop(); // CLOSE dialog
    // Wait until user closes ad
    // while (!shouldContinue) {
    //   await Future.delayed(const Duration(milliseconds: 100));
    // }

    return shouldContinue;
  }

  Future<void> loadInterstitialSafe() async {
    _manager.loadInterstitial(); // void method
    await Future.delayed(Duration(milliseconds: 100));
  }

  Future<void> showInterstitialSafe() async {
    _manager.showInterstitial(); // void method
    await Future.delayed(Duration(milliseconds: 200));
  }
}
