import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import '../ads_provider.dart';

class PreloadedBannerAdWidget extends StatelessWidget {
  const PreloadedBannerAdWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AdsProvider>(
      builder: (context, provider, child) {
        final ad = provider.bannerAd;
        final isLoaded = provider.isBannerLoaded;

        if (!isLoaded || ad == null) {
          return const SizedBox.shrink();
        }

        return SizedBox(
          height: ad.size.height.toDouble(),
          child: AdWidget(ad: ad),
        );
      },
    );
  }
}
