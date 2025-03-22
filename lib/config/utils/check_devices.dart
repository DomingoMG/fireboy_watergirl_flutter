

import 'package:flutter/foundation.dart';

class CheckDevices {
  static bool get isMobile {
    return defaultTargetPlatform == TargetPlatform.iOS 
    || defaultTargetPlatform == TargetPlatform.android;
  }
}