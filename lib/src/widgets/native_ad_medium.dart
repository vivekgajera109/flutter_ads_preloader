import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class NativeAdMediumWidget extends StatefulWidget {
  final String adUnitId;

  const NativeAdMediumWidget({super.key, required this.adUnitId});

  @override
  State<NativeAdMediumWidget> createState() => _NativeAdMediumWidgetState();
}

class _NativeAdMediumWidgetState extends State<NativeAdMediumWidget> {
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
      factoryId: "medium",
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          setState(() => _isLoaded = true);
        },
        onAdFailedToLoad: (ad, error) {
              print("------>>> Error --> $error");
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

    return SizedBox(height: 200, child: AdWidget(ad: _nativeAd!));
  }
}
