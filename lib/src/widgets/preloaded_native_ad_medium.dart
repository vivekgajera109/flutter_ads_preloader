import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import '../ads_provider.dart';
import 'native_placeholder.dart';

class PreloadedNativeAdMediumWidget extends StatelessWidget {
  final Widget placeholder;

  const PreloadedNativeAdMediumWidget({
    super.key,
    this.placeholder = const NativePlaceholder(height: 350),
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AdsProvider>(
      builder: (context, provider, child) {
        final ad = provider.nativeMedium;
        final isLoaded = provider.isNativeMediumLoaded;

        if (!isLoaded || ad == null) {
          return placeholder;
        }

        return SizedBox(
          height: 350,
          child: AdWidget(ad: ad),
        );
      },
    );
  }
}
