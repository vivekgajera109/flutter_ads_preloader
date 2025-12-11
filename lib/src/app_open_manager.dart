import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AppOpenManager with WidgetsBindingObserver {
  static final AppOpenManager _instance = AppOpenManager._internal();
  factory AppOpenManager() => _instance;
  AppOpenManager._internal();

  AppOpenAd? _appOpenAd;
  bool _isShowingAd = false;
  bool _isLoading = false;

  String adUnitId = ""; // Set dynamically

  void initialize(String appOpenId) {
    adUnitId = appOpenId;
    WidgetsBinding.instance.addObserver(this);
    _loadAd();
  }

  // Load App Open Ad
  void _loadAd() {
    if (_isLoading || adUnitId.isEmpty) return;

    _isLoading = true;

    AppOpenAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          _isLoading = false;
        },
        onAdFailedToLoad: (e) {
          _isLoading = false;
          print("AppOpenAd Failed: $e");
        },
      ),
    );
  }

  /// Show when available
  void showAdIfAvailable() {
    if (_appOpenAd == null || _isShowingAd) return;

    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        _loadAd(); // Preload again
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        _loadAd();
      },
    );

    _isShowingAd = true;
    _appOpenAd!.show();
  }

  /// Called when app resumed
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      showAdIfAvailable();
    }
  }
}
