import 'package:flutter/material.dart';
import 'package:flutter_ads_preloader/flutter_ads_preloader.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class BannerAdWidget extends StatefulWidget {
  final double? width;
  const BannerAdWidget({super.key, this.width});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _banner;
  bool _isLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final ads = Provider.of<AdsProvider>(context, listen: false);

    // Create a NEW banner instance for every BannerAdWidget usage
    _banner = BannerAd(
      adUnitId: ads.bannerAd?.adUnitId ?? "",
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() => _isLoaded = true);
        },
        onAdFailedToLoad: (ad, error) {
              print("------>>> Error --> $error");
          setState(() => _isLoaded = false);
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _banner?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Return empty widget if banner not loaded - takes up NO space
    if (_banner == null || !_isLoaded) {
      return const SizedBox.shrink();
    }

    return Container(
      height: _banner!.size.height.toDouble(),
      width: widget.width ?? _banner!.size.width.toDouble(),
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: AdWidget(ad: _banner!),
    );
  }
}
