import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class MediumNativeAdFactory {
  Widget call(NativeAd ad, Map<String, Object>? customOptions) {
    return Container(
      padding: const EdgeInsets.all(10),
      color: Colors.white,
      child: AdWidget(ad: ad),
    );
  }
}
