import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class NativeAdSmallWidget extends StatefulWidget {
  final String adUnitId;

  const NativeAdSmallWidget({super.key, required this.adUnitId});

  @override
  State<NativeAdSmallWidget> createState() => _NativeAdSmallWidgetState();
}

class _NativeAdSmallWidgetState extends State<NativeAdSmallWidget> {
  NativeAd? _nativeAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    _nativeAd?.dispose();

    _nativeAd = NativeAd(
      adUnitId: widget.adUnitId,
      request: const AdRequest(),
      factoryId: 'small',
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          setState(() => _isLoaded = true);
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          setState(() => _isLoaded = false);
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded) return const SizedBox.shrink();

    return SizedBox(height: 130, child: AdWidget(ad: _nativeAd!));
  }
}
