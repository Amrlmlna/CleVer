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
      debugPrint('[AdService] Ads are disabled via .env');
      return;
    }
    try {
      // Register this specific device as a test device to avoid Error 0 / JavascriptEngine crash
      // This ID was retrieved from the user's console logs
      await MobileAds.instance.updateRequestConfiguration(
        RequestConfiguration(testDeviceIds: ['C02FA2EAD35709DDBBC81E7F501323C1']),
      );

      await MobileAds.instance.initialize();
      debugPrint('[AdService] SDK Initialized successfully');
      _loadInterstitialAd();
    } catch (e) {
      debugPrint('[AdService] Error initializing MobileAds: $e');
    }
  }

  void _loadInterstitialAd() {
    if (!_isEnabled || _adUnitId.isEmpty) {
      debugPrint('[AdService] Skipping load: Ads disabled or Unit ID missing');
      return;
    }

    debugPrint('[AdService] Attempting to load Interstitial Ad: $_adUnitId');

    InterstitialAd.load(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('[AdService] Ad LOADED successfully');
          _interstitialAd = ad;
          _isAdLoaded = true;

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              debugPrint('[AdService] Ad dismissed by user');
              ad.dispose();
              _loadInterstitialAd(); // Preload the next ad
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              debugPrint('[AdService] Ad failed to show: ${error.message}');
              ad.dispose();
              _loadInterstitialAd();
            },
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('[AdService] InterstitialAd FAILED to load: ${error.code} - ${error.message}');
          debugPrint('[AdService] Domain: ${error.domain}');
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
      debugPrint('[AdService] showInterstitialAd skipped: Ads disabled');
      onAdClosed();
      return;
    }

    if (_isAdLoaded && _interstitialAd != null) {
      debugPrint('[AdService] SHOWING ad...');
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          debugPrint('[AdService] Ad closed, triggering callback');
          ad.dispose();
          _loadInterstitialAd();
          onAdClosed(); // Execute callback when ad is closed
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          debugPrint('[AdService] Ad failed to show, triggering callback anyway');
          ad.dispose();
          _loadInterstitialAd();
          onAdClosed(); // Proceed even if ad fails
        },
      );

      await _interstitialAd!.show();
      _isAdLoaded = false;
    } else {
      // If ad isn't ready or failed, just proceed
      debugPrint('[AdService] showInterstitialAd: Ad NOT ready yet, skipping to PDF');
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
