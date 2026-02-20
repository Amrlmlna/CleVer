import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AdService {
  InterstitialAd? _interstitialAd;
  bool _isAdLoaded = false;
  
  // Test Ad Unit IDs
  static const String _androidTestAdUnitId = 'ca-app-pub-3940256099942544/1033173712';
  static const String _iosTestAdUnitId = 'ca-app-pub-3940256099942544/4411468910';

  String get _adUnitId {
    if (Platform.isAndroid) {
      return dotenv.env['ADMOB_INTERSTITIAL_ANDROID'] ?? _androidTestAdUnitId;
    } else if (Platform.isIOS) {
      return dotenv.env['ADMOB_INTERSTITIAL_IOS'] ?? _iosTestAdUnitId;
    }
    return _androidTestAdUnitId;
  }

  Future<void> init() async {
    await MobileAds.instance.initialize();
    _loadInterstitialAd();
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isAdLoaded = true;
          
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _loadInterstitialAd(); // Preload the next ad
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _loadInterstitialAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          _isAdLoaded = false;
        },
      ),
    );
  }

  Future<void> showInterstitialAd(BuildContext context, {required VoidCallback onAdClosed}) async {
    if (_isAdLoaded && _interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _loadInterstitialAd();
          onAdClosed(); // Execute callback when ad is closed
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _loadInterstitialAd();
          onAdClosed(); // Proceed even if ad fails
        },
      );
      
      await _interstitialAd!.show();
      _isAdLoaded = false;
    } else {
      // If ad isn't ready, just proceed
       onAdClosed();
       _loadInterstitialAd(); // Try loading again for next time
    }
  }
  
  void dispose() {
    _interstitialAd?.dispose();
  }
}

final adService = AdService();
