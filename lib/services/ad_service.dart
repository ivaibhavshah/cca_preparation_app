import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class AdService {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return dotenv.get('ANDROID_BANNER_AD_ID', fallback: 'ca-app-pub-3940256099942544/6300978111');
    } else if (Platform.isIOS) {
      return dotenv.get('IOS_BANNER_AD_ID', fallback: 'ca-app-pub-3940256099942544/2934735716');
    }
    return '';
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return dotenv.get('ANDROID_INTERSTITIAL_AD_ID', fallback: 'ca-app-pub-3940256099942544/1033173712');
    } else if (Platform.isIOS) {
      return dotenv.get('IOS_INTERSTITIAL_AD_ID', fallback: 'ca-app-pub-3940256099942544/4411468910');
    }
    return '';
  }

  static Future<void> initialize() async {
    if (Platform.isAndroid) {
      await MobileAds.instance.initialize();
    }
  }

  static BannerAd createBannerAd({
    required void Function(Ad) onAdLoaded,
    required void Function(Ad, LoadAdError) onAdFailedToLoad,
  }) {
    return BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: onAdLoaded,
        onAdFailedToLoad: onAdFailedToLoad,
      ),
    );
  }

  static void loadInterstitialAd({
    required void Function(InterstitialAd) onAdLoaded,
    required void Function(LoadAdError) onAdFailedToLoad,
  }) {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: onAdLoaded,
        onAdFailedToLoad: onAdFailedToLoad,
      ),
    );
  }
}
