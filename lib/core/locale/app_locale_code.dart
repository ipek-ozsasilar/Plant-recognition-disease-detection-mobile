import 'dart:ui';

import 'package:bitirme_mobile/core/locale/app_locale_mode.dart';

/// API ve önbellek için `tr` / `en` dil kodu.
String appLocaleCodeFor(AppLocaleMode mode) {
  return switch (mode) {
    AppLocaleFixed(:final Locale locale) =>
      locale.languageCode == 'en' ? 'en' : 'tr',
    AppLocaleFollowSystem() => _systemLanguageCode(),
    AppLocaleUnset() => 'tr',
  };
}

String _systemLanguageCode() {
  final String code = PlatformDispatcher.instance.locale.languageCode;
  return code == 'en' ? 'en' : 'tr';
}
