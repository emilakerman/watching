import 'package:firebase_core/firebase_core.dart';
import 'package:watching/firebase_options.dart';

enum WatchingEnvironment { development, staging, production }

extension WatchingEnvironmentsX on WatchingEnvironment {
  bool get isDevelopment => this == WatchingEnvironment.development;

  bool get isStaging => this == WatchingEnvironment.staging;

  bool get isProduction => this == WatchingEnvironment.production;

  FirebaseOptions get firebaseOptions {
    switch (this) {
      case WatchingEnvironment.development:
        return DefaultFirebaseOptions.currentPlatform;
      case WatchingEnvironment.staging:
        return DefaultFirebaseOptions.currentPlatform;
      case WatchingEnvironment.production:
        return DefaultFirebaseOptions.currentPlatform;
    }
  }
}
