import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import '../ads_provider.dart';
import 'native_placeholder.dart';

class PreloadedNativeAdSmallWidget extends StatelessWidget {
  final Widget placeholder;

  const PreloadedNativeAdSmallWidget({
    super.key,
    this.placeholder = const NativePlaceholder(height: 130),
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AdsProvider>(
      builder: (context, provider, child) {
        final ad = provider.nativeSmall;
        final isLoaded = provider.isNativeSmallLoaded;

        if (!isLoaded || ad == null) {
          return placeholder;
        }

        return SizedBox(
          height: 130,
          child: AdWidget(ad: ad),
        );
      },
    );
  }
}
