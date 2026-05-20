import 'package:bitirme_mobile/core/locale/app_locale_provider.dart';
import 'package:bitirme_mobile/core/theme/theme_mode_provider.dart';
import 'package:bitirme_mobile/core/services/ml_metadata_loader.dart';
import 'package:bitirme_mobile/core/services/notification_service.dart';
import 'package:bitirme_mobile/firebase_options.dart';
import 'package:bitirme_mobile/service_locator/service_locator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/date_symbol_data_local.dart';

/// Uygulama başlamadan önce çalıştırılması gereken kurulumlar.
final class AppInitializers {
  AppInitializers._();

  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    // DateFormat için yerel tarih/sayı biçim verisi
    await initializeDateFormatting('tr', null);
    await initializeDateFormatting('en', null);
    await setupServiceLocator();
    await sl<MlMetadataLoader>().ensureLoaded();
    await sl<NotificationService>().init();
    await AppLocaleNotifier.preloadFromDisk();
    await ThemeModeNotifier.preloadFromDisk();
  }
}
