import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

final adsServiceProvider = Provider<AdsService>((ref) {
  throw UnimplementedError('AdsService must be overridden');
});

class AdsService {
  AdsService({bool enableAds = _defaultEnableAds}) : _enableAds = enableAds {
    if (_enableAds) {
      _init();
    }
  }

  static const bool _defaultEnableAds = false;

  final bool _enableAds;
  InterstitialAd? _interstitialAd;
  int _roundsSinceAd = 0;

  bool get isEnabled => _enableAds;

  Future<void> _init() async {
    try {
      await MobileAds.instance.initialize();
    } catch (e) {
      debugPrint('Ads initialization failed: $e');
    }
  }

  Future<bool> _isOnline() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Future<void> loadInterstitialIfNeeded() async {
    if (!_enableAds) {
      return;
    }
    if (!await _isOnline()) {
      return;
    }
    if (_interstitialAd != null) {
      return;
    }
    await InterstitialAd.load(
      adUnitId: InterstitialAd.testAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitialAd = ad,
        onAdFailedToLoad: (error) {
          debugPrint('Interstitial failed: $error');
        },
      ),
    );
  }

  Future<void> showInterstitial({void Function()? onDismissed}) async {
    if (!_enableAds) {
      onDismissed?.call();
      return;
    }
    _roundsSinceAd++;
    if (_roundsSinceAd < 2) {
      onDismissed?.call();
      return;
    }
    if (_interstitialAd == null) {
      onDismissed?.call();
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitialAd = null;
        _roundsSinceAd = 0;
        onDismissed?.call();
        loadInterstitialIfNeeded();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('Ad failed to show: $error');
        ad.dispose();
        _interstitialAd = null;
        onDismissed?.call();
      },
    );
    _interstitialAd!.show();
  }

  void dispose() {
    _interstitialAd?.dispose();
  }
}
