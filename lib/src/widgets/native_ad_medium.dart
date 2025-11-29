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
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _nativeAd = NativeAd(
      adUnitId: widget.adUnitId,
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (_) => setState(() => _loaded = true),
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          setState(() => _loaded = false);
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
    if (!_loaded) return const SizedBox.shrink();

    return SizedBox(height: 250, child: AdWidget(ad: _nativeAd!));
  }
}
