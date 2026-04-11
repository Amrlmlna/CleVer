import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AdService {
  RewardedInterstitialAd? _rewardedInterstitialAd;
  bool _isAdLoaded = false;
  bool _isLoading = false;

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
      // Register test device
      await MobileAds.instance.updateRequestConfiguration(
        RequestConfiguration(
          testDeviceIds: ['C02FA2EAD35709DDBBC81E7F501323C1'],
        ),
      );

      await MobileAds.instance.initialize();
      debugPrint('[AdService] SDK Initialized successfully');
      _loadRewardedInterstitialAd();
    } catch (e) {
      debugPrint('[AdService] Error initializing MobileAds: $e');
    }
  }

  void _loadRewardedInterstitialAd() {
    if (!_isEnabled || _adUnitId.isEmpty || _isLoading) return;

    _isLoading = true;
    debugPrint('[AdService] Attempting to load Rewarded Interstitial Ad: $_adUnitId');

    RewardedInterstitialAd.load(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('[AdService] Rewarded Interstitial Ad LOADED');
          _rewardedInterstitialAd = ad;
          _isAdLoaded = true;
          _isLoading = false;

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              debugPrint('[AdService] Ad dismissed');
              ad.dispose();
              _isAdLoaded = false;
              _loadRewardedInterstitialAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              debugPrint('[AdService] Ad failed to show: ${error.message}');
              ad.dispose();
              _isAdLoaded = false;
              _loadRewardedInterstitialAd();
            },
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('[AdService] Rewarded Interstitial FAILED to load: ${error.code} - ${error.message}');
          _isAdLoaded = false;
          _isLoading = false;
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

    // --- Wait Mechanic ---
    int retryCount = 0;
    while (!_isAdLoaded && _isLoading && retryCount < 10) {
      debugPrint('[AdService] Ad is still loading, waiting... ($retryCount)');
      await Future.delayed(const Duration(milliseconds: 500));
      retryCount++;
    }

    if (_isAdLoaded && _rewardedInterstitialAd != null) {
      debugPrint('[AdService] SHOWING Rewarded Interstitial...');
      _rewardedInterstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _isAdLoaded = false;
          _loadRewardedInterstitialAd();
          onAdClosed();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _isAdLoaded = false;
          _loadRewardedInterstitialAd();
          onAdClosed();
        },
      );

      await _rewardedInterstitialAd!.show(
        onUserEarnedReward: (ad, reward) {
          debugPrint('[AdService] User earned reward: ${reward.amount} ${reward.type}');
        },
      );
    } else {
      debugPrint('[AdService] Ad not ready after waiting, skipping to PDF');
      onAdClosed();
      _loadRewardedInterstitialAd();
    }
  }

  void dispose() {
    _rewardedInterstitialAd?.dispose();
  }
}

final adService = AdService();
