// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter_ads_preloader/flutter_ads_preloader.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(const ExampleApp());
// }

// class ExampleApp extends StatelessWidget {
//   const ExampleApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [ChangeNotifierProvider(create: (_) => AdsProvider()..init())],
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         home: Scaffold(
//           appBar: AppBar(title: const Text('All Ads Example')),
//           body: const ExampleHome(),
//         ),
//       ),
//     );
//   }
// }

// class ExampleHome extends StatelessWidget {
//   const ExampleHome({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final ads = Provider.of<AdsProvider>(context);

//     return Column(
//       children: [
//         Expanded(
//           child: ListView(
//             padding: const EdgeInsets.all(20),
//             children: [
//               const Text(
//                 'This screen demonstrates all Google Ads types:',
//                 style: TextStyle(fontSize: 18),
//               ),
//               const SizedBox(height: 20),

//               // ===============================
//               // NATIVE AD
//               // ===============================
//               const Text("Native Ad:"),
//               const SizedBox(height: 10),
//               ads.isNativeLoaded
//                   ? const NativeAdWidget(height: 150)
//                   : const Text("Loading native ad..."),
//               const SizedBox(height: 40),

//               // ===============================
//               // INTERSTITIAL
//               // ===============================
//               ElevatedButton(
//                 onPressed: ads.isInterstitialLoaded
//                     ? () => ads.showInterstitial()
//                     : null,
//                 child: const Text('Show Interstitial Ad'),
//               ),
//               const SizedBox(height: 20),

//               // ===============================
//               // REWARDED
//               // ===============================
//               ElevatedButton(
//                 onPressed: ads.isRewardedLoaded
//                     ? () => ads.showRewarded(
//                         (amount) => debugPrint("Reward Earned: $amount"),
//                       )
//                     : null,
//                 child: const Text("Show Rewarded Ad"),
//               ),
//               const SizedBox(height: 20),

//               // ===============================
//               // REWARDED INTERSTITIAL
//               // ===============================
//               ElevatedButton(
//                 onPressed: ads.isRewardedInterstitialLoaded
//                     ? () => ads.showRewardedInterstitial(
//                         (amount) =>
//                             debugPrint("Rewarded Interstitial: $amount"),
//                       )
//                     : null,
//                 child: const Text("Show Rewarded Interstitial Ad"),
//               ),
//               const SizedBox(height: 20),

//               // ===============================
//               // APP OPEN
//               // ===============================
//               ElevatedButton(
//                 onPressed: ads.isAppOpenLoaded ? () => ads.showAppOpen() : null,
//                 child: const Text("Show App Open Ad"),
//               ),
//             ],
//           ),
//         ),

//         // ===============================
//         // BANNER AT BOTTOM
//         // ===============================
//         const BannerAdWidget(),
//       ],
//     );
//   }
// }
