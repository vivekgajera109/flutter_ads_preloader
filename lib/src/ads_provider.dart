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
      ..setAdIds(
        bannerId: config["bannerId"] ?? "",
        interstitialId: config["interstitialId"] ?? "",
        rewardedId: config["rewardedId"] ?? "",
        rewardedInterstitialId: config["rewardedInterstitialId"] ?? "",
        appOpenId: config["appOpenId"] ?? "",
        nativeSmallId: config["nativeId"],
        nativeMediumId: config["nativeId"],
      );

    if (isShow) {
      await _manager.initialize();
    }

    notifyListeners();
  }

  // ✅ Banner
  bool get isBannerLoaded => isShow && _manager.isBannerLoaded;
  BannerAd? get bannerAd => isShow ? _manager.bannerAd : null;

  // Small Native
  NativeAd? get nativeSmall => isShow ? _manager.nativeSmall : null;

  // Medium Native
  NativeAd? get nativeMedium => isShow ? _manager.nativeMedium : null;

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

  Future<void> showInterstitialWithLoading(BuildContext context) async {
    if (!isShow) return;

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    // Load ad (safe wrapper)
    await loadInterstitialSafe();

    // Show Ad
    await showInterstitialSafe();

    // Close dialog
    // ignore: use_build_context_synchronously
    Navigator.of(context, rootNavigator: true).pop();
  }

  Future<void> loadInterstitialSafe() async {
    _manager.loadInterstitial(); // void method
    await Future.delayed(Duration(milliseconds: 300));
  }

  Future<void> showInterstitialSafe() async {
    _manager.showInterstitial(); // void method
    await Future.delayed(Duration(milliseconds: 300));
  }
}
