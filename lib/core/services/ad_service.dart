import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AdService {
  InterstitialAd? _interstitialAd;
  bool _isAdLoaded = false;

  bool get _isEnabled => dotenv.env['ENABLE_ADS'] == 'true';

  String get _adUnitId {
    if (Platform.isAndroid) {
      return dotenv.env['ADMOB_INTERSTITIAL_ANDROID'] ?? '';
    } else if (Platform.isIOS) {
      return dotenv.env['ADMOB_INTERSTITIAL_IOS'] ?? '';
    }
    return '';
  }

  Future<void> init() async {
    if (!_isEnabled) {
      debugPrint('Ads are disabled via .env');
      return;
    }
    try {
      await MobileAds.instance.initialize();
      _loadInterstitialAd();
    } catch (e) {
      debugPrint('Error initializing MobileAds: $e');
    }
  }

  void _loadInterstitialAd() {
    if (!_isEnabled || _adUnitId.isEmpty) return;

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
          debugPrint('InterstitialAd failed to load: $error');
          _isAdLoaded = false;
        },
      ),
    );
  }

  Future<void> showInterstitialAd(
    BuildContext context, {
    required VoidCallback onAdClosed,
  }) async {
    if (!_isEnabled) {
      onAdClosed();
      return;
    }

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
      // If ad isn't ready or failed, just proceed
      onAdClosed();
      if (_isEnabled) {
        _loadInterstitialAd(); // Try loading again for next time
      }
    }
  }

  void dispose() {
    _interstitialAd?.dispose();
  }
}

final adService = AdService();
