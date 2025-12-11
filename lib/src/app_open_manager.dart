import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AppOpenManager {
  static final AppOpenManager _instance = AppOpenManager._internal();
  factory AppOpenManager() => _instance;

  AppOpenManager._internal();

  AppOpenAd? _appOpenAd;
  bool _isLoading = false;
  bool _isShowingAd = false;

  late String adUnitId;

  // Initialize with remote config Ad ID
  void initialize(String id) {
    adUnitId = id;
    _loadAd();
  }

  void _loadAd() {
    if (_isLoading) return;

    _isLoading = true;

    AppOpenAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          _isLoading = false;
        },
        onAdFailedToLoad: (error) {
          _isLoading = false;
          // Retry after failure
          Future.delayed(const Duration(seconds: 5), _loadAd);
        },
      ),
    );
  }

  void showAdIfAvailable(VoidCallback onComplete) {
    if (_isShowingAd) {
      onComplete();
      return;
    }

    if (_appOpenAd == null) {
      onComplete();
      _loadAd();
      return;
    }

    _isShowingAd = true;

    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        _loadAd();
        onComplete();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        _loadAd();
        onComplete();
      },
    );

    _appOpenAd!.show();
  }
}
