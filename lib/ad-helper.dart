import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';

class AdHelper {
  static String get interstitialAdUnitId {
    if (kDebugMode) {
      if (Platform.isAndroid) {
        return 'ca-app-pub-3940256099942544/1033173712';
      } else if (Platform.isIOS) {
        return 'ca-app-pub-3940256099942544/4411468910';
      }
    } else {
      if (Platform.isAndroid) {
        return dotenv.env['GOOGLE_AD_ANDROID_UNIT_ID']!;
      } else if (Platform.isIOS) {
        return dotenv.env['GOOGLE_AD_IOS_UNIT_ID']!;
      }
    }
    throw UnsupportedError('Unsupported platform');
  }

  static Future<InitializationStatus> initGoogleMobileAds() {
    // TODO: Initialize Google Mobile Ads SDK
    return MobileAds.instance.initialize();
  }
}
