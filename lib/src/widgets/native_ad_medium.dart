import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class NativeAdMediumWidget extends StatefulWidget {
  final String adUnitId;
  final double height;

  const NativeAdMediumWidget({super.key, required this.adUnitId, required this.height});

  @override
  State<NativeAdMediumWidget> createState() => _NativeAdMediumWidgetState();
}

class _NativeAdMediumWidgetState extends State<NativeAdMediumWidget> {
  NativeAd? _nativeAd;
  bool _loaded = false;

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
      factoryId: 'medium',
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
    if (!_loaded) return SizedBox.shrink();

    return SizedBox(height: widget.height, child: AdWidget(ad: _nativeAd!));
  }
}
