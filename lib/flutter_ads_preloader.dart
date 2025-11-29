library flutter_ads_preloader;

import 'package:google_mobile_ads/google_mobile_ads.dart';

export 'src/ads_manager.dart';
export 'src/ads_provider.dart';
export 'src/widgets/banner_ad_widget.dart';
export 'src/widgets/native_ad_small.dart';
export 'src/widgets/native_ad_medium.dart';
export 'src/widgets/native_placeholder.dart';

class FlutterAdsPreloader {
  /// MUST BE CALLED IN main()
  static Future<void> initialize() async {
    await MobileAds.instance.initialize();
  }
}
