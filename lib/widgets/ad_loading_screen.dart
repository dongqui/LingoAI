import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import '../providers/diary_input_provider.dart';
import 'package:go_router/go_router.dart';

class AdLoadingScreen extends StatefulWidget {
  const AdLoadingScreen({super.key});

  @override
  State<AdLoadingScreen> createState() => _AdLoadingScreenState();
}

class _AdLoadingScreenState extends State<AdLoadingScreen> {
  // InterstitialAd? _interstitialAd;
  bool _isAdDone = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    // 광고 로딩 스킵하고 바로 완료 상태로 설정
    setState(() {
      _isAdDone = true;
    });

    // 기존 광고 로딩 코드 주석 처리
    /*
    InterstitialAd.load(
      adUnitId: 'your_ad_unit_id_here',
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (_) {
              setState(() {
                _isAdDone = true;
              });
            },
          );
          ad.show();
        },
        onAdFailedToLoad: (error) {
          setState(() {
            _isAdDone = true;
          });
          debugPrint('Ad load failed: $error');
        },
      ),
    );
    */
  }

  @override
  void dispose() {
    // _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DiaryInputProvider>(
      builder: (context, provider, child) {
        // Close the page once image generation is complete

        if (!provider.isGeneratingImage && mounted && _isAdDone) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.replace('/image-generation');
          });
        }

        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(
                  color: Color(0xFF4D4EE8),
                ),
                const SizedBox(height: 20),
                Text(
                  'Generating image...',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
