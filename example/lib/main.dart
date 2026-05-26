import 'package:flutter/material.dart';
import 'package:flutter_ads_preloader/flutter_ads_preloader.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. Initialize Google Mobile Ads SDK through the package
  await FlutterAdsPreloader.initialize();

  runApp(
    ChangeNotifierProvider(
      create: (_) => AdsProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ads Preloader Example',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // 2. Load Ad Configuration with Test IDs (Google Mobile Ads Test IDs)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final config = {
        "isShow": true,
        "bannerId": "ca-app-pub-3940256099942544/6300978111",
        "nativeId": "ca-app-pub-3940256099942544/2247696110",
        "interstitialId": "ca-app-pub-3940256099942544/1033173712",
        "rewardedId": "ca-app-pub-3940256099942544/5224354917",
        "rewardedInterstitialId": "ca-app-pub-3940256099942544/5354046379",
        "appOpenId": "ca-app-pub-3940256099942544/9257395921",
      };
      
      // Load configuration and trigger preloading automatically
      context.read<AdsProvider>().loadConfig(config);
    });
  }

  @override
  Widget build(BuildContext context) {
    final adsProvider = Provider.of<AdsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Ads Preloader'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status Section
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Preloaded Ads Status:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const Divider(),
                    _buildStatusRow('Banner Ad', adsProvider.isBannerLoaded),
                    _buildStatusRow('Native Small Ad', adsProvider.isNativeSmallLoaded),
                    _buildStatusRow('Native Medium Ad', adsProvider.isNativeMediumLoaded),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Action Buttons for Interstitial & Rewarded Ads
            ElevatedButton.icon(
              onPressed: () {
                adsProvider.showInterstitial(
                  onClosed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Interstitial Ad Closed / Proceeding Flow')),
                    );
                  },
                );
              },
              icon: const Icon(Icons.slideshow),
              label: const Text('Show Interstitial Ad'),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                adsProvider.showRewarded(
                  onReward: (amount) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('User earned reward: $amount coins!')),
                    );
                  },
                  onClosed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Rewarded Ad Closed')),
                    );
                  },
                );
              },
              icon: const Icon(Icons.emoji_events),
              label: const Text('Show Rewarded Ad'),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                adsProvider.showAppOpen(
                  onClosed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('App Open Ad Closed')),
                    );
                  },
                );
              },
              icon: const Icon(Icons.open_in_new),
              label: const Text('Show App Open Ad'),
            ),
            const SizedBox(height: 24),

            // 3. Render Preloaded Banner Ad
            const Text(
              'Preloaded Banner Ad:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const PreloadedBannerAdWidget(),
            const SizedBox(height: 24),

            // 4. Render Preloaded Small Native Ad (Using factoryId: 'small')
            const Text(
              'Preloaded Small Native Ad (Custom Android UI):',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const PreloadedNativeAdSmallWidget(),
            const SizedBox(height: 24),

            // 5. Render Preloaded Medium Native Ad (Using factoryId: 'medium')
            const Text(
              'Preloaded Medium Native Ad (Custom Android UI):',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const PreloadedNativeAdMediumWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(String label, bool isLoaded) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Icon(
            isLoaded ? Icons.check_circle : Icons.pending,
            color: isLoaded ? Colors.green : Colors.orange,
          ),
        ],
      ),
    );
  }
}
